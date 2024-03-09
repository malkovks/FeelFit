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
    case unownedError
}
