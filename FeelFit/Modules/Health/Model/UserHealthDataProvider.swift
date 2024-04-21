//
//  FFHealthData.swift
//  FeelFit
//
//  Created by Константин Малков on 10.01.2024.
//

import UIKit
import HealthKit

struct FFUserHealthDataProvider : Hashable{
    ///start period of loading data
    let startDate: Date
    ///End period of loading. Last time updating current value in HealthKit
    let endDate: Date
    ///Inherited and converted data from healthKit
    let value: Double
    ///String identifier of loading type data
    let identifier: String
    ///unit type include returning type of inherited data
    let unit: HKUnit
    ///type of sample searching for
    let type: HKSampleType
    ///health kit quantity type
    let typeIdentifier: HKQuantityTypeIdentifier?
}




