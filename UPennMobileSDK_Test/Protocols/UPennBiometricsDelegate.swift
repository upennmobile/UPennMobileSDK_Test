//
//  UPennBiometricsDelegate.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 4/23/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation

protocol UPennBiometricsDelegate {
    func registerForTouchIDAuthentication()
    func registerForFaceIDAuthentication()
    func biometricsSuccessfullyAuthenticated(turnOnBiometrics: Bool)
    func biometricsDidError(with message: String?, shouldContinue: Bool)
}
