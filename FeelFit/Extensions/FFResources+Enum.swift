//
//  Resources+Enums.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import HealthKit

enum FFResources {
    enum Colors {
        ///  gri accent orange
        static var activeColor = UIColor(named: "mainColor") ?? .systemRed
        /// black or white
        static var inactiveColor = UIColor(named: "inactiveColor") ?? .systemIndigo
        /// almost white or almost black
        static var backgroundColor = UIColor(named: "backgroundColor") ?? .systemGreen
        /// deep dark purple
        static var secondaryColor = UIColor(named: "darkPurpleColor") ?? .systemMint
        /// light gray or dark gray
        static var tabBarBackgroundColor = UIColor(named: "tabBarBackgroundColor") ?? .systemBlue
        /// black color
        static var textColor = UIColor(named: "textColor") ?? .black
        /// dark gray color
        static var detailTextColor = UIColor(named: "detailTextColor") ?? .black
        /// gri background red
        static var griRed = UIColor(named: "gri_red") ?? .systemRed
        /// dark purple
        static var darkPurple = UIColor(named: "dark_purpleAsset") ?? .systemPurple
        /// very light pink color for background color
        static var lightBackgroundColor = UIColor(named: "healthBackground") ?? .systemBackground
        /// black adaptive color for working with different system themes
        static var customBlack = UIColor(named: "customBlack") ?? .black
        
    }
    
    enum Fonts {
        static func futuraFont(size: CGFloat) -> UIFont {
            return UIFont(name: "Futura", size: size) ?? UIFont()
        }
    }
    
    enum Errors: Error {
        case tryingSaveDuplicate
    }
}


