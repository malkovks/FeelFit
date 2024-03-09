//
//  FFUserHealthDataModelRealm.swift
//  FeelFit
//
//  Created by Константин Малков on 24.02.2024.
//

import UIKit
import RealmSwift

class FFUserHealthDataModelRealm: Object {
    @Persisted var userFirstName: String
    @Persisted var userSecondName: String
    @Persisted var userBirthOfDate: Date
    @Persisted var userBiologicalSex: String = HealthStoreRequest.GenderTypeResult.notSet.rawValue
    @Persisted var userBloodType: String = HealthStoreRequest.BloodTypeResult.notSet.rawValue
    @Persisted var userFitzpatrickSkinType: String = HealthStoreRequest.FitzpatricSkinTypeResult.notSet.rawValue
    @Persisted var userWheelchairType: String = HealthStoreRequest.WheelchairTypeResult.notSet.rawValue
    @Persisted var userCalciumChannelBlockers: Bool = false
    @Persisted var userBetaBlockers: Bool = false
    
    convenience init(userFirstName: String, userSecondName: String, userBirthOfDate: Date, userBiologicalSex: String, userBloodType: String, userFitzpatrickSkinType: String, userWheelchairType: String, userCalciumChannelBlockers: Bool, userBetaBlockers: Bool) {
        self.init()
        self.userFirstName = userFirstName
        self.userSecondName = userSecondName
        self.userBirthOfDate = userBirthOfDate
        self.userBiologicalSex = userBiologicalSex
        self.userBloodType = userBloodType
        self.userFitzpatrickSkinType = userFitzpatrickSkinType
        self.userWheelchairType = userWheelchairType
        self.userCalciumChannelBlockers = userCalciumChannelBlockers
        self.userBetaBlockers = userBetaBlockers
    }
}

class FFUserHealthDataStoreManager {
    static let shared = FFUserHealthDataStoreManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func saveNewUserData(){
        
    }
    
    func editUserData(){
        
    }
    
    func deleteUsersData(){
        
    }
}
