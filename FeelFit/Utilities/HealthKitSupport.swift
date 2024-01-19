//
//  HealthKitSupport.swift
//  FeelFit
//
//  Created by Константин Малков on 19.01.2024.
//

import Foundation
import HealthKit

func getLastWeekStartDate(from date: Date = Date()) -> Date {
    return Calendar.current.date(byAdding: .day, value: -6, to: date)!
}
