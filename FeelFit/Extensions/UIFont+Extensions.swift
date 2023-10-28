//
//  UIFont+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 26.10.2023.
//

import UIKit

extension UIFont {
    
    static var fontName = "Thonburi"
    
    /// Font setup for header or main text
    /// - Parameter size: font size
    /// - Returns: return setups font value
    static func headerFont(size: CGFloat = 20) -> UIFont {
        var font = UIFont()
        font = UIFont(name: fontName, size: size)!
        return font
    }
    
    static func textLabelFont(size: CGFloat = 16,weight: UIFont.Weight = .init(0.0),width: UIFont.Width = .standard) -> UIFont {
        var font = UIFont()
        if weight == .init(0.0){
            font = UIFont(name: fontName, size: size)!
        } else {
            font = .systemFont(ofSize: size, weight: weight, width: width)
        }
        return font
    }
    
    static func detailLabelFont(size: CGFloat = 12,weight: UIFont.Weight = .init(0.0),width: UIFont.Width = .standard) -> UIFont {
        var font = UIFont()
        if weight == .init(0.0){
            font = UIFont(name: fontName, size: size)!
        } else {
            font = .systemFont(ofSize: size, weight: weight, width: width)
        }
        return font
    }
    
    static func textViewFont(size: CGFloat = 16,weight: UIFont.Weight = .init(0.0),width: UIFont.Width = .standard) -> UIFont {
        var font = UIFont()
        if weight == .init(0.0){
            font = UIFont(name: fontName, size: size)!
        } else {
            font = .systemFont(ofSize: size, weight: weight, width: width)
        }
        return font
    }
}
