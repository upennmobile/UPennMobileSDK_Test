//
//  UPennAnalyticsService.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 3/19/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

class UPennAnalyticsService : NSObject {
    
    static func configure() {
        FirebaseApp.configure()
    }
    
    static func trackLoginEvent() {
        Analytics.logEvent(AnalyticsEventLogin, parameters: nil)
    }
    
    static func trackSearchEvent(_ searchText: String) {
        Analytics.logEvent("search_request_successful", parameters: ["searchQuery" : searchText])
    }
    
    static func trackFavoriteContact(_ contactName: String) {
        Analytics.logEvent("favorited_contact", parameters: ["favoritedContactName" : contactName])
    }
    
}
