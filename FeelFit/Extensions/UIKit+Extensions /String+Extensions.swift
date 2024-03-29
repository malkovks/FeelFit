//
//  String+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 30.09.2023.
//

import UIKit

extension String {
    
    
    func formatArrayText(of: String = "_",with: String = " ") -> Self {
        return self.replacingOccurrences(of: of, with: with).capitalized
    }
    
    func isValidEmailText() -> Bool {
        let emailRegex = "[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPasswordText() -> Bool {
//        let passwordRegix = "^(?=.*[A-Z])(?=.*[0-9!@#$&*)[A-Za-z0-9!@#$%^&*]{6,}$"
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9]).{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: self)
    }
    
    
    /// Function process string date, input format style and return formatted date
    /// - Parameter format: iso format value
    /// - Returns: return formatted date
    func convertStringToDate(to format: String = "dd MMM yyyy") -> Date? {
        let onlyDateValue = self.replacingOccurrences(of: "\\(\\d+\\)", with: "", options: .regularExpression)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: onlyDateValue)
    }
    
    func convertDateToString() -> Self {
        let currentLocale = Locale.current
        var calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.locale = currentLocale
        dateFormatter.timeZone = calendar.timeZone

        
        
        let formattedString = self.replacingOccurrences(of: "T", with: "").replacingOccurrences(of: "Z", with: "")
        let comp = formattedString.components(separatedBy: ":")
        let hourAndMinute = comp[0..<2]
        var value = hourAndMinute.joined(separator: ":")
        value.insert(" ", at: value.index(value.startIndex, offsetBy: 10))
        
        let time = dateFormatter.date(from: value)

        // Create Calendar object
       

        // Set time to parsed time
        let timeComponents = calendar.dateComponents([.year,.month,.day,.hour, .minute], from: time!)

        // Get current locale's time zone
        let timeZone = TimeZone(identifier: "Europe/Moscow")!

        // Set time zone to calendar
        calendar.timeZone = timeZone
        calendar.locale = currentLocale

        // Get converted time in current locale's time zone
        let convertedTime = calendar.date(from: timeComponents)!
        let returnValue = dateFormatter.string(from: convertedTime)
        
        
        return returnValue
    }
}
