//
//  FFFavouriteExercisesModel.swift
//  FeelFit
//
//  Created by Константин Малков on 16.11.2023.
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
}
