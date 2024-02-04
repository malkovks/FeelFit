//
//  AlertError+UIViewControllerExtensions.swift
//  FeelFit
//
//  Created by Константин Малков on 24.09.2023.
//

import UIKit

extension UIViewController {
    
    /// Function return alertController with default error or possibilities to custom it
    func alertError(title: String = "Error", message: String? = "", style: UIAlertController.Style = .alert, cancelTitle: String = "OK"){
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))
        present(alert, animated: true)
    }
}
