//
//  FFUserMainDataManager.swift
//  FeelFit
//
//  Created by Константин Малков on 04.05.2024.
//

import UIKit
import RealmSwift

class FFUserMainDataManager {
    
    private let realm = try! Realm()
    
    let authenticationData = FFUserHealthDataStoreManager.shared.loadUserAuthenticationStatus()
    
    private func getUserData(byKey primaryKey: String) -> FFUserHealthDataModelRealm? {
        return realm.object(ofType: FFUserHealthDataModelRealm.self, forPrimaryKey: primaryKey)
    }
    
    func loadUserMainData() -> FFUserHealthMainData? {
        let key = authenticationData.account
        guard let userData = getUserData(byKey: key) else { return nil }
        let name = userData.userFirstName ?? "Name - "
        let secondName = userData.userSecondName ?? "Second name"
        let fullName = name + " " + secondName
        return FFUserHealthMainData(fullName: fullName, account: userData.userAccountLogin)
    }
    
    func saveUserName(name text: String, secondName secondText: String) {
        let key = authenticationData.account
        if let user = getUserData(byKey: key) {
            user.userFirstName = text
            user.userSecondName = secondText
            realm.add(user, update: .modified)
        } else {
            print("Model was not found by this key")
        }
    }
}
