//
//  FFHealthCategoryCartesianViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 16.04.2024.
//

import UIKit
import CareKit
import HealthKit

class FFHealthCategoryCartesianViewModel {
    
    
    
    private let viewController: UIViewController
    private let selectedCategoryIdentifier: HKQuantityTypeIdentifier
    
    init(viewController: UIViewController, selectedCategoryIdentifier: HKQuantityTypeIdentifier) {
        self.viewController = viewController
        self.selectedCategoryIdentifier = selectedCategoryIdentifier
    }
    
    func loadSelectedCategoryData(completion: @escaping (_ model: [FFUserHealthDataProvider]?) -> ()){
        let start = Calendar.current.date(byAdding: DateComponents(day: -7), to: Date())!
        let startDate = Calendar.current.startOfDay(for: start)
        let endDate = Calendar.current.date(byAdding: DateComponents(day: 1), to: Date())!
        FFHealthDataLoading.shared.loadSelectedIdentifierData(identifier: selectedCategoryIdentifier, startDate: startDate, endDate: endDate, completion: completion)
        
    }
}
