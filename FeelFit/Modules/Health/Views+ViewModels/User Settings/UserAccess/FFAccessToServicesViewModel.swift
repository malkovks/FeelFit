//
//  FFAccessToServicesViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 11.05.2024.
//

import UIKit

protocol AccessToServicesDelegate: AnyObject {
    func didStartLoading()
    func didEndLoading()
}

class FFAccessToServicesViewModel {
    private let viewController: UIViewController
    
    weak var delegate: AccessToServicesDelegate?
    
    var accessData = EnableServiceStatus()
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func checkUserAccessToServices(){
        delegate?.didStartLoading()
        Task {
            let services = CheckServiceAuthentication()
            let value = await services.checkAccess()
            accessData = value
            delegate?.didEndLoading()
        }
    }
}
