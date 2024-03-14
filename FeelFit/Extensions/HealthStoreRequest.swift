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

