//
//  FFTrainingPlanRealmModel.swift
//  FeelFit
//
//  Created by Константин Малков on 14.11.2023.
//

import UIKit
import RealmSwift

class FFTrainingPlanRealmModel: Object {
    ///Unique id created every time when user create new plan
    @Persisted dynamic var trainingUniqueID: String = UUID().uuidString
    ///Name of training which sets from textField. Default value is ""
    @Persisted dynamic var trainingName: String = ""
    /// Notes which inherit text from textView. Default value is ""
    @Persisted dynamic var trainingNotes: String = ""
    /// Location return name of chosen train location. Default value "Not specified"
    @Persisted dynamic var trainingLocation: String? = "Not specified"
    /// Type of training like cardio,strength and etc. Default value "Not specified
    @Persisted dynamic var trainingType: String? = "Not specified"
    /// Custom date of planning train. Default value is current date
    @Persisted dynamic var trainingDate: Date = Date()
    @Persisted dynamic var trainingNotificationStatus: Bool = false
    ///Array for appending or export exercises. Default value is List<FFExerciseModelRealm>() and return nil
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

