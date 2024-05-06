//
//  FFUserHealthDataModelRealm.swift
//  FeelFit
//
//  Created by Константин Малков on 24.02.2024.
//

import UIKit
import RealmSwift



class FFUserHealthDataStoreManager {
    static let shared = FFUserHealthDataStoreManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    
    func loadUserAuthenticationStatus() -> (status: Bool,account: String) {
        let isLoggedIn = FFAuthenticationManager.shared.isUserEnteredInAccount()
        guard let userAccount = UserDefaults.standard.string(forKey: "userAccount")
        else {
            return (false, UUID().uuidString)
        }
        return (isLoggedIn, userAccount)
    }
    
    func isDataExisted() -> Bool {
        let value = loadUserAuthenticationStatus()
        if let _ = realm.object(ofType: FFUserHealthDataModelRealm.self, forPrimaryKey: value.account){
            return true
        } else {
            createNewUserData(enterStatus: value.status, account: value.account)
            return false
        }
    }
    
    func isDataAlmostCreated(userAccount: String?) {
        guard let key = userAccount else { return }
        if let _ = realm.object(ofType: FFUserHealthDataModelRealm.self, forPrimaryKey: key){
            print("Model almost created")
        } else {
            createNewUserData(enterStatus: true, account: key)
        }
    }
    
    func createNewUserData(enterStatus: Bool, account: String){
        let futureModel = FFUserHealthDataModelRealm()
        futureModel.userAccountLogin = account
        futureModel.userLoginStatus = enterStatus
        futureModel.userFirstName = "Not set"
        do {
            try! realm.write {
                realm.add(futureModel,update: .modified)
                print(futureModel.userAccountLogin)
            }
        }
    }
    
    
    func saveNewUserData(_ userDataDictionary: [[String:String]]) -> Result <Bool,Error> {
        let futureModel = FFUserHealthDataModelRealm()
        let authData = loadUserAuthenticationStatus()
        futureModel.userLoginStatus = authData.status
        futureModel.userAccountLogin = authData.account
        
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
        
        if let existedData = realm.object(ofType: FFUserHealthDataModelRealm.self, forPrimaryKey: futureModel.userAccountLogin) {
            do {
                try realm.write({
                    realm.delete(existedData)
                    realm.add(futureModel,update: .modified)
                })
                return .success(true)
            } catch {
                return .failure(error)
            }
        } else {
            do {
                try realm.write({
                    realm.add(futureModel,update: .modified)
                })
                return .success(true)
            } catch {
                return .failure(error)
            }
        }
    }
    
    func mainUserData() -> FFUserHealthMainData? {
        guard let userData = realm.objects(FFUserHealthDataModelRealm.self).last else { return nil }
        let name = userData.userFirstName ?? "Name - "
        let secondName = userData.userSecondName ?? "Second name"
        let fullName = name + " " + secondName
        let value = FFUserHealthMainData(fullName: fullName, account: userData.userAccountLogin)
        return value
    }
    
    func loadUserDataDictionary() -> [[String:String]]?{
        let value = loadUserAuthenticationStatus()
        guard let userData = realm.object(ofType: FFUserHealthDataModelRealm.self, forPrimaryKey: value.account) else { return nil }
        let birthday = userData.userBirthOfDate?.dateAndUserAgeConverting()
        let userDataDictionary: [[String: String]] = [
            ["Name": userData.userFirstName ?? "Not Set",
             "Second Name": userData.userSecondName ?? "Not Set"],
            ["Birthday": birthday ?? "Not Set",
             "Gender": userData.userBiologicalSex ?? "Not Set",
             "Blood Type": userData.userBloodType ?? "Not Set",
             "Skin Type(Fitzpatrick Type)": userData.userFitzpatrickSkinType ?? "Not Set",
             "Stoller chair":userData.userWheelchairType ?? "Not Set"]
             ]
        return userDataDictionary
    }
    
    func loadUserDataModel() -> FFUserHealthDataModelRealm?  {
        let userData = realm.objects(FFUserHealthDataModelRealm.self).last
        return userData ?? nil
    }
    
    
    func editUserData(){
        
    }
    
    func deleteUsersData(){
        
    }
}


