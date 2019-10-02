//
//  UPennBasicTableView.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/19/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennBasicTableView : UITableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableFooterView = UIView()
    }
}
