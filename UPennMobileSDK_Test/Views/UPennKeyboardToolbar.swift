//
//  UPennKeyboardToolbar.swift
//  Change Request
//
//  Created by Rashad Abdul-Salam on 2/6/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennKeyboardToolbar : UIToolbar {
    
    enum DismissButtonType {
        case Done, Cancel
    }
    
    private var parentResponder: UIResponder!
    
    func makeDismissButton(_ type: DismissButtonType, for responder: UIResponder) -> UPennKeyboardToolbar {
        self.parentResponder = responder
        sizeToFit()
        backgroundColor = UIColor.upennRlyLightGray
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        var dismissBarButton = UIBarButtonItem()
        var cancelButtonAttrs : [NSAttributedString.Key: Any] = [NSAttributedString.Key.font : UIFont.helvetica(size: 18)]
        switch type {
        case .Done:
            dismissBarButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(UPennKeyboardToolbar.cancel))
            cancelButtonAttrs[NSAttributedString.Key.foregroundColor] = UIColor.upennMediumBlue
        case .Cancel:
            dismissBarButton = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(UPennKeyboardToolbar.cancel))
            cancelButtonAttrs[NSAttributedString.Key.foregroundColor] = UIColor.upennWarningRed
        }
        dismissBarButton.setTitleTextAttributes(cancelButtonAttrs, for: UIControl.State.normal)
        dismissBarButton.setTitleTextAttributes(cancelButtonAttrs, for: UIControl.State.highlighted)
        items = [flexibleSpaceBarButton, dismissBarButton]
        return self
    }
    
    @objc func cancel() {
        self.parentResponder.resignFirstResponder()
    }
}
