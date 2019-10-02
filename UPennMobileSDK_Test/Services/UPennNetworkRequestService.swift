//
//  UPennNetworkRequestService.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/12/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import Alamofire

/**
 Completion block representing data returned from network request
 - parameters:
     - responseJSON: optional response object returned from request
     - errorString: optional error String returned from request
     - delete: Bool indicating the request is a deletion type
 */
typealias RequestCompletion = (_ responseJSON: Any?, _ errorString: String?)->Void
typealias ScanSubmitCompletion = (_ errorString: String?)->Void

/// Defines required properties for a custom Configuration class
protocol UPennEnvironmentConfigurable : class {
    var root: String { get }
    var apiEndpoint: String { get }
    var loginEndpoint: String { get }
    var clientID: String { get }
    var templateID: String { get }
    var incidentEndpoint: String { get }
    var attachmentsEndpoint: String { get }
}

class UPennNetworkRequestService {
    
    private let appConfigAPIStr = "https://www1.pennmedicine.org/MAppCnfg/api"

    private var configuration : Configuration {
        /*
         Environment configurations:
         - BETA Dev & Distro run on Staging
         - Debug & Release run on Production
         */
        switch AppDelegate.RunState {
        case .DEBUG, .RELEASE: return Configuration_Closed_Internal()
        default: return Configuration_Stage()
        }
    }
    private let defaultManager: SessionManager = {
        let serverTrustPolicies = [String:ServerTrustPolicy]()
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        return SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
    }()
    
    private static let StatusCodeError = "Cannot get a Status Code for your Request. Please try again."
    private static let GenericRequestError = "Something went wrong with your Request. Please try again."
    private static let NetworkError = "Lost connection to PennMedicine WiFi."
    
    /**
     Login User
     - parameters:
        - username: Penn username associated with device
        - password: Password for Penn User
        - completion: block returning optional response JSON, error String, and delete Bool
    */
    func makeLoginRequest(username: String, password: String, completion: @escaping (RequestCompletion)) {
        
        let parameters: Parameters = [
            "client_id" : self.configuration.clientID,
            "grant_type" : "password",
            "username" : username,
            "password" : password
        ]
        
        // Make Request for JWT
        let jwtRequest = defaultManager.request(self.configuration.loginEndpoint, method: .post, parameters: parameters, encoding: URLEncoding.httpBody)
        jwtRequest.responseJSON { (response) in
            self.unwrapResponseForStatusCode(response, completion: completion)
        }
    }
    
    /**
     Create Ticket in Athena
     - parameters:
         - createdTime: Human-readable date-time String representing when ticket is created
         - comment: Optional comment with additional information for scanned item
         - completion: block returning optional response JSON and error String
     */
    func createTicket(_ ticket: UTSTicket, completion: @escaping (RequestCompletion)) {
        var parameters: Parameters = [
            "title" : "Unable To Scan -- \(ticket.createdTime)",
            "templateID" : self.configuration.templateID,
            "affectedUser" : [
                "username" : UPennAuthenticationService.PennUserName
                ],
        ]
        
        // Make Description and Unwrap optional comment
        parameters["description"] = "Submitted via UPHS ScanFail App\n\nReason: \(ticket.scanContext.rawValue)."
        if let _comment = ticket.comment {
            var currentDescr = parameters["description"] as! String
            currentDescr += "\n\n\(_comment)"
            parameters["description"] = currentDescr
        }
        
        
        let createIncidentRequest = defaultManager.request(self.configuration.incidentEndpoint, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: self.headers)
        createIncidentRequest.responseJSON { (response) in
            self.unwrapResponseForStatusCode(response, completion: completion)
        }
    }
    
    /**
     Submit image as attachment to ticket
     - parameters:
         - payload: object encapsulating various image and ticket attributes for a scanned item
         - completion: block returning optional response JSON and error String
     */
    func submitScannedInfo(_ payload: ScanSubmitPayload, completion: @escaping (RequestCompletion)) {
        guard let imageData = payload.imageData else {
            completion(nil,"Error getting Image data. Please try again.");return
        }
        let attachmentsURL = self.configuration.attachmentsEndpoint+"/\(payload.entityId)"
        
        Alamofire.upload(multipartFormData: {
            multipartFormData in
            multipartFormData.append(
                imageData,
                withName: "AddAttachment",
                fileName: payload.filename,
                mimeType: "image/jpeg")
        },
        to: attachmentsURL,
        method: .post,
        headers: self.headers,
        encodingCompletion: {
            result in
            
            switch result {
            case .success(let request, _,  _):
                request.responseJSON(completionHandler: { (response) in
                    self.unwrapResponseForStatusCode(response, completion: completion)
                })
            case .failure( let error):
                completion(nil,error.localizedDescription)
                break
            }
        })
    }
    
