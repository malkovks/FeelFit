//
//  FFColorEnum.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

enum FFResources {
    enum Colors {
        static var activeColor = UIColor(named: "mainColor") ?? .systemRed
        static var inactiveColor = UIColor(named: "inactiveColor") ?? .systemIndigo
        static var backgroundColor = UIColor(named: "backgroundColor") ?? .systemGreen
        static var secondaryColor = UIColor(named: "secondaryColor") ?? .systemMint
        static var tabBarBackgroundColor = UIColor(named: "tabBarBackgroundColor") ?? .systemBlue
        static var textColor = UIColor(named: "textColor") ?? .black
    }
    
    enum Fonts {
        static func didotFont(size: CGFloat) -> UIFont {
            return UIFont(name: "Didot", size: size) ?? UIFont()
        }
    }
}
