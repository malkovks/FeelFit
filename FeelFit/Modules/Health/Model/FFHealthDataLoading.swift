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
    private let userCharactersTypes = Set(FFHealthData.charDataTypes)
    
    func performQuery(
        identifications : [HKQuantityTypeIdentifier] = [],
        value dateComponents: DateComponents = DateComponents(day: 1),
        calendar: Calendar.Component? = .day,
        interval: Int = -6,
        selectedOptions: HKStatisticsOptions?,
        startDate: Date?,
        currentDate date: Date = Date(),
        completion: @escaping (_ models: [FFUserHealthDataProvider]? )->()) {
            let _ = preparePredicateHealthData(value: interval, byAdding: calendar, from: Date())
            let anchorDate = startDate ?? createAnchorData()
            if identifications.isEmpty {
                completion(nil)
                return
            }
            
            for iden in identifications {
                let options: HKStatisticsOptions = selectedOptions ?? prepareStatisticOptions(for: iden.rawValue)
                let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
                let id = HKQuantityType.quantityType(forIdentifier: iden)!
                let query = HKStatisticsCollectionQuery(quantityType: id,
                                                    quantitySamplePredicate: predicate,
                                                    options: options,
                                                    anchorDate: anchorDate,
                                                    intervalComponents: dateComponents)
            
                query.initialResultsHandler = { queries, results, error in
                    guard error == nil,
                          let results = results else {
                        print("FFHealthDataLoading.performQuery = error not nil",String(describing: error?.localizedDescription))
                        completion(nil)
                        return
                    }
                    
                    let endDate = Date()
                    var arrayValue = [FFUserHealthDataProvider]()
                    results.enumerateStatistics(from: anchorDate, to: endDate) { stats, pointer in
                        
                        let unitQuantityType = prepareHealthUnit(iden) ?? .count()
                        let startDate = stats.startDate
                        let endDate = stats.endDate
                        let type = stats.quantityType
                        
                        
                        if var doubleValue = processingStatistics(statistics: stats, unit: unitQuantityType, value: options){

                            switch unitQuantityType {
                            case .meter().unitDivided(by: .second()):
                                doubleValue *= 3.6
                            default:
                                break
                            }
                            
                            let value = FFUserHealthDataProvider(startDate: startDate,
                                                                 endDate: endDate,
                                                                 value: doubleValue,
                                                                 identifier: iden.rawValue,
                                                                 unit: unitQuantityType,
                                                                 type: type,
                                                                 typeIdentifier: iden)
                            arrayValue.append(value)
                        } else {
                            let nilValue = FFUserHealthDataProvider(startDate: startDate, endDate: endDate, value: 0.1, identifier: iden.rawValue, unit: unitQuantityType, type: type, typeIdentifier: iden)
                            arrayValue.append(nilValue)
                        }
                    }
                    if !arrayValue.isEmpty {
                        completion(arrayValue)
                    } else {
                        completion(nil)
                    }
                }
                healthStore.execute(query)
            }
    }
    
    func loadingCharactersData(completion handler: @escaping (_ text: [UserCharactersData]?) -> ()){
        let type = [HKBloodTypeObject.self,HKWheelchairUseObject.self,HKBiologicalSexObject.self]
        if !HKHealthStore.isHealthDataAvailable(){
            handler(nil)
            return
        }
        healthStore.requestAuthorization(toShare: nil, read: userCharactersTypes) { success, error in
            if success && error == nil {
                
            } else {
                print("FFHealthDataLoading.loadingCharactersData: \nAccess did not given to users data")
            }
        }
    }
}

struct UserCharactersData {
    var userGender: String
    var dateOfBirth: Date
    var wheelChairUse: Bool
    var bloodType: String
    var photoType: String
}


