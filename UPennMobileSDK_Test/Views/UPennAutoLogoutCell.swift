//
//  UPennAutoLogoutCell.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/18/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennAutoLogoutCell : UPennBasicCell {
    
    
    @IBOutlet weak var timeoutControl: UPennBasicSegmentControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.timeoutControl.tintColor = UIColor.upennMediumBlue
        
        // Set font attributes to avoid segment label truncation
        let font = UIFont.helvetica(size: 15.0)
        let attributes : [AnyHashable : Any] = [NSAttributedString.Key.font:font]
        self.timeoutControl.setTitleTextAttributes(attributes as? [NSAttributedString.Key : Any], for: .normal)
        self.timeoutControl.setTitleTextAttributes(attributes as? [NSAttributedString.Key : Any], for: .selected)
        
        self.timeoutControl.selectedSegmentIndex = UPennTimerUIApplication.timeoutIndex
    }
    
    @IBAction func pressedTimeoutControl(_ sender: UISegmentedControl) {
        UPennTimerUIApplication.updateTimeoutInterval(index: self.timeoutControl.selectedSegmentIndex)
    }
}
