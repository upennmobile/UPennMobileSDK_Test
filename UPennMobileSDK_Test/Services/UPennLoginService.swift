//
//  UPennLoginService.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/13/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation

class UPennLoginService {
    static var IsLoggedInNotification = "UPHSIsLoggedInNotification"
    var isLoggedIn : Bool { return UPennAuthenticationService.IsAuthenticated }
    var requestService = UPennNetworkRequestService()
    var loginDelegate: UPennLoginServiceDelegate
    var shouldAutoLogin : Bool { return UPennAuthenticationService.ShouldAutoLogin }
    var shouldAutoFill : Bool { return UPennAuthenticationService.ShouldAutoFill }
    var isFirstLogin : Bool { return UPennAuthenticationService.IsFirstLogin }
    private let genericLoginError = "Sorry an error occurred while attempting Login. Please try again."
    private let autoLoginError = "Something went wrong attempting Auto-Login - could not retrieve Username & Password. Please try again."
    private let usernamePasswordError = "You have entered an incorrect Username or Password. Please try again."
    
    init(loginDelegate: UPennLoginServiceDelegate) {
        self.loginDelegate = loginDelegate
    }
    
    func makeLoginRequest(username: String, password: String) {
        
        self.requestService.makeLoginRequest(username: username, password: password) { (response,errorStr) in
            if let error = errorStr {
                self.loginDelegate.didFailToLoginUser(errorStr: error)
                return
            }
            
            if
                let json = response as? [String:Any],
                let token = json["access_token"] as? String {
                print("Auth Token: \(token)")
                UPennAuthenticationService.storeAuthenticationCredentials(
                    token: token,
                    username: username,
                    password: password)
                self.loginDelegate.didSuccessfullyLoginUser(username)
                return
            }
            
            // TODO: Add logic for expired JWT token
            
            // Generic Error
            self.loginDelegate.didFailToLoginUser(errorStr: self.usernamePasswordError)
        }
    }
    
    func cacheLoginCredentials(username: String, password: String) {
        UPennAuthenticationService.cacheAuthenticationCredentials(username: username, password: password)
    }
    
    func authenticationAutoFillCheck() {
        if shouldAutoFill {
            UPennAuthenticationService.checkAuthenticationCache { (username, password) in
                if let u = username, let p = password {
                    self.loginDelegate.didReturnAutoFillCredentials(username: u, password: p)
                }
            }
        }
    }
    
    func attemptSilentLogin() {
        UPennAuthenticationService.checkAuthenticationCache { (username, password) in
            guard let u = username, let p = password else {
                self.loginDelegate.didFailToLoginUser(errorStr: self.autoLoginError)
                return
            }
            self.makeLoginRequest(username: u, password: p)
        }
    }
    
    func toggleShouldAutoLogin(_ autoLogin: Bool) {
        UPennAuthenticationService.toggleShouldAutoLogin(autoLogin)
    }
    
    func toggleShouldAutoFill(_ autoFill: Bool) {
        UPennAuthenticationService.toggleShouldAutoFill(autoFill)
    }
    
    func setFirstLogin() {
        UPennAuthenticationService.setFirstLogin()
    }
    
    func logout() {
        UPennAuthenticationService.logout()
    }
}
