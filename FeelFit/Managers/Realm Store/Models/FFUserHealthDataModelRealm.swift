//
//  FFUserHealthDataModelRealm.swift
//  FeelFit
//
//  Created by Константин Малков on 04.05.2024.
//

import Foundation
import RealmSwift

class FFUserHealthDataModelRealm: Object {
    @Persisted(primaryKey: true) var userAccountLogin: String = UUID().uuidString
    @Persisted var userFirstName: String?
    @Persisted var userSecondName: String?

    @Persisted var userLoginStatus: Bool
    @Persisted var userBirthOfDate: Date?
    @Persisted var userBiologicalSex: String? = HealthStoreRequest.GenderTypeResult.notSet.rawValue
    @Persisted var userBloodType: String? = HealthStoreRequest.BloodTypeResult.notSet.rawValue
    @Persisted var userFitzpatrickSkinType: String? = HealthStoreRequest.FitzpatricSkinTypeResult.notSet.rawValue
    @Persisted var userWheelchairType: String? = HealthStoreRequest.WheelchairTypeResult.notSet.rawValue
    
    convenience init(userFirstName: String, userSecondName: String, userAccountLogin: String,userLoginStatus: Bool, userBirthOfDate: Date, userBiologicalSex: String, userBloodType: String, userFitzpatrickSkinType: String, userWheelchairType: String, userCalciumChannelBlockers: Bool, userBetaBlockers: Bool) {
        self.init()
        self.userAccountLogin = userAccountLogin
        self.userLoginStatus = userLoginStatus
        self.userFirstName = userFirstName
        self.userSecondName = userSecondName
        self.userBirthOfDate = userBirthOfDate
        self.userBiologicalSex = userBiologicalSex
        self.userBloodType = userBloodType
        self.userFitzpatrickSkinType = userFitzpatrickSkinType
        self.userWheelchairType = userWheelchairType
    }
}
