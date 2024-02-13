//
//  AlertTextField+UIViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 13.02.2024.
//

import UIKit

extension UIViewController {
    func manualEnterHealthData(_ title: String,_ message: String?,action: @escaping (_ result: Double)->()){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = title
            textField.clearButtonMode = .whileEditing
            textField.font = UIFont.textLabelFont(size: 14)
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { [ weak alertController] _ in
            guard let alertController = alertController,
                  let textField = alertController.textFields?.first else {
                return
            }
            if let string = textField.text,
               let doubleValue = Double(string) {
                action(doubleValue)
            }
        }))
        present(alertController, animated: true)
    }
}
