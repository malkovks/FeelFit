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
        let emailRegix = "[A-Z0-9a-z._]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegix)
        return emailPredicate.evaluate(with: self)
    }
    
    func isValidPasswordText() -> Bool {
        let passwordRegix = "^(?=.*[A-Z])(?=.*[0-9!@#$&*)[A-Za-z0-9!@#$%^&*]{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATHES %@", passwordRegix)
        return passwordPredicate.evaluate(with: self)
    }
    
    func convertToStringData() -> Self {
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
