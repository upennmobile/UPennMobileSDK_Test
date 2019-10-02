//
//  Date+UPenn.swift
//  Penn Chart Live
//
//  Created by Rashad Abdul-Salam on 4/30/19.
//  Copyright © 2019 University of Pennsylvania Health System. All rights reserved.
//

import Foundation

/**
 Extension to manage Date display of information
 */
extension Date {
    /**
     Placeholder text for Date display
    */
    static var timeAgoPlaceholder : String { return "Some time ago." }
    
    /**
     Computes the proper date display phrase based on the date-time of the object
    */
    var timeAgoDisplay : String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let second = 1
        let minute = 60 * second
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let baseTuple = (0,Date.timeAgoPlaceholder)
        var timeTuple = baseTuple
        
        // Singular Second
        if secondsAgo < 2*second {
            timeTuple = (secondsAgo,"sec")
        }
        // Plural Seconds
        else if secondsAgo < minute {
            timeTuple = (secondsAgo,"secs")
        }
        // Singular Minute
        else if secondsAgo < 2*minute {
            timeTuple = (secondsAgo/minute,"min")
        }
        // Plural Minute
        else if secondsAgo < hour {
            timeTuple = (secondsAgo/minute,"mins")
        }
        // Singular Hour
        else if secondsAgo < 2*hour {
            timeTuple = (secondsAgo/hour,"hr")
        }
        // Plural Hour
        else if secondsAgo < day {
            timeTuple = (secondsAgo/hour,"hrs")
        }
        // Singular Day
        else if secondsAgo < 2*day {
            timeTuple = (secondsAgo/day,"day")
        }
        // Plural Day
        else if secondsAgo < week {
            timeTuple = (secondsAgo/day,"days")
        }
        // Singular Week
        else if secondsAgo < 2*week {
            timeTuple = (secondsAgo/week,"wk")
        }
        // Plural Week
        else if secondsAgo < month {
            timeTuple = (secondsAgo/week,"wks")
        }
        // Singular Month
        else if secondsAgo < 2*month {
            timeTuple = (secondsAgo/month,"mth")
        }
        // Plural Month
        else if secondsAgo < year {
            timeTuple = (secondsAgo/month,"mths")
        }
        // Singular Year
        else if secondsAgo < 2*year {
            timeTuple = (secondsAgo/year,"yr")
        }
        // Plural Year
        else { timeTuple = (secondsAgo/year,"yrs") }
        
        return timeTuple != baseTuple ?
            "\(timeTuple.0) \(timeTuple.1) ago" :
            Date.timeAgoPlaceholder
    }
}
