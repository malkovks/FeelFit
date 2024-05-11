//
//  FFHealthUserDataHandler.swift
//  FeelFit
//
//  Created by Константин Малков on 11.05.2024.
//

import HealthKit

class FFHealthDataUser {
    static var shareDataTypes: [HKSampleType] {
        return userHealthDataTypes
    }
    
    static var readDataTypes: [HKObjectType] {
        return characterTypes.compactMap { getCharacterType(for: $0) }
    }
    
    private static var userHealthDataTypes: [HKSampleType] {
        return characterTypes.compactMap { getSampleType(for: $0) }
    }
    
    private static var characteristicDataTypes: [HKCharacteristicTypeIdentifier] {
        return characterTypes.compactMap { HKCharacteristicTypeIdentifier(rawValue: $0) }
    }
    
    private static var characterTypes: [String] = [
        HKCharacteristicTypeIdentifier.bloodType.rawValue,
        HKCharacteristicTypeIdentifier.biologicalSex.rawValue,
        HKCharacteristicTypeIdentifier.fitzpatrickSkinType.rawValue,
        HKCharacteristicTypeIdentifier.wheelchairUse.rawValue,
        HKCharacteristicTypeIdentifier.dateOfBirth.rawValue
    ]
}
