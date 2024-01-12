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
    
    class func requestHealthDataAccessIfNeeded(dataTypes: [String]? = nil,
                                               completion: @escaping (_ success: Bool,_ status: String) -> Void ){
        var readDataTypes = Set(allHealthDataTypes)
        var shareDataTypes = Set(allHealthDataTypes)
        
        if let identifiers = dataTypes {
            readDataTypes = Set(identifiers.compactMap { getSampleType(for: $0) })
            shareDataTypes = readDataTypes
        }
        requestHealthDataAccessIfNeeded(toShare: shareDataTypes, read: readDataTypes, completion: completion)
    }
    
    class func requestHealthDataAccessIfNeeded(toShare shareTypes: Set<HKSampleType>?,
                                               read readTypes: Set<HKSampleType>?,
                                               completion: @escaping (_ success: Bool,_ status: String) -> Void){
        if !HKHealthStore.isHealthDataAvailable() {
            completion(false, "Health data is not available")
        }
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, error in
            if let error = error {
                completion(false, "request authorization error. \(error.localizedDescription)")
            }
            
            if success {
                completion(success, "HealthKit authorization request was successful!")
            } else {
                completion(success, "HealthKit authorization was not successful.")
            }
        }
    }
    
}
