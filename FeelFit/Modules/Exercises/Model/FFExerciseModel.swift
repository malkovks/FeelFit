//
//  FFExerciseModel.swift
//  FeelFit
//
//  Created by Константин Малков on 07.11.2023.
//

import Foundation


struct Exercise: Codable {
    let bodyPart: String
    let equipment: String
    let imageLink: String
    let exerciseID: String
    let exerciseName: String
    let muscle: String
    let secondaryMuscles: [String]
    let instructions: [String]
    
    private enum CodingKeys: String, CodingKey {
        case bodyPart, equipment, imageLink = "gifUrl", exerciseID = "id", exerciseName = "name", muscle = "target", secondaryMuscles, instructions
    }
}
