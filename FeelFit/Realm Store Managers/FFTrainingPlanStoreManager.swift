//
//  FFTrainingPlanStoreManager.swift
//  FeelFit
//
//  Created by Константин Малков on 09.12.2023.
//

import UIKit
import RealmSwift

class FFTrainingPlanStoreManager {
    
    static let shared = FFTrainingPlanStoreManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func savePlan(plan: CreateTrainProgram,exercises: [Exercise]){
        let exercisesObjects: [FFExerciseModelRealm] = exercises.map { data -> FFExerciseModelRealm in
            let exercise = FFExerciseModelRealm()
            exercise.exerciseID = data.exerciseID
            exercise.exerciseBodyPart = data.bodyPart
            exercise.exerciseEquipment = data.equipment
            exercise.exerciseImageLink = data.imageLink
            exercise.exerciseName = data.exerciseName
            exercise.exerciseMuscle = data.muscle
            exercise.exerciseSecondaryMuscles = data.secondaryMuscles.joined(separator: ", ")
            exercise.exerciseInstructions = data.instructions.joined(separator: ". ")
            return exercise
        }
        let data = FFTrainingPlanRealmModel(name: plan.name, notes: plan.note, location: plan.location, type: plan.type, date: plan.date, status: plan.notificationStatus, exercises: exercisesObjects)
        try! realm.write({
            realm.add(data)
        })
    }
    
}
