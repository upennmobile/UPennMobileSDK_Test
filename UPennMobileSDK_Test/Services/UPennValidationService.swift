//
//  UPennValidationService.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/12/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import UIKit

class UPennValidationService {
    
    var textFields: Array<UITextField>
    
    var loginFieldsAreValid: Bool {
        for field in self.textFields {
            guard let text = field.text else { return false }
            if text.isEmpty {
                return false
            }
        }
        return true
    }
    
    init(textFields: Array<UITextField>) {
        self.textFields = textFields
        setTextFieldTags()
    }
    
    func setTextFieldTags() {
        var tagCount = 1
        for field in self.textFields {
            field.tag = tagCount
            tagCount += 1
        }
    }
    
    func resetTextFields() {
        for field in self.textFields {
            field.text = ""
        }
    }
}
