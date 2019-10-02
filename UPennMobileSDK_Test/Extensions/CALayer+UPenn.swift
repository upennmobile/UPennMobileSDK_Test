//
//  UILayer+UPenn.swift
//  Unable To Scan
//
//  Created by Rashad Abdul-Salam on 7/2/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennInnerShadowLayer : CALayer {
    
    override init(layer: Any) {
        super.init(layer: layer)
        guard let frame = layer as? CGRect else { return }
        self.makeShadow(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func makeShadow(frame: CGRect) {
        self.frame = frame
        // Shadow path (1pt ring around bounds)
        let path = UIBezierPath(rect: bounds.insetBy(dx: -1, dy: -1))
        let cutout = UIBezierPath(rect: bounds).reversing()
        path.append(cutout)
        shadowPath = path.cgPath
        masksToBounds = true
        // Shadow properties
        shadowColor = UIColor(white: 0, alpha: 1).cgColor // UIColor(red: 0.71, green: 0.77, blue: 0.81, alpha: 1.0).cgColor
        shadowOffset = CGSize.zero
        shadowOpacity = 1
        shadowRadius = 3
    }
}

extension CALayer {
    
    func isRounded() {
        self.cornerRadius = 5
    }
    
    func regularBorder() {
        self.borderWidth = 2
    }
    
    func thickBorder() {
        self.borderWidth = 5
    }
    
    func isCircular(_ view: UIView) {
        cornerRadius = view.frame.width / 2
        view.clipsToBounds = true
    }
    
    func redBorder() {
        borderColor = UIColor.upennWarningRed.cgColor
    }
    
    func blueBorder() {
        borderColor = UIColor.upennMediumBlue.cgColor
    }
    
    func darkBlueBorder() {
        borderColor = UIColor.upennDarkBlue.cgColor
    }
    
    func lightGreyBorder() {
        borderColor = UIColor.upennRlyLightGray.cgColor
    }
    
    func greyBorder() {
        borderColor = UIColor.lightGray.cgColor
    }
}
