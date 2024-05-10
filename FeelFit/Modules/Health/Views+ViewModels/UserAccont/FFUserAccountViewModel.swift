//
//  FFUserAccountViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 10.05.2024.
//

import UIKit

protocol UserAccountDelegate: AnyObject {
    func didLoadUserData()
    func didChangeUserName(text: String)
}

class FFUserAccountViewModel {
    
    weak var delegate: UserAccountDelegate?
    
    var userData: FFUserHealthMainData = .init(fullName: "Name example", account: "example@mail.com")
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController!) {
        self.viewController = viewController
    }
    
    func changeUserAccount(){
        viewController.defaultAlertController(title: "Warning", message: "Do you want to leave account?",actionTitle: "Leave",buttonStyle: .destructive) { [unowned self] in
            FFAuthenticationManager.shared.didExitFromAccount()
            let vc = FFOnboardingAuthenticationViewController(type: .authenticationOnlyDisplay)
            vc.modalPresentationStyle = .fullScreen
            viewController.present(vc, animated: true)
        }
    }
    
    func loadUserData(){
        guard let data = FFUserMainDataManager().loadUserMainData() else { return }
        userData = data
        delegate?.didLoadUserData()
    }
    
    func changeUserName(){
        let alertController = UIAlertController(title: "", message: "Enter your name and second name", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter name"
            textField.autocapitalizationType = .words
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter second Name"
            textField.autocapitalizationType = .words
        }
        
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            let text1 = alertController.textFields?[0].text ?? "Name"
            let text2 = alertController.textFields?[1].text ?? "Second Name"
            let fullName = text1.removeSpaces() + " " + text2.removeSpaces()
            self.delegate?.didChangeUserName(text: fullName)
            FFUserMainDataManager().saveUserName(name: text1, secondName: text2)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        viewController.present(alertController, animated: true)
    }
}
