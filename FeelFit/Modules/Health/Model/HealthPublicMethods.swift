//
//  HealthPublicMethods.swift
//  FeelFit
//
//  Created by Константин Малков on 13.02.2024.
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


/// Method return processed data and return full name of ID in string type
/// - Parameter types: HKQuantityTypeIdentifier input
/// - Returns: Converted string value
func getDataTypeName(_ types: HKQuantityTypeIdentifier) -> String{
    switch types {
    default:
        let text = types.rawValue
        let formattedText = text.replacingOccurrences(of: "HKQuantityTypeIdentifier", with: "")
        var returnText = ""
        for (index,char) in formattedText.enumerated() {
            if index > 0 && char.isUppercase {
                returnText.append(" ")
            }
            returnText.append(char)
        }
        
        return returnText
    }
}


/// Method return converted
/// - Parameter date: Input date type
/// - Returns: converted date
func createLastWeekStartDate(from date: Date = Date(),byAdding type: Calendar.Component = .day,value interval: Int = -6) -> Date {
    return Calendar.current.date(byAdding: type, value: interval, to: date)!
}

///Function creating predicate based on HKQuery and input startDate and endDate in this diapason
func preparePredicateHealthData(value interval: Int, byAdding type: Calendar.Component = .day, from endDate: Date = Date()) -> NSPredicate{
    let startDate = createLastWeekStartDate(from: endDate, byAdding: type, value: interval)
    return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
}

///Method return anchor data interval for loading type of data
func createAnchorData() -> Date {
    let calendar: Calendar = .current
    var components = calendar.dateComponents([.day,.month,.year,.weekday], from: Date())
    let offset = (7 + (components.weekday ?? 0 ) - 2) % 7
    
    components.day! -= offset
    components.hour = 3
    
    let date = calendar.date(from: components)!
    
    return date
}

/// Function creating, check optional and return quantity type
/// - Parameter identifier: string identifier of what function must return
/// - Returns: return completed quantity type if it not nil or no error. If any error return HKQuantityType.stepCount
func prepareQuantityType(_ identifier: String) -> HKQuantityType {
    let quantityIdentifier = HKQuantityTypeIdentifier(rawValue: identifier)
    guard let quantityType = HKQuantityType.quantityType(forIdentifier: quantityIdentifier) else { return HKQuantityType(.stepCount)}
    return quantityType
}

/// Method for convert and returning statistic options corresponding to ID
/// - Parameter dataIdentifier: quantity type identifier in string type
/// - Returns: return statistic options
func prepareStatisticOptions(for dataIdentifier: String) -> HKStatisticsOptions {
    var options: HKStatisticsOptions = .cumulativeSum
    let sampleType = getSampleType(for: dataIdentifier)
    
    if sampleType is HKQuantityType {
        let quantityIdentifier = HKQuantityTypeIdentifier(rawValue: dataIdentifier)
        
        switch quantityIdentifier {
        case    .heartRate,
                .bodyMassIndex,
                .runningPower,
                .runningSpeed,
                .bodyFatPercentage,
                .bodyMass,
                .height,
                .vo2Max:
            options = .discreteAverage
        default:
            options = .cumulativeSum
        }
    }
    return options
}

/// Method input identifier and return type of identifier
/// - Parameter type: HKQuantityIdentifier
/// - Returns: String type of ID
func getUnitMeasurement(_ type: HKQuantityTypeIdentifier) -> String {
    switch type {
    case .stepCount:
        return "steps"
    case .distanceWalkingRunning,.distanceCycling:
        return "meters"
    case .activeEnergyBurned:
        return "calories"
    case .heartRate:
        return "b/m"
    case .runningPower:
        return "W"
    case .runningSpeed:
        return "m/sec"
    case .height:
        return "cm"
    case .bodyMass:
        return "kg"
    case .vo2Max:
        return "MOC"
    case .bodyMassIndex:
        return "count"
    case .bodyFatPercentage:
        return "%"
    default:
        return "No unit measurement"
    }
}


/// Method process input data and return converted value
/// - Parameters:
///   - stats: formatted stats with all inputs value
///   - unit: HKUnit type of loading data
///   - options: HKStatistics options of how convert value
/// - Returns: results value
func processingStatistics(statistics stats: HKStatistics,unit: HKUnit,value options: HKStatisticsOptions) -> Double? {
    switch options {
    case .cumulativeSum:
        let cumulativeValue = stats.sumQuantity()?.doubleValue(for: unit)
        return cumulativeValue
    case .discreteAverage:
        let discreteValue = stats.averageQuantity()?.doubleValue(for: unit)
        return discreteValue
    default:
        return nil
    }
}


/// Method for returning unit corresponding to the identifier
/// - Parameter identifier: Input HKQuantityTypeIdentifier for process it
/// - Returns: return HKUnit
func prepareHealthUnit(_ identifier: HKQuantityTypeIdentifier) -> HKUnit?{
    
    switch identifier {
    case .stepCount,.bodyMassIndex:
        return HKUnit.count()
    case .distanceWalkingRunning, .distanceCycling:
        return HKUnit.meter()
    case .activeEnergyBurned:
        return HKUnit.kilocalorie()
    case .heartRate:
        return HKUnit.count().unitDivided(by: .minute())
    case .runningPower:
        return HKUnit.watt()
    case .runningSpeed:
        let meterPerSeconds =  HKUnit.meter().unitDivided(by: HKUnit.second())
        return meterPerSeconds
    case .bodyFatPercentage:
        return HKUnit.percent()
    case .height:
        return HKUnit.meterUnit(with: .centi)
    case .bodyMass:
        return HKUnit.gramUnit(with: .kilo)
    case .vo2Max:
        let kgMin = HKUnit.gramUnit(with: .kilo).unitMultiplied(by: .minute())
        let ml = HKUnit.literUnit(with: .milli)
        let vo2Unit = ml.unitDivided(by: kgMin)
        return vo2Unit
    default:
        return nil
    }
}


