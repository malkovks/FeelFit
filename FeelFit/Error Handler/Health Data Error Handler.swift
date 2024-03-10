//
//  Health Data Error Handler.swift
//  FeelFit
//
//  Created by Константин Малков on 09.03.2024.
//

import Foundation

enum HealthDataErrorHandler: Error {
    case noGender
    case noUserDateOfBirth
    case noWheelChairUse
    case noBloodType
    case noSkinType
    case someValuesNotDetected
    case unownedError
    case errorAccess
    case error(Error?)
}

extension HealthDataErrorHandler: LocalizedError {
    public var errorDescription: String? {
        switch self {
            
        case .noGender:
            return "No gender detected"
        case .noUserDateOfBirth:
            return "No users date of birth detected"
        case .noWheelChairUse:
            return "No users wheelchair user date detected"
        case .noBloodType:
            return "No users blood type data detected"
        case .noSkinType:
            return "No users skin type detected"
        case .someValuesNotDetected:
            return "Some of requested value are not detected"
        case .unownedError:
            return "Error out of request"
        case .error(let error):
            return error?.localizedDescription
        case .errorAccess:
            return "Did not have access to User's Data"
        }
    }
}
