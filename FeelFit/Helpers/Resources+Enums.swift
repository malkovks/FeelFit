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
        static var detailTextColor = UIColor(named: "detailTextColor") ?? .black
    }
    
    enum Fonts {
        static func didotFont(size: CGFloat) -> UIFont {
            return UIFont(name: "Didot", size: size) ?? UIFont()
        }
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
