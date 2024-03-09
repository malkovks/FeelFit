//
//  AlertControllerTwoActions.swift
//  FeelFit
//
//  Created by Константин Малков on 16.12.2023.
//

import UIKit

extension UIViewController {
    /// Function for presenting alert with inheriting two action.Cancel button almost added and dont need to setup it
    /// - Parameters:
    ///   - title: title message
    ///   - message: subtitle
    ///   - confirmActionTitle: title for positive action
    ///   - secondTitleAction: title for negative action
    ///   - style: style of alert
    ///   - action: first action method for positive action
    ///   - secondAction: second action method for negative action
    func alertControllerActionConfirm(title: String?, message: String?,confirmActionTitle: String,secondTitleAction: String?,style: UIAlertController.Style,action: @escaping () -> (), secondAction: @escaping ()->()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default) { _ in
            action()
        }
        let clearAction = UIAlertAction(title: secondTitleAction, style: .destructive) { _ in
            secondAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        if secondTitleAction != "" || secondTitleAction != nil {
            alert.addAction(clearAction)
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func defaultAlertController(title: String? = nil, message: String? = nil, actionTitle: String = "OK", style: UIAlertController.Style = .alert, action: @escaping () -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { _ in
            action()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

