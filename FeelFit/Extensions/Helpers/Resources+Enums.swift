//
//  FFColorEnum.swift
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

enum HealthStoreRequest {
    enum GenderTypeResult: String {
        case notDetected = "Not indicated"
        case female = "Female"
        case male = "Male"
        
        init(from biologicalSex: HKBiologicalSexObject){
            switch biologicalSex.biologicalSex {
            case .notSet:
                self = .notDetected
            case .female:
                self = .female
            case .male:
                self = .male
            case .other:
                self = .notDetected
            default:
                self = .notDetected
            }
        }
    }
    
    enum WheelchairTypeResult: String {
        case notIndicated = "Not indicated"
        case noWheelchair = "No"
        case wheelchair = "Yes"
        
        init(from wheelchair: HKWheelchairUseObject){
            switch wheelchair.wheelchairUse {
            case .notSet:
                self = .notIndicated
            case .no:
                self = .noWheelchair
            case .yes:
                self = .wheelchair
            default:
                self = .notIndicated
            }
        }
    }
    
    enum BloodTypeResult: String {
        
        
        case notSet = "Not set"
        case aPositive =  "A(II)Rh+"
        case aNegative =  "A(II)Rh-"
        case bPositive = "B(II)Rh+"
        case bNegative = "B(II)Rh-"
        case abPositive = "AB(IV)Rh+"
        case abNegative = "AB(IV)Rh-"
        case oPositive =  "O(I)Rh+"
        case oNegative = "O(I)Rh-"
        
        init(from bloodType: HKBloodTypeObject) {
            switch bloodType.bloodType {
            case .notSet:
                self = .notSet
            case .aPositive:
                self = .aPositive
            case .aNegative:
                self = .aNegative
            case .bPositive:
                self = .bPositive
            case .bNegative:
                self = .bNegative
            case .abPositive:
                self = .abPositive
            case .abNegative:
                self = .abNegative
            case .oPositive:
                self = .oPositive
            case .oNegative:
                self = .oNegative
            default:
                self = .notSet
            }
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
