//
//  Dateformatter+UPenn.swift
//  Change Request
//
//  Created by Rashad Abdul-Salam on 10/26/18.
//  Copyright © 2018 University of Pennsylvania Health System. All rights reserved.
//

import Foundation

private var cachedFormatters = [String : DateFormatter]()
extension DateFormatter {
    enum DateFormat : String {
        case ISO8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
        case RFC3339 = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        case UNIX_EPOCH = "1970-01-01T00:00:00Z"
    }
    
    static func formatString(_ dateString: String, format: DateFormat = .ISO8601) -> String {
        /*
         * 1. Create date object from cached formatter,
         * 2. Update to desired dateFormat
         * 3. Set dateString from formatter
         * 4. Reset cached formatter dateFormat
         */
        let formatter = DateFormatter.cached(withFormat: format)
        guard let date = formatter.date(from: dateString) else { return dateString }
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        let dateString = formatter.string(from: date)
        formatter.dateFormat = format.rawValue
        return dateString
    }
    
    static func cached(withFormat format: DateFormat) -> DateFormatter {
        if let cachedFormatter = cachedFormatters[format.rawValue] { return cachedFormatter }
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        cachedFormatters[format.rawValue] = formatter
        return formatter
    }
    
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter.cached(withFormat: .RFC3339)
        formatter.timeStyle = DateFormatter.Style.medium //Set time style
        formatter.dateStyle = DateFormatter.Style.medium //Set date style
        formatter.timeZone = .current
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    static func dateNowFormatted() -> String {
        let date = self.getDateFromTimeInterval(Date().timeIntervalSince1970)
        return self.formatDate(date)
    }
}

private extension DateFormatter {
    static func getDateFromTimeInterval(_ interval: TimeInterval) -> Date {
        return Date(timeIntervalSince1970: interval)
    }
}
