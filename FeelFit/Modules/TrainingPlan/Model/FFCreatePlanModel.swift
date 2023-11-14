//
//  FFCreatePlanModel.swift
//  FeelFit
//
//  Created by Константин Малков on 14.11.2023.
//

import UIKit


struct TrainingSetup {
    let basic: BasicSettings
    let warmUp: WarmUpSettings
    let mainTrainPart: [MainTrainingPart]
    let hitch: HitchSettings
}

struct BasicSettings {
    let duration: String
    let location: String
    let type: String
    let dateString: String
    let date: Date
}

struct WarmUpSettings {
    let duration: String
    let type: String
}

struct MainTrainingPart {
    let weight: String?
    let repeats: String
    let approaches: String
    let exercise: Exercise
}

struct HitchSettings {
    let duration: String
    let type: String
}
