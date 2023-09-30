//
//  String+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 30.09.2023.
//

import UIKit

extension String {
    func convertToStringData() -> Self {
        let formattedString = self.replacingOccurrences(of: "T", with: "").replacingOccurrences(of: "Z", with: "")
        let comp = formattedString.components(separatedBy: ":")
        let hourAndMinute = comp[0..<2]
        var value = hourAndMinute.joined(separator: ":")
        value.insert(" ", at: value.index(value.startIndex, offsetBy: 10))
        
        return value
    }
}
