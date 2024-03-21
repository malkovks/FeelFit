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
    private let userCharactersTypes = Set(FFHealthData.charDataTypes)
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
    func getHealthAuthorizationRequestStatus(){
        if !HKHealthStore.isHealthDataAvailable()  {
            return
        }
        var textStatus: String = ""
        healthStore.getRequestStatusForAuthorization(toShare: shareTypes, read: readTypes) { [weak self] authStatus, error in
            switch authStatus {
            case .unknown:
                UserDefaults.standard.setValue(false, forKey: "healthKitAccess")
                textStatus = "Unknowned error occurred. Try again later."
            case .unnecessary:
                UserDefaults.standard.setValue(true, forKey: "healthKitAccess")
                textStatus = " Unnecessary .You have already allow all data for using "
            case .shouldRequest:
                self?.requestForAccessToHealth()
                UserDefaults.standard.setValue(false, forKey: "healthKitAccess")
                textStatus = "Should request .The app does not requested for all specific data yet"
            @unknown default:
                break
            }
        }
        print(textStatus)
    }
    
    ///Function necessary for accessing to steps data and loading it while application in background mode
    func requestAccessToBackgroundMode(completion handler: @escaping (Result<Bool,Error>) -> ()) {
        if !HKHealthStore.isHealthDataAvailable() {
            print("Can't get access to Health Kit")
            return
        }
        
        guard let steps = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        healthStore.enableBackgroundDelivery(for: steps, frequency: .immediate) { status, error in
            if status {
                handler(.success(status))
            } else if let error = error {
                handler(.failure(error))
            }
        }
    }
}
