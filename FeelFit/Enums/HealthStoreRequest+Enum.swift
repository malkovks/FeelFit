//
//  HealthStoreRequest.swift
//  FeelFit
//
//  Created by Константин Малков on 14.03.2024.
//

import Foundation
import HealthKit

enum HealthStoreRequest {
    enum GenderTypeResult: String,CaseIterable {
        case notSet = "Not set"
        case female = "Female"
        case male = "Male"
        
        init(rawValue: String) {
            switch rawValue {
            case "Male":
                self = .male
            case "Female":
                self = .female
            default:
                self = .notSet
            }
        }
        
        init(from biologicalSex: HKBiologicalSexObject){
            switch biologicalSex.biologicalSex {
            case .notSet:
                self = .notSet
            case .female:
                self = .female
            case .male:
                self = .male
            case .other:
                self = .notSet
            default:
                self = .notSet
            }
        }
    }
    
    enum WheelchairTypeResult: String, CaseIterable {
        case notSet = "Not set"
        case noWheelchair = "No"
        case wheelchair = "Yes"
        
        init(rawValue: String) {
            switch rawValue{
            case "No":
                self = .noWheelchair
            case "Yes":
                self = .wheelchair
            default:
                self = .notSet
            }
        }
        
        init(from wheelchair: HKWheelchairUseObject){
            switch wheelchair.wheelchairUse {
            case .notSet:
                self = .notSet
            case .no:
                self = .noWheelchair
            case .yes:
                self = .wheelchair
            default:
                self = .notSet
            }
        }
    }
    
    enum FitzpatricSkinTypeResult: String, CaseIterable {
        case notSet = "Not set"
        case I = "Phototype I"
        case II = "Phototype II"
        case III = "Phototype III"
        case IV = "Phototype IV"
        case V = "Phototype V"
        case VI = "Phototype VI"
        
        init(rawValue: String) {
            switch rawValue {
            case "Phototype I" : self = .I
            case "Phototype II" : self = .II
            case "Phototype III" : self = .III
            case "Phototype IV" : self = .IV
            case "Phototype V" : self = .V
            case "Phototype VI" : self = .VI
            default:
                self = .notSet
            }
        }
        
        init(from skinType: HKFitzpatrickSkinTypeObject){
            switch skinType.skinType {
            case .notSet:
                self = .notSet
            case .I:
                self = .I
            case .II:
                self = .II
            case .III:
                self = .III
            case .IV:
                self = .IV
            case .V:
                self = .V
            case .VI:
                self = .VI
            default:
                self = .notSet
            }
        }
    }
    
    enum BloodTypeResult: String, CaseIterable {
        case notSet = "Not set"
        case aPositive =  "A(II)Rh+"
        case aNegative =  "A(II)Rh-"
        case bPositive = "B(II)Rh+"
        case bNegative = "B(II)Rh-"
        case abPositive = "AB(IV)Rh+"
        case abNegative = "AB(IV)Rh-"
        case oPositive =  "O(I)Rh+"
        case oNegative = "O(I)Rh-"
        
        init(rawValue: String){
            switch rawValue {
            case "Not set" :
                self = .notSet
            case "A(II)Rh+" :
                self = .aPositive
            case "A(II)Rh-": self = .aNegative
            case "B(II)Rh+": self = .bPositive
            case "B(II)Rh-": self = .bNegative
            case "AB(IV)Rh+": self = .abPositive
            case "AB(IV)Rh-": self = .abNegative
            case "O(I)Rh+": self = .oPositive
            case "O(I)Rh-": self = .oNegative
            default:
                self = .notSet
            }
        }
        
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

