//
//  FFCreatePlanModel.swift
//  FeelFit
//
//  Created by Константин Малков on 14.11.2023.
//

import UIKit
import RealmSwift

class FFTrainingPlanRealmModel: Object {
    @Persisted dynamic var trainingUniqueID: String = UUID().uuidString
    @Persisted dynamic var trainingName: String = ""
    @Persisted dynamic var trainingNotes: String = ""
    @Persisted dynamic var trainingLocation: String?
    @Persisted dynamic var trainingType: String?
    @Persisted dynamic var trainingDate: Date
    @Persisted dynamic var trainingNotificationStatus: Bool = false
    @Persisted dynamic var trainingExercises = List<FFExerciseModelRealm>()
    
    convenience init(name: String, notes: String, location: String, type: String, date: Date, status: Bool, exercises: [FFExerciseModelRealm]) {
        self.init()
        self.trainingName = name
        self.trainingNotes = notes
        self.trainingLocation = location
        self.trainingType = type
        self.trainingDate = date
        self.trainingNotificationStatus = status
        self.trainingExercises.append(objectsIn: exercises)
    }
}