    func checkLatestAppVersion(completion: @escaping (_ settings: DataResponse<Any>)->Void) {
        let bundleID = UPennConfigurationsService.BundleID
        let parameters: Parameters = [ "id" : bundleID ]
        let requestURI = self.appConfigAPIStr + "/version"
        let headers: HTTPHeaders =
        [
            "x-api-key" : "873CABFD-DC87-45E0-8B1B-F0A94F29827E"
        ]
        let searchRequest = defaultManager.request(requestURI, parameters: parameters, headers: headers)
        searchRequest.responseJSON { (response) in
            completion(response)
        }
    }
}

private extension UPennNetworkRequestService {
    
    /**
     Object holds references to various API endpoints, that dynamically update upon initialization, depending on the current app run-state--e.g. 'Release', 'Debug', etc.
     */
    class Configuration : UPennEnvironmentConfigurable {
        
        // Required
        var root: String { return Bundle.main.object(forInfoDictionaryKey: "API_URL_ENDPOINT") as! String }
        var apiEndpoint: String { return "\(self.root)/api" }
        var loginEndpoint: String { return "\(self.apiEndpoint)/token" }
        var incidentEndpoint: String { return "\(self.apiEndpoint)/incident" }
        var attachmentsEndpoint: String { return "\(self.apiEndpoint)/attachments" }
        var clientID : String { return  "CRIOSApp_e0aa3b48046543088b4329e572063997" }
        var templateID: String { return "47729268-CB59-93B6-36B4-18C24219DC74" }
        
        //Custom
        let appConfigAPIStr = "https://www1.pennmedicine.org/MAppCnfg/api/version"
    }
    
    /// APIConfiguration set specifically for only on-site accessible API endpoints
    class Configuration_Closed_Internal : Configuration_Stage {
        override var root: String { return "https://uphsnet.uphs.upenn.edu/athenaapi" }
    }
    
    /// APIConfiguration for Staging Environment
    class Configuration_Stage : Configuration {
        override var loginEndpoint: String { return "\(self.root)/oauth2/token" }
        override var apiEndpoint: String { return "\(self.root)/v1" }
    }
    
    var authToken: String? {
        return UPennAuthenticationService.AuthToken
    }
    
    var headers: HTTPHeaders {
        guard let token = self.authToken else { return [:] }
        return [ "Authorization" : "Bearer " + token ]
    }
    
    func unwrapResponseForStatusCode(_ response: DataResponse<Any>, delete: Bool=false, completion: (RequestCompletion)) {
        let hostServerError = "A server with the specified hostname could not be found."
        if let httpError = response.result.error {
            completion(nil,httpError.localizedDescription)
            return
        }
        // Unwrap StatusCode & JSON from response
        guard
            let statusCode = response.response?.statusCode,
            let json = response.result.value else
        {
            // StatusCode Error
            completion(nil,UPennNetworkRequestService.StatusCodeError)
            return
        }
        // Deleting Notification
        if statusCode == 204 {
            completion(nil,nil)
            return
        }
        // Successful JSON fetch
        if statusCode == 200 {
            completion(json,nil)
            return
        }
        // Request Error from Server
        if statusCode == 400 {
            /*
             Error structure:
             ▿ some : 2 elements
             ▿ 0 : 2 elements
             - key : incident.Description
             - value : 'Description' should not be empty.
             ▿ 1 : 2 elements
             - key : incident.AffectedUser
             - value : You must specify an affected user when creating an incident.
            */
            var errorBuffer = ""
            if let errDict = json as? [String:Any]
            {
                let errorValues = errDict.values
                var errorCount = errorValues.count
                for value in errorValues {
                    if let v = value as? String {
                    errorCount-=1
                        if errorCount == 0 {
                            errorBuffer+=v
                        } else {
                            errorBuffer+="\(v)\n"
                        }
                    }
                }
                completion(nil,"Errors: \n\(errorBuffer)")
                return
            }
        }
        // Generic Request Error
        completion(nil,UPennNetworkRequestService.GenericRequestError)
    }
}

