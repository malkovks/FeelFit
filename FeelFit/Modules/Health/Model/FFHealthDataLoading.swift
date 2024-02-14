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
        completion: @escaping (_ models: [FFUserHealthDataProvider]? )->()) {
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
                        print("FFHealthDataLoading.performQuery = error not nil",String(describing: error?.localizedDescription))
                        return
                    }
                    
                    let startDate = getLastWeekStartDate()
                    let endDate = Date()
                    var arrayValue = [FFUserHealthDataProvider]()
                    results.enumerateStatistics(from: startDate, to: endDate) { stats, pointer in
                        
                        let unitQuantityType = prepareHealthUnit(iden) ?? .count()
                        let startDate = stats.startDate
                        let endDate = stats.endDate
                        let type = stats.quantityType
                        
                        
                        if let doubleValue = processingStatistics(statistics: stats, unit: unitQuantityType, value: options){
                            let value = FFUserHealthDataProvider(startDate: startDate,
                                                                 endDate: endDate,
                                                                 value: doubleValue,
                                                                 identifier: iden.rawValue,
                                                                 unit: unitQuantityType,
                                                                 type: type,
                                                                 typeIdentifier: iden)
                            arrayValue.append(value)
                        }
                    }
                    if !arrayValue.isEmpty {
                        completion(arrayValue)
                    }
                }
                
                healthStore.execute(query)
            }
    }
    
    func getSampleQueryResult(identifier: HKQuantityTypeIdentifier,completion handler: @escaping (_ data: FFUserHealthDataProvider) -> ())  {
        let quantityType = HKQuantityType(identifier)
        let unit = prepareHealthUnit(identifier)
        let sortDescriptor = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let query = HKSampleQuery(sampleType: quantityType, predicate: nil, limit: 1, sortDescriptors: sortDescriptor) { query, samples, error in
            
            guard let samples = samples as? [HKQuantitySample],
                  !samples.isEmpty else {
                print("Error getting samples")
                return
            }
        
            if let sample = samples.first {
                let endDate = sample.endDate
                let calendar = Calendar.current
                let startDate = calendar.date(byAdding: .day, value: -1, to: endDate)!
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
                var totalValue: Double = sample.quantity.doubleValue(for: unit ?? .count())
                let provider = FFUserHealthDataProvider(startDate: sample.startDate,
                                                        endDate: sample.endDate,
                                                        value: totalValue,
                                                        identifier: identifier.rawValue,
                                                        unit: unit ?? .count(),
                                                        type: sample.quantityType,
                                                        typeIdentifier: identifier)
                handler(provider)
            }
        }
        healthStore.execute(query)
    }
}


