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
    
    func loadSelectedCategoryData(filter: SelectedTimePeriodData,completion: @escaping (_ model: [FFUserHealthDataProvider]?) -> ()){
        let start = Calendar.current.date(byAdding: DateComponents(day: -6), to: Date())!
        let startDate = Calendar.current.startOfDay(for: start)
        FFHealthDataManager.shared.loadSelectedIdentifierData(filter: filter, identifier: selectedCategoryIdentifier, startDate: startDate, completion: completion)
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
    
    func handlerSelectedTimePeriod() -> SelectedTimePeriodData {
        let calendar = Calendar.current
        var components: DateComponents = .init(day: -6)
        var startDate = calendar.startOfDay(for: calendar.date(byAdding: components, to: Date())!)
        
        var detailText = createChartWeeklyDateRangeLabel(startDate: startDate)
        var horizontalTextArray = createHorizontalAxisMarkers()
        switch self {
        case .day:
            detailText = "Last 24 Hours"
            startDate = Calendar.current.startOfDay(for: Date())
            horizontalTextArray = createHoursHorizontalAxisForMarkers()
            return  SelectedTimePeriodData(components: .init(hour: 1), headerDetailText: detailText, dayInterval: -1, horizontalAxisMarkers: horizontalTextArray,startDate: startDate)
        case .week:
            return  SelectedTimePeriodData(components: .init(day: 1), headerDetailText: detailText, dayInterval: -6, horizontalAxisMarkers: horizontalTextArray,startDate: startDate)
        case .month:
            detailText = "Month"
            horizontalTextArray = createMonthHorizontalAxisMarkers()
            return SelectedTimePeriodData(components: .init(day: 30), headerDetailText: detailText, dayInterval: -30, horizontalAxisMarkers: horizontalTextArray,startDate: startDate)
        }
    }
}

struct SelectedTimePeriodData {
    var components: DateComponents
    var headerDetailText: String
    var dayInterval: Int
    var horizontalAxisMarkers: [String]
    var startDate: Date
}
