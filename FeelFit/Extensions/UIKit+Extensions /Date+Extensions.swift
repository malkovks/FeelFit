//
//  DateFormatter+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 30.09.2023.
//

import UIKit

extension Date {
    
    
    
    /// Function converting self Date to DateComponents with year,month and day
    /// - Returns: return DateComponents include year,month and day
    func convertDateToDateComponents() -> DateComponents {
        let calendar = Calendar.current
        return calendar.dateComponents([.year,.month,.day], from: self)
    }
    
    /// Converting input Date to String format.
    /// - Returns: Return string format. Example 2023-12-31
    func shortConvertString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    /// Converting input Date to String format with time
    /// - Returns: Return string format. Example 2023-12-31 24:00
    func longConvertString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func dateAndUserAgeConverting() -> String {
        let dateFormattedString = self.dateAndYearConverting()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self).year!
        return dateFormattedString + " " + "\(ageComponents)"
    }
    
    func dateAndYearConverting() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func startOfMonth() -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year,.month], from: self)
        return calendar.date(from: components)!
    }
    
    func getLastWeekStartDate(value: Int = -6,from date: Date = Date()) -> Date {
        return Calendar.current.date(byAdding: .day, value: value, to: date)!
    }
}
