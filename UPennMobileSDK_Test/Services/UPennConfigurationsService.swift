//
//  UPennConfigurationsService.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/13/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennConfigurationsService {
    
    private static var requestService = UPennNetworkRequestService()
    static var CurrentAppVersion : String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    static var BundleID : String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleIdentifierKey as String) as! String
    }
    static var DeviceID : String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    static var AppDisplayName : String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as! String
    }
    private (set) static var LatestAppVersion = ""
    static let LatestVersionKey   = "CurrentVersion"
    static let MandatoryUpdateKey = "MinimumVersion"
    
    static func checkLatestAppVersion(completion: @escaping (_ isUpdatable: Bool, _ updateRequired: Bool, _ errorMessage: String?)->Void) {
        UPennConfigurationsService.requestService.checkLatestAppVersion { (response) in
            if
                let settings = response.result.value as? Dictionary<String,Any>,
                let latestVersion = settings[UPennConfigurationsService.LatestVersionKey] as? String,
                let mandatoryVersion = settings[UPennConfigurationsService.MandatoryUpdateKey] as? String
            {
                UPennConfigurationsService.LatestAppVersion = latestVersion
                let canUpdate = latestVersion.isVersionNewer(currentVersion: UPennConfigurationsService.CurrentAppVersion)
                let mustUpdate = mandatoryVersion.isVersionNewer(currentVersion: UPennConfigurationsService.CurrentAppVersion)
                completion(canUpdate,mustUpdate,nil)
            } else if let message = response.result.error {
                completion(false,false,message.localizedDescription)
            } else {
                completion(false,false,"Cannot determine latest CRViewer version. Please try re-launching the App to see if an update is required.")
            }
        }
    }
}
