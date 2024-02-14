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
                    results.enumerateStatistics(from: startDate, to: endDate) { [weak self] stats, pointer in
                        
                        let unitQuantityType = prepareHealthUnit(iden) ?? .count()
                        let startDate = stats.startDate
                        let endDate = stats.endDate
                        let type = stats.quantityType
                        let sources = stats.sources
                        
                        
                        if let doubleValue = processingStatistics(statistics: stats, unit: unitQuantityType, value: options){
                            let value = FFUserHealthDataProvider(startDate: startDate,
                                                                 endDate: endDate,
                                                                 value: doubleValue,
                                                                 identifier: iden.rawValue,
                                                                 unit: unitQuantityType,
                                                                 type: type,
                                                                 typeIdentifier: iden,
                                                                 sources: sources)
                            arrayValue.append(value)
                        } else {
                            self?.loadLastUpdatesResult(identifier: id, completion: { samples in
//                                let doubleValue = processingStatistics(statistics: samples, unit: <#T##HKUnit#>, value: <#T##HKStatisticsOptions#>)
                            })
                        }
                        
                    }
                    if !arrayValue.isEmpty {
                        completion(arrayValue)
                    }
                }
                
                healthStore.execute(query)
                
                let sampleQuery = HKSampleQuery(sampleType: id, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]) { query, sample, error in
                    if let sample = sample?.first {
                        print("performQuery.sampleQuery loading result from id: \(id)",sample.endDate)
                    } else {
                        print("performQuery.sampleQuery error getting data")
                    }
                }
                healthStore.execute(sampleQuery)
            }
    }
    
    func loadLastUpdatesResult(identifier: HKQuantityType,
                               predicate: NSPredicate? = nil,
                               limit: Int = HKObjectQueryNoLimit,
                               sortDescriptors: [NSSortDescriptor]? = nil,
                               completion handler: @escaping(_ samples: [HKSample]?) -> ()){
        let sortDescriptorsValue: [NSSortDescriptor] = sortDescriptors ?? [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        let sampleQuery = HKSampleQuery(sampleType: identifier, predicate: predicate, limit: limit, sortDescriptors: sortDescriptorsValue) { query, samples, error in
            guard error == nil else {
                print("FFHealthDataLoading.performQuery.loadLastUpdatesResult error getting sample",error?.localizedDescription ?? "")
                return
            }
            handler(samples)
        }
    }
}


