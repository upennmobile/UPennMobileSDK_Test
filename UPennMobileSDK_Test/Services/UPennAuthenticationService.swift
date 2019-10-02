//
//  UPennAuthenticationService.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/12/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import JWTDecode
import UIKit

class UPennAuthenticationService {
    
    private(set) static var AuthToken: String?
    private (set) static var AthenaUserId: String?
    private (set) static var DisplayName: String?
    private static let AutoLoginKey  = UPennNameSpacer.makeKey("shouldAutoLogin")
    private static let AutoFillKey   = UPennNameSpacer.makeKey("shouldAutoFill")
    private static let UsernameKey   = UPennNameSpacer.makeKey("username")
    private static let LoginCountKey = UPennNameSpacer.makeKey("loginCountKey")
    private (set) static var IsAuthenticated = false
    static var ShouldAutoLogin : Bool {
        return UserDefaults.standard.value(forKey: AutoLoginKey) as? Bool ?? false
    }
    
    static var ShouldAutoFill : Bool {
        return UserDefaults.standard.value(forKey: AutoFillKey) as? Bool ?? false
    }
    
    static var IsFirstLogin : Bool {
        return UserDefaults.standard.value(forKey: LoginCountKey) as? Bool ?? true
    }
    static var PennUserName: String = ""
    static func storeAuthenticationCredentials(
        token: String,
        username: String,
        password: String) {
        AuthToken = token
        IsAuthenticated = true
        
        // Parse JWT
        self.parseJWTForInfo(jsonWebToken: token)
        
        // Check if shouldAutoFill, keychain-cache the in-coming credentials
        if ShouldAutoFill {
            self.cacheAuthenticationCredentials(username: username, password: password)
        }
    }
    
    static func cacheAuthenticationCredentials(username: String, password: String) {
        
        // Store pennUsername
        UserDefaults.standard.setValue(username, forKey: UsernameKey)
        
        do {
            
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = UPennKeychainPasswordItem(
                service: UPennKeychainConfiguration.serviceName,
                account: username,
                accessGroup: UPennKeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    static var hasCachedAuthCredentials : Bool {
        return !PennUserName.isEmpty
    }
    
    static func checkAuthenticationCache(completion:(_ username: String?, _ password: String?)->Void) {
        
        guard let username = UserDefaults.standard.value(forKey: UsernameKey) as? String else {
            completion(nil,nil)
            return
        }
        
        do {
            let passwordItem = UPennKeychainPasswordItem(
                service: UPennKeychainConfiguration.serviceName,
                account: username,
                accessGroup: UPennKeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            completion(username,keychainPassword)
        }
        catch {
            completion(nil,nil)
        }
    }
    
    static func toggleShouldAutoLogin(_ autoLogin: Bool) {
        UserDefaults.standard.set(autoLogin, forKey: AutoLoginKey)
    }
    
    static func toggleShouldAutoFill(_ autoFill: Bool) {
        UserDefaults.standard.set(autoFill, forKey: AutoFillKey)
    }
    
    static func setFirstLogin() {
        UserDefaults.standard.set(false, forKey: LoginCountKey)
    }
    
    static func logout() {
        IsAuthenticated = false
        AuthToken = nil
    }
}

private extension UPennAuthenticationService {
    // TODO: Not Needed?
    static func parseJWTForInfo(jsonWebToken: String) {
        /* Sample JWT Values
         {
         "unique_name": "penn_username",
         "nbf": 123456789,
         "exp": 123456789,
         "iat": 123456789
         }
         */
        do {
            let jwt = try decode(jwt: jsonWebToken)
            let uniqueName = jwt.claim(name: "unique_name")
            if let name = uniqueName.string {
                PennUserName = name
            }
        } catch {
            // Handle Error
            fatalError("Error parsing JWT - \(error)")
        }
    }
}
