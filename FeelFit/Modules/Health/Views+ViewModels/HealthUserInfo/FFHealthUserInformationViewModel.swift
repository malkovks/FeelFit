//
//  FFHealthUserInformationViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 24.04.2024.
//

import UIKit

final class FFHealthUserInformationViewModel {
    
    private let viewController: UIViewController
    private let storeManager = FFUserHealthDataStoreManager.shared
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public var userDataDictionary: [[String:String]] = [
        ["Name":"Enter Name",
         "Second Name": "Enter Second Name"],
        ["Birthday":"Not Set",
         "Gender":"Not Set",
         "Blood Type":"Not Set",
         "Skin Type(Fitzpatrick Type)":"Not Set",
         "Stoller chair":"Not Set"],
        ["Load":"Load"],
        ["Save":"Save"]
    ]
    
    var tableViewData: [[String]] = [
        ["Name","Second Name"],
        ["Birthday","Gender","Blood Type","Skin Type(Fitzpatrick Type)","Stoller chair"],
        ["Load"],
        ["Save"]
    ]
    
    var userData: [[String]] = [
        [],
        []
    ]
    
    func loadFullUserData(){
        userData = storeManager.loadUserDataModel()
    }
    
    func requestToLoadHealthUserData(){
        viewController.defaultAlertController(message: "Do you want to load your own data from Health?", actionTitle: "Load") { [unowned self] in
            loadHealthUserData()
        }
    }
    
    private func loadHealthUserData(){
        FFHealthDataManager.shared.loadingCharactersData { [unowned self] data in
            userData[1].append(data?.dateOfBirth?.convertComponentsToDateString() ?? "Not set")
            userData[1].append(data?.userGender ?? "Not set")
            userData[1].append(data?.bloodType ?? "Not set")
            userData[1].append(data?.fitzpatrickSkinType ?? "Not set")
            userData[1].append(data?.wheelChairUse ?? "Not set")
        }
    }
    
    func saveUserData(){
        
    }
    
    
}
