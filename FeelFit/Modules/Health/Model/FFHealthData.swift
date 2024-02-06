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

func getDataTypeName(_ types: HKQuantityTypeIdentifier) -> String{
    switch types {
    case .stepCount:
        return "Step Count"
    case .distanceWalkingRunning:
        return "Meters"
    case .activeEnergyBurned:
        return "Active Energy Burned"
    case .heartRate:
        return "Heart Rate"
    case .activeEnergyBurned:
        return "Calories"
    case .height:
        return "Height"
    case .bodyMass:
        return "Weight"
    case .vo2Max:
        return "VO 2 Max Comsuption"
    default:
        return ""
    }
}

func getUnitMeasurement(_ type: HKQuantityTypeIdentifier,_ value: Double) -> String {
    switch type {
    case .stepCount:
        return "steps"
    case .distanceWalkingRunning:
        return "meters"
    case .activeEnergyBurned:
        return "calories"
    case .heartRate:
        return "b/m"
    case .activeEnergyBurned:
        return "calories"
    case .height:
        return "cm"
    case .bodyMass:
        return "kg"
    case .vo2Max:
        return "MOC"
    default:
        return "No unit measurement"
    }
}

class FFHealthData {
    
    static let healthStore: HKHealthStore = HKHealthStore()
    
    static var readDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    static  var shareDataTypes: [HKSampleType] {
        return allHealthDataTypes
    }
    
    static var allTypeQuantityTypeIdentifiers: [HKQuantityTypeIdentifier] {
        return necessaryIdentifiers.compactMap { HKQuantityTypeIdentifier(rawValue: $0) }
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
        HKQuantityTypeIdentifier.heartRate.rawValue,
        
        HKQuantityTypeIdentifier.distanceWalkingRunning.rawValue,
        HKQuantityTypeIdentifier.stepCount.rawValue,
        
        HKQuantityTypeIdentifier.vo2Max.rawValue,
        
        HKQuantityTypeIdentifier.height.rawValue,
        HKQuantityTypeIdentifier.bodyMass.rawValue
     
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
        let endDate = calendar.startOfDay(for: Date())
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
    
//    static let userIdentifiers: [HKCharacteristicType] = [
//        HKObjectType.characteristicType(forIdentifier: .biologicalSex)!,
//        HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
//        HKObjectType.characteristicType(forIdentifier: .bloodType)!,
//        HKObjectType.characteristicType(forIdentifier: .fitzpatrickSkinType)!
//    ]
    
    
}
