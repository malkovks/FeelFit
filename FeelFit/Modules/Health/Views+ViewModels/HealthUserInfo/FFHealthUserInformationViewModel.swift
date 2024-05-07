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
        ["Load":""],
        ["Save":""]
    ]
    
    func loadUserData(){
        guard let data = storeManager.loadUserDataDictionary() else {
            viewController.alertError(message: "Error loading")
            return
        }
        
        userDataDictionary = data
    }
}
