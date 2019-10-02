//
//  UPennNameSpacer.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/27/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation

struct UPennNameSpacer {
    /**
     Creates name-spaced, concatenated string in the form of "App-Bundle-ID.keyString"
     - parameter keyString: String to be added to the name-space string
    */
    static func makeKey(_ keyString: String) -> String {
        return "\(UPennConfigurationsService.BundleID).\(keyString)"
    }
}
