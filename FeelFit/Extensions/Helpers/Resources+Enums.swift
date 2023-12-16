//
//  FFColorEnum.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

enum FFResources {
    enum Colors {
        ///  gri accent orange
        static var activeColor = UIColor(named: "mainColor") ?? .systemRed
        /// black or white
        static var inactiveColor = UIColor(named: "inactiveColor") ?? .systemIndigo
        /// almost white or almost black
        static var backgroundColor = UIColor(named: "backgroundColor") ?? .systemGreen
        /// deep dark purple
        static var secondaryColor = UIColor(named: "secondaryColor") ?? .systemMint
        /// light gray or dark gray
        static var tabBarBackgroundColor = UIColor(named: "tabBarBackgroundColor") ?? .systemBlue
        /// black color
        static var textColor = UIColor(named: "textColor") ?? .black
        /// dark gray color
        static var detailTextColor = UIColor(named: "detailTextColor") ?? .black
        /// gri background red
        static var griRed = UIColor(named: "gri_red") ?? .systemRed
        /// dark purple
        static var darkPurple = UIColor(named: "dark_purple") ?? .systemPurple
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

enum Request {
    enum RequestLoadingType: String {
        case fitness = "fitness"
        case health = "health"
        case gym = "gym"
        case training = "training"
        case sport = "sport"
    }

    enum RequestSortType: String {
       case relevancy = "relevancy"
       case popularity = "popularity"
       case publishedAt = "publishedAt"
    }
}



enum FFTabBarIndex: Int {
    case news
    case exercises
    case trainingPlan
    case health
    case user
}

enum NewsTableViewSelectedConfiguration {
    case copyLink
    case openImage
    case openLink
    case addToFavourite
    case shareNews
    case rowSelected
}
