//
//  UPennLogoutCell.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/18/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennLogoutCell : UPennBasicCell {
    
    @IBOutlet weak var logoutLabel: UPennLabel!
    
    func configure() {
        self.logoutLabel.textColor = UIColor.upennWarningRed
    }
}
