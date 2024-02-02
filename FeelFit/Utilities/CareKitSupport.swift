//
//  CareKitSupport.swift
//  FeelFit
//
//  Created by Константин Малков on 19.01.2024.
//

import Foundation
import CareKit

//func applyTitleAndAxisMarkersConfiguration(startDate: Date, endDate: Date, dateType: HealthModelDate) {
//    switch dateType {
//    case .week:
//        <#code#>
//    case .month:
//        <#code#>
//    case .sixMonth:
//        <#code#>
//    case .year:
//        <#code#>
//    }
//}

func createChartWeeklyDateRangeLabel(startDate: Date?, lastDate: Date = Date()) -> String {
    let calendar: Calendar = .current

    let endOfWeekDate = lastDate
    let startOfWeekDate = startDate ?? getLastWeekStartDate()
    
    let monthDateFormatter = DateFormatter()
    monthDateFormatter.dateFormat = "MMM d"
    let monthDayYearDateFormatter = DateFormatter()
    monthDayYearDateFormatter.dateFormat = "MMM d, yyyy"
    
    var startDateString = monthDateFormatter.string(from: startOfWeekDate)
    var endDateString = monthDayYearDateFormatter.string(from: endOfWeekDate)
    
    if calendar.isDate(startOfWeekDate, equalTo: endOfWeekDate, toGranularity: .month){
        let dayYearDateFormatter = DateFormatter()
        
        dayYearDateFormatter.dateFormat = "d, yyyy"
        endDateString = dayYearDateFormatter.string(from: endOfWeekDate)
    }
    if !calendar.isDate(startOfWeekDate, equalTo: endOfWeekDate, toGranularity: .year) {
        startDateString = monthDayYearDateFormatter.string(from: startOfWeekDate)
    }
    
    return String(format: "%@-%@", startDateString, endDateString)
}

///Function return array of weekdays in correct row .It based on the desired time frame, where the last axis marker corresponds to "lastDate"
///"useWeekdays" will use short day abbreviations
func createHorizontalAxisMarkers(lastDate: Date = Date(), useWeekdays: Bool = true) -> [String] {
    let calendar: Calendar = .current
    let weekdayTitles = ["Sun","Mon", "Tue","Wed","Thu","Fri","Sat"]
    
    var titles: [String] = []
    if useWeekdays {
        titles = weekdayTitles
        let weekDay = calendar.component(.weekday, from: lastDate)
        return Array(titles[weekDay..<titles.count]) + Array(titles[0..<weekDay])
    } else {
        let numberOfTitles = weekdayTitles.count
        let endDate = lastDate
        let startDate = calendar.date(byAdding: DateComponents(day: -(numberOfTitles - 1)), to: endDate)!
        
        let dateFormatter = DateFormatter.createMonthDayFormatter()
        
        var date = startDate
        
        while date <= endDate {
            titles.append(dateFormatter.string(from: date))
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return titles
    }
}

func createHorizontalAxisMarkersForMonth(startDate: Date, endDate: Date = Date()) -> [String] {
    let calendar = Calendar.current
    var titles: [String] = []
    
    var currentDate = startDate
    var number = Int()
    while currentDate <= endDate {
        let day = calendar.component(.day, from: currentDate)
        currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        number += 1
        if number.isMultiple(of: 7){
            titles.append(String(describing: day))
        }
    }
    return titles
}

func createHorizontalAxisMarkersYear(_ endDate: Date = Date(),_ startDate: Date) -> [String] {
    let yearTitles = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    var titles: [String] = []
    let calendar = Calendar.current
    var firstRangeCount = calendar.component(.month, from: startDate)+1
    var currentRangeCount = calendar.component(.month, from: endDate)
    if firstRangeCount < 7 && currentRangeCount <= 12 {
        for i in firstRangeCount..<currentRangeCount {
            titles.append(yearTitles[i-1])
        }
    } else {
        let lastRange = firstRangeCount-currentRangeCount-6
        while firstRangeCount <= 12 {
            titles.append(yearTitles[firstRangeCount-1])
            firstRangeCount += 1
        }
        while currentRangeCount <= lastRange {
            titles.append(yearTitles[currentRangeCount-1])
            currentRangeCount += 1
        }
        
    }
    
    return titles
}


func createHorizontalAxisMarkers(for dates: [Date]) -> [String] {
    let dateFormatter: DateFormatter = DateFormatter.createMonthDayFormatter()
    return dates.map { dateFormatter.string(from: $0) }
}
