//
//  UPennTextView.swift
//  Change Request
//
//  Created by Rashad Abdul-Salam on 2/5/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennTextView : UITextView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autocorrectionType = .no
        enablesReturnKeyAutomatically = true
        inputAccessoryView = UPennKeyboardToolbar().makeDismissButton(.Done, for: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addInnerShadow()
    }
}

private extension UPennTextView {
    
    func addShadow() {
        clipsToBounds = false
        layer.shadowRadius = 5.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        layer.shadowOpacity = 0.8
        textColor = UIColor.upennBlack
    }
    
    func addInnerShadow() {
        let hasShadow = layer.sublayers?.filter { $0 is UPennInnerShadowLayer }.isEmpty == false
        if hasShadow == false {
            let innerShadow = UPennInnerShadowLayer(layer: bounds)
            layer.addSublayer(innerShadow)
        }
    }
}
