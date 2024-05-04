//
//  FFExersiceModelRealm.swift
//  FeelFit
//
//  Created by Константин Малков on 29.11.2023.
//

import UIKit
import RealmSwift

class FFExerciseModelRealm: Object {
    @Persisted var exerciseBodyPart: String
    @Persisted var exerciseEquipment: String
    @Persisted var exerciseImageLink: String
    @Persisted var exerciseID: String
    @Persisted var exerciseName: String
    @Persisted var exerciseMuscle: String
    @Persisted var exerciseSecondaryMuscles: String
    @Persisted var exerciseInstructions: String
    @Persisted var exerciseApproach: String = "4"
    @Persisted var exerciseRepeat: String = "10"
    @Persisted var exerciseWeight: String = "0"
    @Persisted var exerciseCompleteStatus: Bool = false
    
    convenience init(exercise: Exercise) {
        self.init()
        self.exerciseBodyPart = exercise.bodyPart
        self.exerciseEquipment = exercise.equipment
        self.exerciseImageLink = exercise.imageLink
        self.exerciseID = exercise.exerciseID
        self.exerciseName = exercise.exerciseName
        self.exerciseMuscle = exercise.muscle
        self.exerciseSecondaryMuscles = exercise.secondaryMuscles.joined(separator: ". ")
        self.exerciseInstructions = exerciseInstructions
    }
}
