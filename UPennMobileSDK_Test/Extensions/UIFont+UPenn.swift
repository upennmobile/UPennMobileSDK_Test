//
//  UIFont+UPenn.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/13/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func helvetica(size: CGFloat) -> UIFont {
        return UIFont.init(name: "Helvetica Neue", size: size)!
    }
    
    class func helveticaBold(size: CGFloat) -> UIFont {
        return UIFont.init(name: "HelveticaNeue-Bold", size: size)!
    }
}
