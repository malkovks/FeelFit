//
//  FFHealthDataAccess.swift
//  FeelFit
//
//  Created by Константин Малков on 18.01.2024.
//

import HealthKit

///Singleton Class return app's status of access to users health data
class FFHealthDataAccess {
    
    static let shared = FFHealthDataAccess()
    
    private init() {}
    
    private let readTypes = Set(FFHealthData.readDataTypes)
    private let shareTypes = Set(FFHealthData.shareDataTypes)
    private let userCharactersTypes = Set(FFHealthDataUser.readDataTypes)
    private let healthStore = HKHealthStore()
    
    ///Function for request access to Health Kit. Inherit read and share types
    func requestForAccessToHealth(completion: ((Result<Bool, Error>) -> Void)? = nil) {
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) {success, error in
            if let error = error {
                completion?(.failure(error))
            } else {
                completion?(.success(success))
            }
        }
    }
    
    
    /// Making request for getting access to main users data like date of birth, blood type and other quantities types
    func requestAccessToCharactersData(completion: ((Result<Bool, Error>) -> Void)? = nil){
        healthStore.requestAuthorization(toShare: nil, read: userCharactersTypes) { status, error in
            if status {
                completion?(.success(status))
            } else if let error = error {
                completion?(.failure(error))
            }
        }
    }
    
    ///Function check status authorization to Health Store and return exact boolean value of gets status
    func getHealthAuthorizationRequestStatus(completion: @escaping (Bool) -> ()){
        if !HKHealthStore.isHealthDataAvailable()  {
            return
        }
        healthStore.getRequestStatusForAuthorization(toShare: shareTypes, read: readTypes) { [weak self] authStatus, error in
            switch authStatus {
            case .unknown:
                completion(false)
            case .unnecessary:
                completion(true)
            case .shouldRequest:
                self?.requestForAccessToHealth(completion: { result in
                    switch result {
                    case .success(_):
                        completion(true)
                    case .failure(_):
                        completion(false)
                    }
                })
            @unknown default:
                break
            }
        }
    }
}
