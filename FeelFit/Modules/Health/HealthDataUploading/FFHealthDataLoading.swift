//
//  FFHealthDataLoading.swift
//  FeelFit
//
//  Created by Константин Малков on 06.02.2024.
//

import HealthKit



class FFHealthDataLoading {
    static let shared = FFHealthDataLoading()
    
    private let healthStore = HKHealthStore()
    private let calendar = Calendar.current
    
    func performQuery(
        identifications : [HKQuantityTypeIdentifier] = [.activeEnergyBurned],
        interval dateComponents: DateComponents = DateComponents(day: 1),
        selectedOptions: HKStatisticsOptions?,
        completion: @escaping (_ models: [FFUserHealthDataProvider])->()) {
            let predicate = preparePredicateHealthData()
            let anchorDate = createAnchorData()
            let interval = dateComponents
            for iden in identifications {
                let options: HKStatisticsOptions = selectedOptions ?? prepareStatisticOptions(for: iden.rawValue)
                let id = HKQuantityType.quantityType(forIdentifier: iden)!
                
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
                        
                        let unitQuantityType = self?.prepareHealthUnit(iden) ?? .count()
                        let startDate = stats.startDate
                        let endDate = stats.endDate
                        let type = stats.quantityType
                        let sources = stats.sources
                        
                        
                        let doubleValue = self?.processingStatistics(statistics: stats, unit: unitQuantityType, value: options) ?? 0.0
                        let value = FFUserHealthDataProvider(startDate: startDate,
                                                             endDate: endDate,
                                                             value: doubleValue,
                                                             identifier: iden.rawValue,
                                                             unit: unitQuantityType,
                                                             type: type, 
                                                             typeIdentifier: iden,
                                                             sources: sources)
                        returnValue.append(value)
                    }
                    
                    completion(returnValue.sorted { $0.identifier < $1.identifier})
                }
                healthStore.execute(query)
            }
    }
    
    private func processingStatistics(statistics stats: HKStatistics,unit: HKUnit,value options: HKStatisticsOptions) -> Double {
        switch options {
        case .cumulativeSum:
            let cumulativeValue = stats.sumQuantity()?.doubleValue(for: unit)
            return cumulativeValue ?? 0.0
        case .discreteAverage:
            
            let discreteValue = stats.averageQuantity()?.doubleValue(for: unit)
            return discreteValue ?? 0.0
        default:
            return 0.0
        }
        
    }

    private func prepareHealthUnit(_ identifier: HKQuantityTypeIdentifier) -> HKUnit?{
        
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
    private func createLastWeekStartDate(from date: Date = Date()) -> Date {
        return Calendar.current.date(byAdding: .day, value: -6, to: date)!
    }
    
    private func prepareStatisticOptions(for dataIdentifier: String) -> HKStatisticsOptions {
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
