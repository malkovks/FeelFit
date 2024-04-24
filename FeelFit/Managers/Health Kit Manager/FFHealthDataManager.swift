//
//  FFHealthDataManager.swift
//  FeelFit
//
//  Created by Константин Малков on 06.02.2024.
//

import HealthKit

struct UserCharactersData {
    var userGender: String?
    var dateOfBirth: DateComponents?
    var wheelChairUse: String?
    var bloodType: String?
    var fitzpatrickSkinType: String?
}

class FFHealthDataManager {
    static let shared = FFHealthDataManager()
    
    private init() {}
    
    private let healthStore = HKHealthStore()
    private let userCharactersTypes = Set(FFHealthData.charDataTypes)
    
    func loadSelectedIdentifierData(filter: SelectedTimePeriodData?,identifier: HKQuantityTypeIdentifier,startDate: Date, completion: @escaping (_ model: [FFUserHealthDataProvider]?) -> ()){
        DispatchQueue.global().async { [weak self] in
            var intervalComponent = DateComponents(day: 1)
            var startDate = startDate
            let now = Date()
            if let filter = filter {
                startDate = filter.startDate
                intervalComponent = filter.components
            }
            
            let options: HKStatisticsOptions = prepareStatisticOptions(for: identifier.rawValue)
            let quantityType = HKQuantityType.quantityType(forIdentifier: identifier)!
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
            let query = HKStatisticsCollectionQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: options, anchorDate: startDate, intervalComponents: intervalComponent)
            
            query.initialResultsHandler = { [weak self] query, result, error in
                guard let result = result,
                      let self = self else {
                    completion(nil)
                    return
                }
                let value = processStatisticsData(result, identifier, startDate, options)
                completion(value)
            }
            self?.healthStore.execute(query)
        }
    }
    
    
    /// Function for collection and processing data into completed array
    /// - Parameters:
    ///   - results: Input result value as HKStatisticsCollection which give info about identifier by completed period
    ///   - identification: health item identification
    ///   - anchorDate: the start date from ordered period
    /// - Returns: return converted array of data for ordered period
    private func processStatisticsData(_ results: HKStatisticsCollection,_ identification: HKQuantityTypeIdentifier, _ anchorDate: Date,_ options: HKStatisticsOptions) -> [FFUserHealthDataProvider] {
        let endDate = Date()
        var processedData = [FFUserHealthDataProvider]()
        
        results.enumerateStatistics(from: anchorDate, to: endDate) { stats, pointer in
            let unitQuantityType = prepareHealthUnit(identification) ?? .count()
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
                                                        identifier: identification.rawValue,
                                                        unit: unitQuantityType,
                                                        type: type,
                                                        typeIdentifier: identification)
                processedData.append(value)
            } else {
                let nilValue = FFUserHealthDataProvider(startDate: startDate,
                                                        endDate: endDate,
                                                        value: 0.1,
                                                        identifier: identification.rawValue,
                                                        unit: unitQuantityType,
                                                        type: type,
                                                        typeIdentifier: identification)
                processedData.append(nilValue)
            }
        }
        return processedData
    }
    
    func loadingCharactersData(completion handler: @escaping (_ userDataString: UserCharactersData?) -> ()) {
        if !HKHealthStore.isHealthDataAvailable() {
            return
        }
        
        healthStore.requestAuthorization(toShare: nil, read: userCharactersTypes) { [weak self] success, error in
            guard let self = self else { return }
            if success {
                DispatchQueue.global(qos: .background).async {
                    let gender = HealthStoreRequest.GenderTypeResult(from: try! self.healthStore.biologicalSex()).rawValue
                    let userDateOfBirth: DateComponents = try! self.healthStore.dateOfBirthComponents()
                    let wheelChairUse = HealthStoreRequest.WheelchairTypeResult(from: try! self.healthStore.wheelchairUse()).rawValue
                    let bloodType = HealthStoreRequest.BloodTypeResult(from: try! self.healthStore.bloodType()).rawValue
                    let skinType = HealthStoreRequest.FitzpatricSkinTypeResult(from: try! self.healthStore.fitzpatrickSkinType()).rawValue
                    let model = UserCharactersData(userGender: gender, dateOfBirth: userDateOfBirth, wheelChairUse: wheelChairUse, bloodType: bloodType, fitzpatrickSkinType: skinType)
                    handler(model)
                }
            } else {
                handler(nil)
            }
        }
    }
}







