//
//  UIViewController+UPenn.swift
//  Phone Book
//
//  Created by Rashad Abdul-Salam on 10/24/17.
//  Copyright © 2017 UPenn. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    
    @objc func navBarSetup() {
        // Set UPenn Deep Blue NavigationBar & white navbar text
        self.navigationController?.navigationBar.barTintColor = UIColor.upennDeepBlue
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    @objc func navBarLightSetup() {
        // Set UPenn Deep Blue NavigationBar & white navbar text
        self.navigationController?.navigationBar.barTintColor = UIColor.upennRlyLightGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.upennBlack]
        self.navigationController?.navigationBar.tintColor = UIColor.upennDeepBlue
    }
    
    @objc func reloadView() {
        self.popToRoot()
    }
    
    @objc func dismissModal() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func popToRoot(_ delay: Double=0.0) {
        DispatchQueue.main.asyncAfter(deadline: .now()+delay) {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
