//
//  AlertControllerTwoActions.swift
//  FeelFit
//
//  Created by Константин Малков on 16.12.2023.
//

import UIKit

extension UIViewController {
    /// Function for presenting alert with inheriting two action
    /// - Parameters:
    ///   - title: title message
    ///   - message: subtitle
    ///   - confirmActionTitle: title for positive action
    ///   - secondTitleAction: title for negative action
    ///   - style: style of alert
    ///   - action: first action method for positive action
    ///   - secondAction: second action method for negative action
    func alertControllerActionConfirm(title: String?, message: String?,confirmActionTitle: String,secondTitleAction: String?,style: UIAlertController.Style,action: @escaping () -> (), secondAction: @escaping () -> ()?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let confirmAction = UIAlertAction(title: confirmActionTitle, style: .default) { _ in
            action()
        }
        let clearAction = UIAlertAction(title: secondTitleAction, style: .destructive) { _ in
            secondAction()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(confirmAction)
        if secondTitleAction != "" {
            alert.addAction(clearAction)
        }
        
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
