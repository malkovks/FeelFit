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
    
    func loadSelectedCategoryData(filter: SelectedTimePeriodData?,completion: @escaping (_ model: [FFUserHealthDataProvider]?) -> ()){
        let start = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
        let startDate = Calendar.current.startOfDay(for: start)
        FFHealthDataLoading.shared.loadSelectedIdentifierData(filter: filter, identifier: selectedCategoryIdentifier, startDate: startDate, completion: completion)
    }
}

enum SelectedTimePeriodType: Int {
    
    
    case day = 0
    case week = 1
    case month = 2
    
    init(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .day
        case 1:
            self = .week
        case 2:
            self = .month
        default:
            self = .week
            break
        }
    }
    // TODO: Сделать настройки сегментов
    func handlerSelectedTimePeriod() -> SelectedTimePeriodData? {
        let calendar = Calendar.current
        var data: SelectedTimePeriodData?
        var components: DateComponents = .init(day: -6)
        var startDate = calendar.startOfDay(for: calendar.date(byAdding: components, to: Date())!)
        
        var text = createChartWeeklyDateRangeLabel(startDate: startDate)
        switch self {
        case .day:
            text = "24 Hours"
            startDate = Calendar.current.startOfDay(for: Date())
            
            data = SelectedTimePeriodData(components: .init(hour: 1), headerDetailText: text, dayInterval: -1,startDate: startDate)
        case .week:
            data = SelectedTimePeriodData(components: .init(day: 1), headerDetailText: text, dayInterval: -6,startDate: startDate)
        case .month:
            text = "Month"
            data = SelectedTimePeriodData(components: .init(day: 30), headerDetailText: text, dayInterval: -30,startDate: startDate)
        }
        return data
    }
}

struct SelectedTimePeriodData {
    var components: DateComponents
    var headerDetailText: String
    var dayInterval: Int
    var startDate: Date
}
