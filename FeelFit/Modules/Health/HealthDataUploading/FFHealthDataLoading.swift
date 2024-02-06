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
    private let calendar = Calendar.current
    
    func performQuery(
        identifier : HKQuantityTypeIdentifier = .activeEnergyBurned,
        _ intervalValue: Int = 1,
        _ optionsCase: HKStatisticsOptions = .cumulativeSum,
        completion: @escaping (_ models: [FFUserHealthDataProvider])->()) {
        let predicate = preparePredicateHealthData()
        let startDate = createLastWeekStartDate()
        let anchorDate = createAnchorData()
        let interval = DateComponents(day: intervalValue)
        let options: HKStatisticsOptions = prepareStatisticOptions(for: identifier.rawValue, options: optionsCase)
        let id = HKQuantityType.quantityType(forIdentifier: identifier)!
        
        let query = HKStatisticsCollectionQuery(quantityType: id,
                                                quantitySamplePredicate: predicate,
                                                options: options,
                                                anchorDate: anchorDate,
                                                intervalComponents: interval)
        
        query.initialResultsHandler = { [weak self] queries, results, error in
            guard error == nil,
                  let results = results else {
                print("Error getting result from query. Try again of fix it")
                return
            }
            let startDate = getLastWeekStartDate()
            let endDate = Date()
            var returnValue = [FFUserHealthDataProvider]()
            
            results.enumerateStatistics(from: startDate, to: endDate) { stats, pointer in
                
                let unitQuantityType = self!.prepareHealthUnit(identifier)!
                let startDate = stats.startDate
                let endDate = stats.endDate
                let type = stats.quantityType
                guard let steps = stats.sumQuantity()?.doubleValue(for: unitQuantityType) else { return }
                let value = FFUserHealthDataProvider(startDate: startDate, 
                                                     endDate: endDate,
                                                     value: steps,
                                                     identifier: identifier.rawValue,
                                                     unit: unitQuantityType,
                                                     type: type)
                returnValue.append(value)
            }
            completion(returnValue)
        }
        healthStore.execute(query)
        
    }

    private func prepareHealthUnit(_ identifier: HKQuantityTypeIdentifier) -> HKUnit?{
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
            return nil
        }
        
    }
    private func createLastWeekStartDate(from date: Date = Date()) -> Date {
        return Calendar.current.date(byAdding: .day, value: -6, to: date)!
    }
    
    private func prepareStatisticOptions(for dataIdentifier: String, options: HKStatisticsOptions = .cumulativeSum) -> HKStatisticsOptions {
        var options: HKStatisticsOptions = options
        let sampleType = getSampleType(for: dataIdentifier)
        
        if sampleType is HKQuantityType {
            let quantityIdentifier = HKQuantityTypeIdentifier(rawValue: dataIdentifier)
            
            switch quantityIdentifier {
            case .heartRate:
                options = .discreteAverage
            default:
                options = .cumulativeSum
            }
        }
        return options
    }
    
    ///Function creating predicate based on HKQuery and input startDate and endDate in this diapason
    private func preparePredicateHealthData(_ type: FFHealthDateType = .week, from endDate: Date = Date()) -> NSPredicate{
        let startDate = createLastWeekStartDate()
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    }
    
    private func createAnchorData() -> Date {
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
    private func prepareQuantityType(_ identifier: String) -> HKQuantityType {
        let quantityIdentifier = HKQuantityTypeIdentifier(rawValue: identifier)
        guard let quantityType = HKQuantityType.quantityType(forIdentifier: quantityIdentifier) else { return HKQuantityType(.stepCount)}
        return quantityType
    }
}
