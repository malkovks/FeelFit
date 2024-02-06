//
//  FFHealthDataLoading.swift
//  FeelFit
//
//  Created by Константин Малков on 06.02.2024.
//

import HealthKit

struct FFUserHealthDataProvider {
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
}

class FFHealthDataLoading {
    static let shared = FFHealthDataLoading()
    
    private let healthStore = HKHealthStore()
    
    /// Function loading selected type from HealthStore ,convert and display in correct form
    /// - Parameters:
    ///   - type: necessary for set up period of loading data
    ///   - identifier: it is HKQuantityTypeIdentifier of selected type for downloading information
    ///   - completionHandler: return array of FFUserHealthDataProvider
    func uploadHealthDataBy(type: FFHealthDateType = .week,_ identifier: String = "HKQuantityTypeIdentifierStepCount",completionHandler: @escaping ((_ userData: [FFUserHealthDataProvider]) -> ()) ){
        var returnValue: [FFUserHealthDataProvider] = [FFUserHealthDataProvider]()
        let quantityType = prepareQuantityType(identifier)
        let id = HKQuantityTypeIdentifier(rawValue: identifier)
        let predicate = preparePredicateHealthData(type)
        let interval = FFHealthData.dateIntervalConfiguration(type)
        let date = FFHealthData.dateRangeConfiguration(type)
        let options = HKStatisticsOptions.cumulativeSum
        let unit = prepareHealthUnit(id)
        
        let query: HKStatisticsCollectionQuery = HKStatisticsCollectionQuery(
            quantityType: quantityType,
            quantitySamplePredicate: predicate,
            options: options,
            anchorDate: date.endDate,
            intervalComponents: interval)
        
        query.initialResultsHandler = { queries, results, error in
            guard error == nil,
                  let results = results else {
                print("Error getting result from query. Try again of fix it")
                return
            }
            
            results.enumerateStatistics(from: date.startDate, to: date.endDate) { stats, pointer in
                //setups for step count
                
                let startDate = stats.startDate
                let endDate = stats.endDate
                let type = stats.quantityType
                guard let steps = stats.sumQuantity()?.doubleValue(for: unit) else { return }
                let value = FFUserHealthDataProvider(startDate: startDate, endDate: endDate, value: steps, identifier: identifier, unit: unit, type: type)
                returnValue.append(value)
            }
            completionHandler(returnValue)
        }
        healthStore.execute(query)
    }
    private func prepareHealthUnit(_ identifier: HKQuantityTypeIdentifier) -> HKUnit{
        switch identifier {
        case .stepCount:
            return HKUnit.count()
        case .distanceWalkingRunning:
            return HKUnit.meter()
        case .activeEnergyBurned:
            return HKUnit.kilocalorie()
        case .heartRate:
            return HKUnit.count().unitDivided(by: .minute())
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
            return HKUnit.count()
        }
    }
    
    ///Function creating predicate based on HKQuery and input startDate and endDate in this diapason
    private func preparePredicateHealthData(_ type: FFHealthDateType) -> NSPredicate{
        let (startDate,endDate) = FFHealthData.dateRangeConfiguration(type)
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
    }
    
    /// Function creating, check optional and return quantity type
    /// - Parameter identifier: string identifier of what function must return
    /// - Returns: return completed quantity type if it not nil or no error. If any error return HKQuantityType.stepCount
    private func prepareQuantityType(_ identifier: String) -> HKQuantityType {
        let quantityIdentifier = HKQuantityTypeIdentifier(rawValue: identifier)
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: quantityIdentifier) else { return HKQuantityType(.stepCount)}
        return quantityType
    }
}
