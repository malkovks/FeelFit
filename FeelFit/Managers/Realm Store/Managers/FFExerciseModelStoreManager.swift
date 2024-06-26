//
//  FFExerciseModelStoreManager.swift
//  FeelFit
//
//  Created by Константин Малков on 30.11.2023.
//

import UIKit
import RealmSwift

class FFExerciseStoreManager {
    static let shared = FFExerciseStoreManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func saveLoadData(model: [Exercise]) {
        let _ = model.map { data in
            let exercise = FFExerciseModelRealm()
            exercise.exerciseID = data.exerciseID
            exercise.exerciseBodyPart = data.bodyPart
            exercise.exerciseEquipment = data.equipment
            exercise.exerciseImageLink = data.imageLink
            exercise.exerciseName = data.exerciseName
            exercise.exerciseMuscle = data.muscle
            exercise.exerciseSecondaryMuscles = data.secondaryMuscles.joined(separator: ", ")
            exercise.exerciseInstructions = data.instructions.joined(separator: ". ")
            
            let savedObject = realm.objects(FFExerciseModelRealm.self).filter("exerciseID == %@",exercise.exerciseID).first
            
            if let _ = savedObject {
                
            } else {
                try! realm.write({
                    realm.add(exercise)
                })
            }
        }
    }
    
    func loadMusclesData(_ filterName: String,filter: String = "exerciseMuscle") -> [Exercise] {
        let value = realm.objects(FFExerciseModelRealm.self).filter("\(filter) == %@", filterName)
        let valueArray: [Exercise] = value.map { data -> Exercise in
            let exercise = Exercise(bodyPart: data.exerciseBodyPart,
                                    equipment: data.exerciseEquipment,
                                    imageLink: data.exerciseImageLink,
                                    exerciseID: data.exerciseID,
                                    exerciseName: data.exerciseName,
                                    muscle: data.exerciseMuscle,
                                    secondaryMuscles: [data.exerciseSecondaryMuscles],
                                    instructions: [data.exerciseInstructions])
            return exercise
        }
        return valueArray
    }
    
    func updateImageLink(newImageLink string: String,exerciseID: String) {
        let object = realm.objects(FFExerciseModelRealm.self).filter("exerciseID == %@",exerciseID)
        try! realm.write({
            object.first?.exerciseImageLink = string
        })
    }
    
    func checkDuplicates(_ filterName: String) {
        let values = realm.objects(FFExerciseModelRealm.self).filter("exerciseMuscle == %@", filterName)
        var uniqueValue = [FFExerciseModelRealm]()
        var duplicatesCount = Int()
        for value in values {
            if !uniqueValue.contains(value){
                uniqueValue.append(value)
            } else {
                duplicatesCount += 1
            }
        }
        
        for exercise in uniqueValue {
            try! realm.write({
                realm.add(exercise)
            })
        }
        
    }
    
}
