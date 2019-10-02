//
//  UITableView+UPenn.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 4/16/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    
    override func scrollToTop() {
        if !visibleCells.isEmpty {
            let indexPath = IndexPath(row: 0, section: 0)
            scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
}
