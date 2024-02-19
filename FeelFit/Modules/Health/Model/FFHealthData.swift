//
//  FFHealthData.swift
//  FeelFit
//
//  Created by Константин Малков on 10.01.2024.
//

import UIKit
import HealthKit

struct FFUserHealthDataProvider : Hashable{
    ///start period of loading data
    let startDate: Date
    ///End period of loading. Last time updating current value in HealthKit
    let endDate: Date
    ///Inherited and converted data from healthKit
    let value: Double
    ///String identifier of loading type data
    let identifier: String
    ///unit type include returning type of inherited data
    let unit: HKUnit
    ///type of sample searching for
    let type: HKSampleType
    ///health kit quantity type
    let typeIdentifier: HKQuantityTypeIdentifier?
}



///Health class which return requested HealthKit Identifiers to user and return correct types
class FFHealthData {
    
    static let healthStore: HKHealthStore = HKHealthStore()
    
    static var readDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    static  var shareDataTypes: [HKSampleType] {
        return allHealthDataTypes
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
