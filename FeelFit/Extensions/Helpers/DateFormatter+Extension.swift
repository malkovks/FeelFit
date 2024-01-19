//
//  DateFormatter+Extension.swift
//  FeelFit
//
//  Created by Константин Малков on 19.01.2024.
//

import UIKit

extension DateFormatter {
    class func createMonthDayFormatter() -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        return dateFormatter
    }
    
}
