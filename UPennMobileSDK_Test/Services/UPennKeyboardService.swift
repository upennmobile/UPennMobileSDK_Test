//
//  UPennKeyboardService.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/13/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennKeyboardService: NSObject {
    
    weak fileprivate var scrollView:UIScrollView?
    
    weak fileprivate var parentView: UIView?
    
    init(_ scrollView: UIScrollView) {
        self.scrollView = scrollView
    }
    
    init(_ view: UIView) {
        self.parentView = view
    }
    
    func beginObservingKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(UPennKeyboardService.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UPennKeyboardService.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func endObservingKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notif:Notification) {
//        if let keyboardFrame = (notif.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
//            let contentInsets = UIEdgeInsets(top: scrollView!.contentInset.top, left: 0, bottom: keyboardFrame.height, right: 0)
//            scrollView!.contentInset = contentInsets
//            scrollView!.scrollIndicatorInsets = contentInsets
//        }
        if let keyboardSize = (notif.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.parentView!.frame.origin.y == 0{
                self.parentView!.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardDidHide(_ notif:Notification) {
//        let contentInset = UIEdgeInsets(top: scrollView!.contentInset.top, left: 0, bottom: 0, right: 0)
//        scrollView!.contentInset = contentInset
//        scrollView!.scrollIndicatorInsets = contentInset
        if let keyboardSize = (notif.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.parentView!.frame.origin.y != 0{
                self.parentView!.frame.origin.y += keyboardSize.height
            }
        }
    }
    
}
