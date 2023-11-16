//
//  FFFavouriteExerciseStoreManager.swift
//  FeelFit
//
//  Created by Константин Малков on 16.11.2023.
//

import UIKit
import RealmSwift

class FFFavouriteExerciseStoreManager {
    static let shared = FFFavouriteExerciseStoreManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func saveExercise(exercise: Exercise?){
        let model = FFExerciseModelRealm()
        let instructions = exercise?.instructions.joined(separator: " ")
        let secondaryMuscles = exercise?.secondaryMuscles.joined(separator: ", ")
        model.exerciseBodyPart = exercise?.bodyPart ?? "No data available"
        model.exerciseEquipment = exercise?.equipment ?? "No data available"
        model.exerciseImageLink = exercise?.imageLink ?? "No image"
        model.exerciseID = exercise?.exerciseID ?? "No ID"
        model.exerciseName = exercise?.exerciseName ?? "No exercise Name"
        model.exerciseMuscle = exercise?.muscle ?? "No data available"
        model.exerciseSecondaryMuscles = secondaryMuscles ?? "No data available"
        model.exerciseInstructions = instructions ?? "No instructions"
        DispatchQueue.main.async { [unowned self] in
            try! self.realm.write({
                self.realm.add(model)
                print("Save")
            })
        }
        
    }
    
    func deleteExerciseWith(model: Exercise){
        let id = String(describing: model.exerciseID)
        let deleteModel = realm.objects(FFExerciseModelRealm.self).filter("exerciseID == %@",id)
        DispatchQueue.main.async { [unowned self] in
            try! self.realm.write({
                self.realm.delete(deleteModel)
                print("Delete")
            })
        }
    }
    
    func clearExerciseWith(realmModel: FFExerciseModelRealm){
        let deleteModel = realm.objects(FFExerciseModelRealm.self).filter("exerciseID = \(realmModel.exerciseID)")
        DispatchQueue.main.async { [unowned self] in
            try! self.realm.write({
                self.realm.delete(deleteModel)
            })
        }
    }
}
