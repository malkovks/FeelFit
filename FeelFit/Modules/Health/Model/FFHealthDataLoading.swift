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
            
                query.initialResultsHandler = { queries, results, error in
                    guard error == nil,
                          let results = results else {
                        print("Error getting result from query. Try again of fix it")
                        return
                    }
                    let startDate = getLastWeekStartDate()
                    let endDate = Date()
                    var returnValue = [FFUserHealthDataProvider]()
                    
                    results.enumerateStatistics(from: startDate, to: endDate) { stats, pointer in
                        
                        let unitQuantityType = prepareHealthUnit(iden) ?? .count()
                        let startDate = stats.startDate
                        let endDate = stats.endDate
                        let type = stats.quantityType
                        let sources = stats.sources
                        
                        
                        let doubleValue = processingStatistics(statistics: stats, unit: unitQuantityType, value: options)
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

                    var finalValue: [FFUserHealthDataProvider] = []
                    for value in returnValue {
                        if !value.value.isEqual(to: 0.0){
                            finalValue.append(value)
                        }
                    }
                    
                    completion(finalValue.sorted { $0.identifier < $1.identifier})
                }
                healthStore.execute(query)
            }
    }
}
