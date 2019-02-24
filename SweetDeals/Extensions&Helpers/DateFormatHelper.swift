//
//  DateFormatHelper.swift
//  SweetDeals
//
//  Created by Anteneh Sahledengel on 5/13/18.
//  Copyright © 2018 Anteneh Sahledengel. All rights reserved.
//

import UIKit

class DateFormatHelper {
    static let shared = DateFormatHelper()
    
    var monthDateYearFormatter: DateFormatter
    var millitaryTimeFormatter: DateFormatter
    
    private init() {
        
        monthDateYearFormatter = DateFormatter()
        monthDateYearFormatter.dateFormat = "MMMM d, yyyy"
        
        millitaryTimeFormatter = DateFormatter()
        millitaryTimeFormatter.dateFormat = "HH:mm"
    }
    
    func monthDateYearString(forDate date: Date) -> String {
        return monthDateYearFormatter.string(from: date)
    }
    
    func durationString(fromDate: Date, toDate: Date) -> String {
        let fromHourString = millitaryTimeFormatter.string(from: fromDate)
        var toHourString = millitaryTimeFormatter.string(from: toDate)
        
        if let startDate = Calendar.current.dateComponents(in: TimeZone.current, from: fromDate).day,
            let endDate = Calendar.current.dateComponents(in: TimeZone.current, from: toDate).day,
            endDate - startDate > 0 {
            toHourString += " (+\(endDate - startDate))"
        }
        
        return "\(fromHourString) - \(toHourString)"
    }
}
