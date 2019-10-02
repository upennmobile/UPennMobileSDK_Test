//
//  UPennPullRefreshService.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 4/24/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennPullRefreshService {
    var refreshCallback:(()->Void)
    var controller = UIRefreshControl()
    
    init(tableView: UITableView, callback:@escaping ()->Void) {
        self.refreshCallback = callback
        self.controller.addTarget(self, action: #selector(refreshTargetCallback), for: .valueChanged)
        self.controller.tintColor = UIColor.upennMediumBlue
        tableView.refreshControl = self.controller
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func refreshTargetCallback() {
        self.refreshCallback()
    }
    
    func endRefreshing() {
        self.controller.endRefreshing()
    }
}
