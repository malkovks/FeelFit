//
//  UIFont+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 26.10.2023.
//

import UIKit

extension UIFont {
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
    
    static var fontName = "Futura"
    
    /// Font setup for header or main text
    /// - Parameter size: font size
    /// - Returns: return setups font value
    static func headerFont(size: CGFloat = 20,for textStyle: UIFont.TextStyle = .largeTitle ) -> UIFont {
        guard let customFont = UIFont(name: fontName, size: size) else { fatalError() }
        
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont)
        return fontMetrics
    }
    
    static func textLabelFont(size: CGFloat = 16, for textStyle: UIFont.TextStyle = .body,weight: UIFont.Weight = .init(0.0),width: UIFont.Width = .standard) -> UIFont {
        guard let customFont = UIFont(name: fontName, size: size) else { fatalError() }
        var fontMetrics = UIFont()
        if weight == .init(0.0){
            fontMetrics = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont)
        } else {
            fontMetrics = .systemFont(ofSize: size, weight: weight, width: width)
        }
        return fontMetrics
    }
    
    static func detailLabelFont(size: CGFloat = 12, for textStyle: UIFont.TextStyle = .title3 ,weight: UIFont.Weight = .init(0.0),width: UIFont.Width = .standard) -> UIFont {
        guard let customFont = UIFont(name: fontName, size: size) else { fatalError() }
        var fontMetrics = UIFont()
        if weight == .init(0.0){
            fontMetrics = UIFontMetrics(forTextStyle: textStyle).scaledFont(for: customFont)
        } else {
            fontMetrics = .systemFont(ofSize: size, weight: weight, width: width)
        }
        return fontMetrics
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
