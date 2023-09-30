//
//  DateFormatter+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 30.09.2023.
//

import UIKit

extension Date {
    
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
}
