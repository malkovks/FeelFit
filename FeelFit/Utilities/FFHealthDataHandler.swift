//
//  FFHealthData.swift
//  FeelFit
//
//  Created by Константин Малков on 21.04.2024.
//

import HealthKit

///Health class which return requested HealthKit Identifiers to user and return correct types
class FFHealthData {
    
    static let healthStore: HKHealthStore = HKHealthStore()
    
    static var readDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    static var shareDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    static var charDataTypes: [HKObjectType] {
        return charactersTypes.compactMap { getObjectType(for: $0) }
    }
    
    static var mainQuantityTypeIdentifiers: [HKQuantityTypeIdentifier] {
        return necessaryIdentifiers.compactMap { HKQuantityTypeIdentifier(rawValue: $0) }
    }
    
    static var allQuantityTypeIdentifiers: [HKQuantityTypeIdentifier] {
        return typeIdentifiers.compactMap { HKQuantityTypeIdentifier(rawValue: $0) }.sorted { $0.rawValue < $1.rawValue }
    }
    
    static var favouriteQuantityTypeIdentifier: [HKQuantityTypeIdentifier] {
        
        let identifier: [HKQuantityTypeIdentifier] = allQuantityTypeIdentifiers.filter { quantityType in
            let text = getDataTypeName(quantityType)
            let keyID: String = text + "_status"
            let status = UserDefaults.standard.bool(forKey: keyID)
            return status
        }
        return identifier
    }
    
    static var characteristicDataTypes: [HKCharacteristicTypeIdentifier] {
        return charactersTypes.compactMap { HKCharacteristicTypeIdentifier(rawValue: $0) }
    }
    
    static func processHealthSample(with value: Double,data provider: [FFUserHealthDataProvider]) -> HKObject? {
        guard
            let provider = provider.first,
            let id = provider.typeIdentifier
        else {
            return nil
        }
        let idString = provider.identifier
        
        
        let sampleType = getSampleType(for: idString)
        guard let unit = prepareHealthUnit(id) else { return nil }
        
        let now = Date()
        let start = now
        let end = now
        
        var optionalSample: HKObject?
        if let quantityType = sampleType as? HKQuantityType {
            let quantity = HKQuantity(unit: unit, doubleValue: value)
            let quantitySample = HKQuantitySample(type: quantityType, quantity: quantity, start: start, end: end)
            optionalSample = quantitySample
        }
        if let categoryType = sampleType as? HKCategoryType {
            let categorySample = HKCategorySample(type: categoryType, value: Int(value), start: start, end: end)
            optionalSample = categorySample
        }
        
        return optionalSample
    }
    
    private static var charactersTypes: [String] = [
        HKCharacteristicTypeIdentifier.bloodType.rawValue,
        HKCharacteristicTypeIdentifier.biologicalSex.rawValue,
        HKCharacteristicTypeIdentifier.fitzpatrickSkinType.rawValue,
        HKCharacteristicTypeIdentifier.wheelchairUse.rawValue,
        HKCharacteristicTypeIdentifier.dateOfBirth.rawValue,
    ]
    
    private static var allHealthDataTypes: [HKSampleType] {
        return typeIdentifiers.compactMap { getSampleType(for: $0) }
    }
    
    private static var necessaryIdentifiers: [String] = [
        HKQuantityTypeIdentifier.activeEnergyBurned.rawValue,
        HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue,
        HKQuantityTypeIdentifier.stepCount.rawValue,
    ]
    
    private static var typeIdentifiers: [String] = [
        HKQuantityTypeIdentifier.activeEnergyBurned.rawValue,
        
        HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue,
        HKQuantityTypeIdentifier.stepCount.rawValue,
        HKQuantityTypeIdentifier.distanceCycling.rawValue,
        HKQuantityTypeIdentifier.runningPower.rawValue,
        HKQuantityTypeIdentifier.runningSpeed.rawValue,
        
        HKQuantityTypeIdentifier.vo2Max.rawValue,
        
        HKQuantityTypeIdentifier.height.rawValue,
        HKQuantityTypeIdentifier.bodyMass.rawValue,
        HKQuantityTypeIdentifier.bodyFatPercentage.rawValue,
        HKQuantityTypeIdentifier.bodyMassIndex.rawValue
    ]

    
    class func saveHealthData(_ data: [HKObject], completion: @escaping (_ success: Bool, _ error: Error?) -> ()){
        healthStore.save(data, withCompletion: completion)
    }
}
