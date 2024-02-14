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
        
        let identifier = allQuantityTypeIdentifiers.filter { quantityType in
            let text = getDataTypeName(quantityType)
            let keyID: String = text + "_status"
            let status = UserDefaults.standard.bool(forKey: keyID)
            return status
        }
        return identifier.sorted { $0.rawValue < $1.rawValue }
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
        HKQuantityTypeIdentifier.activeEnergyBurned.rawValue, ///burned kilocalories
        HKQuantityTypeIdentifier.heartRate.rawValue, ///heart rate
        
        HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue, ///walked or run meters
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
    
    static func dateIntervalConfiguration(_ type: FFHealthDateType = .week) -> DateComponents {
        var interval = DateComponents()
        switch type {
        case .week,.month:
            interval = DateComponents(day: 1)
        case .sixMonth:
            interval = DateComponents(weekday: 1)
        case .year:
            interval = DateComponents(month: 1)
        case .day:
            interval = DateComponents(hour: 1)
        }
        return interval
    }
    
    static func dateRangeConfiguration(_ type: FFHealthDateType) -> (startDate: Date, endDate: Date)  {
        let calendar = Calendar.current
        let endDate = Date()
        var startDate = Date()
        switch type {
        case .day:
            startDate = calendar.date(byAdding: .hour, value: -1, to: endDate)!
        case .week:
            startDate = calendar.date(byAdding: .day, value: -6, to: endDate)!
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: endDate)!
        case .sixMonth:
            startDate = calendar.date(byAdding: .month, value: -6, to: endDate)!
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: endDate)!
            
        }
        return (startDate, endDate)
    }
    
    class func saveHealthData(_ data: [HKObject], completion: @escaping (_ success: Bool, _ error: Error?) -> ()){
        healthStore.save(data, withCompletion: completion)
    }
}
