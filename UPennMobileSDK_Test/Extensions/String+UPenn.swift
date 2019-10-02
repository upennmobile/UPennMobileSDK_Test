//
//  String+UPenn.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/12/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation

extension String {
    /**
     Convenience var for removing whitespace at beginning and end of a String
     */
    var trim : String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    /**
     Convenience var for determining if a String is empty whitespace
     */
    var isBlankSpaceTrimmed : Bool {
        return !self.trim.isEmpty
    }
    
    /**
     Convenience var for determining if String is "N/A"
     */
    var isNotAvailable : Bool {
        return self == "N/A"
    }
    
    /**
     Convenience var for determining if String is "yes"
     */
    var isYes: Bool {
        return self.lowercased() == "yes"
    }
    
    /**
     Convenience var for determining if String is "no"
     */
    var isNo: Bool {
        return self.lowercased() == "no"
    }
    
    /**
     Convenience variable for returning a localized string; primarily to be used for text visible to the user
     */
    var localize : String {
        return NSLocalizedString(self, comment: self)
    }
    
    func isVersionNewer(currentVersion: String) -> Bool {
        if self.compare(currentVersion, options: .numeric) == .orderedDescending {
            return true
        }
        return false
    }
}

