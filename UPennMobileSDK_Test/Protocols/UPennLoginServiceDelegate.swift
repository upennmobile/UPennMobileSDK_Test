//
//  UPennLoginServiceDelegate.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 4/23/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation

protocol UPennLoginServiceDelegate {
    func didSuccessfullyLoginUser(_ username: String)
    func didReturnAutoFillCredentials(username: String, password: String)
    func didFailToLoginUser(errorStr: String)
}
