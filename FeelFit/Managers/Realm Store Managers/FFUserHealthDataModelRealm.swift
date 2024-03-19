//
//  FFUserHealthDataModelRealm.swift
//  FeelFit
//
//  Created by Константин Малков on 24.02.2024.
//

import UIKit
import RealmSwift

class FFUserHealthDataModelRealm: Object {
    @Persisted var userFirstName: String?
    @Persisted var userSecondName: String?
    @Persisted var userAccountLogin: String?
    @Persisted var userLoginAccount: Bool
    @Persisted var userBirthOfDate: Date?
    @Persisted var userBiologicalSex: String? = HealthStoreRequest.GenderTypeResult.notSet.rawValue
    @Persisted var userBloodType: String? = HealthStoreRequest.BloodTypeResult.notSet.rawValue
    @Persisted var userFitzpatrickSkinType: String? = HealthStoreRequest.FitzpatricSkinTypeResult.notSet.rawValue
    @Persisted var userWheelchairType: String? = HealthStoreRequest.WheelchairTypeResult.notSet.rawValue
    
    convenience init(userFirstName: String, userSecondName: String, userBirthOfDate: Date, userBiologicalSex: String, userBloodType: String, userFitzpatrickSkinType: String, userWheelchairType: String, userCalciumChannelBlockers: Bool, userBetaBlockers: Bool) {
        self.init()
        self.userFirstName = userFirstName
        self.userSecondName = userSecondName
        self.userBirthOfDate = userBirthOfDate
        self.userBiologicalSex = userBiologicalSex
        self.userBloodType = userBloodType
        self.userFitzpatrickSkinType = userFitzpatrickSkinType
        self.userWheelchairType = userWheelchairType
    }
}

class FFUserHealthDataStoreManager {
    static let shared = FFUserHealthDataStoreManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func saveNewUserData(_ userDataDictionary: [[String:String]]){
        let futureModel = FFUserHealthDataModelRealm()
        
        let userDataCount = userDataDictionary.count
        for index in 0..<userDataCount {
            let dictionary = userDataDictionary[index]
            let keys: [String] = Array(dictionary.keys).sorted()
            for key in keys {
                let value = dictionary[key] ?? "Not Set"
                switch key {
                case "Name":
                    futureModel.userFirstName = value
                case "Second Name":
                    futureModel.userSecondName = value
                case "Birthday":
                    futureModel.userBirthOfDate = value.convertStringToDate() ?? Date()
                case "Gender":
                    futureModel.userBiologicalSex = value
                case "Blood Type":
                    futureModel.userBloodType = value
                case "Skin Type(Fitzpatrick Type)":
                    futureModel.userFitzpatrickSkinType = value
                case "Stoller chair":
                    futureModel.userFitzpatrickSkinType = value
                    
                default:
                    break
                }
            }
        }
        
        try! realm.write({
            realm.add(futureModel)
        })
        
        dump(futureModel)
        
    }
    
//    func loadUserData() -> [[String:String]]{
//        
//    }
    
    func editUserData(){
        
    }
    
    func deleteUsersData(){
        
    }
}
