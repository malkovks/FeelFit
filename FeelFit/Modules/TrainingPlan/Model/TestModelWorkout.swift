//
//  TestModelWorkout.swift
//  FeelFit
//
//  Created by Константин Малков on 06.11.2023.
//

import Foundation

struct WorkoutModel: Codable {
    let idRequest: String
    let warmUp: [WorkoutExercise]
    let exercises: [MainExercises]
    let coolDown: [WorkoutExercise]
    let key: String
    
    private enum CodingKeys: String, CodingKey {
        case idRequest = "_id", warmUp = "Warm Up", exercises = "Exercises", coolDown = "Cool Down",key = "key"
    }
}

struct MainExercises: Codable {
    let exercise: String
    let sets: String
    let reps: String
    
    private enum CodingKeys: String, CodingKey {
        case exercise = "Exercise",sets = "Sets", reps = "Reps"
    }
}

struct WorkoutExercise: Codable {
    let exercise: String
    let time: String
    
    private enum CodingKeys: String, CodingKey {
        case exercise = "Exercise", time = "Time"
    }
}

