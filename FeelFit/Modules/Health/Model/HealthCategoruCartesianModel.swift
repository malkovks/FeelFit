//
//  HealthCategoruCartesianModel.swift
//  FeelFit
//
//  Created by Константин Малков on 22.04.2024.
//

import HealthKit

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
        let components: DateComponents = .init(day: -6)
        var startDate = calendar.startOfDay(for: calendar.date(byAdding: components, to: Date())!)
        
        var detailText = createChartWeeklyDateRangeLabel(startDate: startDate)
        var horizontalTextArray = createHorizontalAxisMarkers()
        switch self {
        case .day:
            detailText = "Last 24 Hours"
            startDate = Calendar.current.startOfDay(for: Date())
            horizontalTextArray = createHoursHorizontalAxisForMarkers()
            return  SelectedTimePeriodData(components: .init(hour: 1), headerDetailText: detailText, horizontalAxisMarkers: horizontalTextArray,startDate: startDate, barSize: 20.0)
        case .week:
            return  SelectedTimePeriodData(components: .init(day: 1), headerDetailText: detailText, horizontalAxisMarkers: horizontalTextArray,startDate: startDate, barSize: 10.0)
        case .month:
            detailText = createMonthHorizontalAxisMarkers().first!
            horizontalTextArray = createMonthHorizontalAxisMarkers()
            startDate = calendar.date(byAdding: .day, value: -30, to: Date())!
            return SelectedTimePeriodData(components: .init(day: 1), headerDetailText: detailText, horizontalAxisMarkers: horizontalTextArray,startDate: startDate, barSize: 5.0)
        }
    }
}

struct SelectedTimePeriodData {
    var components: DateComponents
    var headerDetailText: String
    var horizontalAxisMarkers: [String]
    var startDate: Date
    var barSize: CGFloat
}
