//
//  UIScrollView+UPenn.swift
//  Unable To Scan
//
//  Created by Rashad Abdul-Salam on 7/3/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    @objc func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
