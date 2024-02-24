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
    
    func savePlanExercise(plan: CreateTrainProgram,exercises: [Exercise]){
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
        let data = FFTrainingPlanRealmModel(
            name: plan.name,
            notes: plan.note,
            location: plan.location ?? "Default",
            type: plan.type ?? "Default",
            date: plan.date,
            status: plan.notificationStatus,
            exercises: exercisesObjects
        )
        try! realm.write({
            realm.add(data)
            if data.trainingNotificationStatus {
                createNotification(data)
            }
        })
    }
    
    func savePlanRealmModel(_ plan: CreateTrainProgram,_ model: [FFExerciseModelRealm]){
        let data = FFTrainingPlanRealmModel(
            name: plan.name,
            notes: plan.note,
            location: plan.location ?? "Default",
            type: plan.type ?? "Default",
            date: plan.date,
            status: plan.notificationStatus,
            exercises: model
        )
        try! realm.write({
            realm.add(data)
            if data.trainingNotificationStatus {
                createNotification(data)
            }
        })
    }
    
    func editPlanRealmModel(_ plan: CreateTrainProgram, _ model: [FFExerciseModelRealm],_ trainModel: FFTrainingPlanRealmModel){
        
        let object = realm.objects(FFTrainingPlanRealmModel.self).filter("trainingUniqueID == %@", trainModel.trainingUniqueID).first
        try! realm.write({
            object?.trainingExercises = List<FFExerciseModelRealm>()
            for n in model {
                object?.trainingExercises.append(n)
            }
        })
    }
    
    
    func deleteModel(_ model: FFTrainingPlanRealmModel){
        try! realm.write({
            realm.delete(model)
        })
    }
    
    func deletePlan(_ model: FFTrainingPlanRealmModel){
        try! realm.write({
            realm.delete(model)
        })
    }
    
    private func createNotification(_ model: FFTrainingPlanRealmModel){
        let sound = UNNotificationSound(named: UNNotificationSoundName("ding.mp3"))
        guard let image = Bundle.main.url(forResource: "arnold_run", withExtension: "jpeg") else {
            return
        }
        
        let dateComponents: DateComponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: model.trainingDate)
        let id = model.trainingUniqueID
        let attachment = try! UNNotificationAttachment(identifier: id, url: image, options: nil)
        
        let content = UNMutableNotificationContent()
        content.title = model.trainingName.capitalized
        content.body = model.trainingNotes.capitalized
        content.sound = sound
        content.attachments = [attachment]
        if model.trainingType != "" {
            content.subtitle = "Type: \(String(describing: model.trainingType))"
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }

    
    
    
}
