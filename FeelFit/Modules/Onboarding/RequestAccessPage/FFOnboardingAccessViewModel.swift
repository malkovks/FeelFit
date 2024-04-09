//
//  FFOnboardingAccessViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 09.04.2024.
//

import UIKit

protocol FFOnboardingAccessDelegate: AnyObject {
    func didGetAccessToAllServices()
}

class FFOnboardingAccessViewModel {
    var accessArray: [Bool] = [false,false,false,false]
    weak var delegate: FFOnboardingAccessDelegate?
    
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    //Доделать методы запроса данных у пользователя
    func askForAccessToNotification(_ button: UIButton, requestHandler: @escaping (@escaping (Result<Bool,Error>) -> Void) -> Void){
        requestHandler { [weak self] result in
            DispatchQueue.main.async {
                button.configuration?.showsActivityIndicator = true
            }
            switch result {
            case .success(let success):
                self?.setupButtonConfirm(isAccessed: success, button)
            case .failure(let failure):
                self?.setupButtonConfirm(isAccessed: false, button, error: failure)
            }
        }
    }
    
    private func setupButtonConfirm(isAccessed: Bool,_ button: UIButton,error: Error? = nil){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let error = error {
                self.viewController.viewAlertController(text: error.localizedDescription, startDuration: 0.5, timer: 4, controllerView: self.viewController.view)
                button.configuration?.showsActivityIndicator = false
            } else {
                self.accessArray[button.tag] = isAccessed
                UIView.animate(withDuration: 0.2) {
                    button.configuration?.showsActivityIndicator = !isAccessed
                    button.configuration?.title = isAccessed ? "Access confirmed": "Access denied"
                    button.isEnabled = isAccessed ? true : false
                    button.configuration?.image = isAccessed ? UIImage(systemName: "lock.open") : UIImage(systemName: "lock")
                    button.configuration?.baseBackgroundColor = .systemGreen
                    self.viewController.view.layoutIfNeeded()
                }
            }
            
            if self.accessArray.allSatisfy({ $0 }) {
                delegate?.didGetAccessToAllServices()
            }
        }
    }
}
