//
//  FFOnboardingAuthenticationViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 11.04.2024.
//

import UIKit

protocol FFAuthenticationDelegate: AnyObject {
    func didClearTextFields()
    func didTapConfirmButtons(completed: Bool)
}

protocol FFAuthenticationProtocol: AnyObject {
    var delegate: FFAuthenticationDelegate? { get set }
    func logoutFromAccount()
    func createNewAccount(user: CredentialUser?)
    func loginToAccount(user: CredentialUser?)
    func deleteAccount(user: CredentialUser?)
    func saveUserLoggedInStatus(isLoggedIn: Bool, userAccount: String?)
}

class FFOnboardingAuthenticationViewModel: FFAuthenticationProtocol {
    weak var delegate: FFAuthenticationDelegate?
    
    
    var userData: CredentialUser?
    
    let viewController: UIViewController
    private let accountManager = FFUserAccountManager.shared
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func logoutFromAccount(){
        viewController.defaultAlertController(message: "Do you want to log out from account?", actionTitle: "Log out", style: .alert) { [unowned self] in
            self.saveUserLoggedInStatus(isLoggedIn: false, userAccount: nil)
            delegate?.didTapConfirmButtons(completed: false)
        }
    }
    
    func saveEditsAndDismiss(completion: @escaping (_ status: Bool) -> ()){
        let boolean = FFUserHealthDataStoreManager.shared.isDataExisted()
        completion(boolean)
    }
    
    func createNewAccount(user: CredentialUser?){
        performKeychaingRequest(userData: user) { [weak self] userData in
            try self?.accountManager.createNewUserAccount(userData: userData)
        }
    }
    
    func loginToAccount(user: CredentialUser?){
        performKeychaingRequest(userData: user) {[weak self] userData in
            try self?.accountManager.loginToCreatedAccount(userData: userData)
        }
    }
    
    func deleteAccount(user: CredentialUser?){
        viewController.defaultAlertController(title: "Warning", message: "Do you really want to delete created account?", actionTitle: "Delete",style: .actionSheet) { [weak self] in
            self?.performKeychaingRequest(userData: user, requestFunction: { userData in
                try self?.accountManager.deleteUserAccountData(userData: userData)
                self?.delegate?.didClearTextFields()
            })
        }
    }
    
    func saveUserLoggedInStatus(isLoggedIn: Bool, userAccount: String?){
        UserDefaults.standard.setValue(isLoggedIn, forKey: "userLoggedIn")
        UserDefaults.standard.setValue(userAccount, forKey: "userAccount")
    }
    
    private func performKeychaingRequest(userData: CredentialUser?, requestFunction: (_ userData: CredentialUser?) throws -> Void){
        do {
            try requestFunction(userData)
            saveUserLoggedInStatus(isLoggedIn: true, userAccount: userData?.email)
            viewController.viewAlertController(text: "Successfully", startDuration: 0.5, timer: 4, controllerView: viewController.view)
            delegate?.didTapConfirmButtons(completed: true)
        } catch let error as KeychainError {
            saveUserLoggedInStatus(isLoggedIn: false, userAccount: nil)
            viewController.viewAlertController(text: error.errorDescription, startDuration: 0.5, timer: 4, controllerView: viewController.view)
            delegate?.didTapConfirmButtons(completed: false)
        } catch {
            saveUserLoggedInStatus(isLoggedIn: false, userAccount: nil)
            viewController.viewAlertController(text: "Fatal error", startDuration: 0.5, timer: 4, controllerView: viewController.view)
            delegate?.didTapConfirmButtons(completed: false)
        }
    }
}
