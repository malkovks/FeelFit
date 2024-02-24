//
//  DateComponents+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 24.02.2024.
//

import UIKit

extension DateComponents {
    
    /// Function gets date components and convert them to string which include format like "dd MMM yyyy. (age)"
    /// - Returns: return date with age
    func convertComponentsToDateString() -> String{
        let calendar = Calendar.current
        let date = (calendar.date(from: self))!
        let datestring = date.dateAndYearConverting()
        
        let age = calendar.dateComponents([.year], from: date,to: Date()).year!

        let result = datestring + " (\(age))"
        return result
    }
}
