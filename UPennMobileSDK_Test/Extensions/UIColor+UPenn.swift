//
//  UIColor+UPenn.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/13/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static var upennDeepBlue: UIColor { // #1A3C79
        return UIColor(displayP3Red: 26.0/255.0, green: 60.0/255.0, blue: 121.0/255.0, alpha: 1.0)
    }
    
    static var upennDarkBlue: UIColor { // #004B8D
        return UIColor(displayP3Red: 0.0/255.0, green: 75.0/255.0, blue: 141.0/255.0, alpha: 1.0)
    }
    
    static var upennMediumBlue: UIColor { // #5893DD
        return UIColor(displayP3Red: 88.0/255.0, green: 147.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    }
    
    static var upennRlyLightGray: UIColor {
        return UIColor(displayP3Red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    }
    
    static var upennWarningYellow: UIColor { // #D4CD14
        return UIColor(displayP3Red: 197.0/255, green: 191.0/255.0, blue: 102.0/255.0, alpha: 1.0)
    }
    
    static var upennWarningRed: UIColor { // #B20838
        return UIColor(displayP3Red: 163.0/255.0, green: 31.0/255.0, blue: 52.0/255.0, alpha: 1.0)
    }
    
    static var upennCTAGreen: UIColor { // #0B901E
        return UIColor(displayP3Red: 11.0/255.0, green: 144.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    }
    
    static var upennCTALightRed: UIColor { // #D05163
        return UIColor(displayP3Red: 208.0/255.0, green: 81.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    }
    
    static var upennCTALightBlue: UIColor { // #
        return UIColor(displayP3Red: 183.0/255.0, green: 210.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    }
    
    static var upennBlack: UIColor {
        return UIColor(displayP3Red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
    }
}
