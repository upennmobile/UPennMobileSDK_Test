//
//  UPennBasicSegmentControl.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 5/20/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennBasicSegmentControl : UISegmentedControl {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = UIColor.upennMediumBlue
        
        // Set font attributes to avoid segment label truncation
        let font = UIFont.helvetica(size: 15.0)
        let attributes : [AnyHashable : Any] = [NSAttributedString.Key.font:font]
        self.setTitleTextAttributes(attributes as? [NSAttributedString.Key : Any], for: .normal)
        self.setTitleTextAttributes(attributes as? [NSAttributedString.Key : Any], for: .selected)
    }
}
