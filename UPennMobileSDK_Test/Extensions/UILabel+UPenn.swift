//
//  UILabel+UPenn.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/13/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setFontHeight(size: CGFloat) {
        self.font = UIFont.helvetica(size: size)
    }
    
    func setBoldFont(size: CGFloat) {
        self.font = UIFont.helveticaBold(size: size)
    }
    
    // Gesture Recognizer
    // In order to create computed properties for extensions, we need a key to
    // store and access the stored property
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "GestureRecognizerAssociatedObjectKey_gestureRecognizer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    /*
     * Create the tap gesture recognizer and
     * store the closure the user passed into the associated object
    */
    func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.textColor = UIColor.upennMediumBlue
    }
    
    /* Every time the user taps on the UILable, this function gets called,
     which triggers the closure we stored */
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
}

class UPennLabel : UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setBaseStyles()
    }
    
    func setBaseStyles() {
        self.textColor = UIColor.upennBlack
        self.setFontHeight(size: 17.0)
    }
}

class MultilineLabel : UPennLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
}

class ContactNameLabel : UPennLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.textColor = UIColor.upennDeepBlue
        self.setFontHeight(size: 20.0)
    }
}

class ContactDepartmentLabel : UPennLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.textColor = UIColor.upennDarkBlue
        self.setFontHeight(size: 18.0)
    }
}

class CameraInstructionLabel : ContactNameLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.textColor = UIColor.white
    }
}

class ActionLabel : UPennLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.textColor = UIColor.upennMediumBlue
    }
}

class ActionSubContentLabel : ActionLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.setFontHeight(size: 15.0)
    }
}

class NoDataInstructionsLabel : UPennLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.textColor = UIColor.upennDarkBlue
        self.setFontHeight(size: 20.0)
    }
}

class BannerLabel : UPennLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.textColor = UIColor.upennDarkBlue
        self.setFontHeight(size: 25.0)
    }
}

class RedBannerLabel : BannerLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.textColor = UIColor.upennWarningRed
    }
}

class BannerLabelWhite : BannerLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.textColor = UIColor.white
    }
}

class TitleLabel : UPennLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.setBoldFont(size: 15.0)
    }
}

class ContentLabel : UPennLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.setFontHeight(size: 16.0)
    }
}

class SubContentLabel : UPennLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.setFontHeight(size: 13.0)
        self.textColor = UIColor.darkGray
    }
}

class MultilineContentLabel : MultilineLabel {
    override func setBaseStyles() {
        super.setBaseStyles()
        self.setFontHeight(size: 16.0)
    }
}
