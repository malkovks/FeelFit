//
//  CareKitSupport.swift
//  FeelFit
//
//  Created by Константин Малков on 19.01.2024.
//

import Foundation
import CareKit


func createChartWeeklyDateRangeLabel(startDate: Date?, lastDate: Date = Date()) -> String {
    let calendar: Calendar = .current

    let endOfWeekDate = lastDate
    let startOfWeekDate = startDate ?? lastDate.getLastWeekStartDate()
    
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



/// Function convert and return value as "01.01-02.01" where first number is day and second is month
func createMonthHorizontalAxisMarkers() -> [String] {
    let calendar = Calendar.current
    var result = [String]()
    
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM"
    
    let startDate = calendar.date(byAdding: .day, value: -30, to: Date())!
    let endDate = Date()
    
    let startString = dateFormatter.string(from: startDate)
    let endString = dateFormatter.string(from: endDate)
    
    let resultString = startString + " - " + endString
    result.append(resultString)
    return result
}

func createHoursHorizontalAxisForMarkers() -> [String] {
    var result = [String]()
    let now = Date()
    let calendar = Calendar.current
    let startOfDay = calendar.startOfDay(for: now)
    
    var currentHour = calendar.component(.hour, from: startOfDay)
    while currentHour <= calendar.component(.hour, from: now) {
        result.append(String(describing: currentHour))
        currentHour += 1
    }
    return result
}

func createHorizontalAxisMarkersForDay(endDate: Date = Date()) -> [String]{
    let calendar = Calendar.current
    let _ = calendar.startOfDay(for: endDate)
    
    let currentHour = calendar.component(.hour, from: endDate)
    
    var axisMarkers: [String] = []
    
    for hour in 0..<currentHour{
        axisMarkers.append(String(describing: hour))
    }
    
    return axisMarkers
}

func generateWeeklyDateIntervals() -> [String] {
    let calendar = Calendar.current
    let now = Date()
    
    var weeklyDateIntervals: [String] = []
    
    for i in 0..<4 {
        guard let startOfWeek = calendar.date(byAdding: .weekOfYear, value: -i, to: calendar.startOfDay(for: now)) else { continue }
        guard let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek) else { continue }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM"
        
        let startDateString = dateFormatter.string(from: startOfWeek)
        let endDateString = dateFormatter.string(from: endOfWeek)
        
        let weekInterval = "\(startDateString)-\(endDateString)"
        weeklyDateIntervals.append(weekInterval)
    }
    
    return weeklyDateIntervals.reversed()
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
