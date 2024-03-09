//
//  BackgroundTasksSupport.swift
//  FeelFit
//
//  Created by Константин Малков on 27.02.2024.
//

import Foundation
import BackgroundTasks

class FFBackgroundTasksAccess {
    static let shared = FFBackgroundTasksAccess()
    
    private let identifiers: [String] = [
        "Malkov.KS.FeelFit.fitnessApp.refresh",
        "Malkov.KS.FeelFit.fitnessApp.health_data_refresh"
    ]
    
//    func requestBackgroundTaskPermission(identifierForTask: String ,completion: @escaping (_ success: Bool) -> ()) {
//        requestForAccessBackgroundTasks(identifier: identifierForTask) { [weak self] success in
//            switch success {
//            case true:
//                completion(success)
//            case false:
//                print("false")
//            }
//        }
//    }
    
//    func requestForAccessBackgroundTasks(identifier: String, using queue: dispatch_queue_t? = nil,completion: @escaping (_ success: Bool) -> ()){
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: identifier, using: queue) { task in
//            
//        }
//        
//    }
}


