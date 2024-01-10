//
//  FFHealthData.swift
//  FeelFit
//
//  Created by Константин Малков on 10.01.2024.
//

import UIKit
import HealthKit

///Method for getting HKSampleType from gets identifier. Otherwise return nil
func getSampleType(for identifier: String) -> HKSampleType?{
    if let quantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: identifier)) {
        return quantityType
    }
    if let categoryTime = HKCategoryType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: identifier)) {
        return categoryTime
    }
    
    return nil
}

class FFHealthData {
    static let healthStore: HKHealthStore = HKHealthStore()
    
    static var readDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    static  var shareDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    private static var allHealthDataTypes: [HKSampleType] {
        let typeIdentifiers: [String] = [
            HKQuantityTypeIdentifier.activeEnergyBurned.rawValue,
            HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue,
            HKQuantityTypeIdentifier.stepCount.rawValue,
            HKQuantityTypeIdentifier.sixMinuteWalkTestDistance.rawValue,
            HKQuantityTypeIdentifier.height.rawValue,
            HKQuantityTypeIdentifier.bodyMass.rawValue,
            HKQuantityTypeIdentifier.heartRate.rawValue,
            HKQuantityTypeIdentifier.peakExpiratoryFlowRate.rawValue
        ]
        return typeIdentifiers.compactMap { getSampleType(for: $0)
        }
    }
    
}
