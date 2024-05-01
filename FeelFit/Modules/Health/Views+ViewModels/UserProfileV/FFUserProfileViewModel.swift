//
//  FFUserProfileViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 01.02.2024.
//

import UIKit
import PhotosUI

class FFUserProfileViewModel: HandlerUserProfileImageProtocol {
    private let viewController: UIViewController
    private let cameraPickerController: UIImagePickerController
    private let pickerViewController: PHPickerViewController
    
    var userMainData = FFUserHealthMainData(fullName: "No name exist", account: "No account")
    var fullUserData = FFUserHealthDataModelRealm()
    var isUserLoggedIn = FFAuthenticationManager.shared.isUserEnteredInAccount()
    
    init(viewController: UIViewController, cameraPickerController: UIImagePickerController, pickerViewController: PHPickerViewController) {
        self.viewController = viewController
        self.cameraPickerController = cameraPickerController
        self.pickerViewController = pickerViewController
    }
    
    
    /// Function open details about user's health
    func pushUserHealthData(){
        let vc = FFHealthUserInformationViewController()
        vc.userImage = managedUserImage
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushUserData(){
        let vc = FFUserAccountViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func clearUserCache(){
        defaultAlertController(title: "Clear cache", message: "Do you want to delete all cached information?", actionTitle: "Delete", style: .alert, buttonStyle: .destructive) {
            print("Delete")
        }
    }
    
    func clearStoreData(){
        guard let textSize = collectRealmStorageWeight() else { return }//подсчет веса данных всех моделей реалма на устройстве
        defaultAlertController(title: "Clear store data", message: "Storage memory fille on \(textSize) MB.\nDo you want to delete storage and delete all data?", actionTitle: "Delete", style: .alert, buttonStyle: .destructive) {
            print("Delete")
        }
    }
    
    func checkAccessStatus(){
        let vc = FFAccessToServicesViewController()
        let nav = FFNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        nav.isNavigationBarHidden = false
        nav.sheetPresentationController?.detents = [.medium()]
        nav.sheetPresentationController?.prefersGrabberVisible = true
        present(nav, animated: true)
    }

    func exitFromAccount(){
        
        let id = fullUserData.userAccountLogin
        let alert = UIAlertController(title: "Exit from account", message: "Your ID is \(id) and you want to leave this account.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Continue", style: .destructive, handler: { [weak self ] _ in
            FFAuthenticationManager.shared.didExitFromAccount()
            let vc = FFOnboardingAuthenticationViewController()
            vc.saveEditedAccountButton.isHidden = false
            vc.isDataCreated = { status in
                FFUserHealthDataStoreManager.shared.loadUserDataDictionary()
            }
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
            
        }))
        present(alert, animated: true)
    }
}
