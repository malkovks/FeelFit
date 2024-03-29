//
//  AlertWithTextField.swift
//  FeelFit
//
//  Created by Константин Малков on 23.03.2024.
//

import UIKit

extension UIViewController {
    
    
    /// Function for call custom alert controller with text field and two buttons
    /// - Parameters:
    ///   - placeholder: Optional string value for placeholder. Default value is "Enter value"
    ///   - keyboardType: Type of displayable keyboard while user work with alert controller. Default value is .default
    ///   - text: Optional value for text field if user need to edit previous text value. Default equal nil
    ///   - alertTitle: Optional value title for alert controller. Default value is nil
    ///   - message: Optional value message for alert controller. Default value is nil
    ///   - handler: Completion handler return string value if text field text is not equal nil
    func presentTextFieldAlertController(placeholder: String? = "Enter value",
                                         keyboardType: UIKeyboardType = .default,
                                         text: String? = nil,
                                         alertTitle: String? = nil,
                                         message: String? = nil,
                                         completion handler: @escaping (_ text: String) -> () ){
        let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        
        
        alertController.addTextField { textField in
            textField.placeholder = placeholder
            textField.text = text
            textField.enablesReturnKeyAutomatically = true
            textField.textColor = .customBlack
            textField.textAlignment = .left
            textField.autocapitalizationType = .words
            textField.clearButtonMode = .always
            textField.font = UIFont.textLabelFont(for: .body, weight: .light)
            textField.keyboardType = .default
            textField.returnKeyType = .go
        }
        
        let saveAction = (UIAlertAction(title: "Save", style: .default) { action in
            
            
            if let textField = alertController.textFields?.first,
               let text = textField.text,
               !text.isEmpty {
                handler(text)
            }
        })
        alertController.addAction(saveAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        let titleFont = UIFont.textLabelFont(size: 20,for: .title1, weight: .semibold)
        let attributedTitle = NSAttributedString(string: alertTitle ?? "", attributes: [.font: titleFont])
        let messageFont = UIFont.textLabelFont(size: 14,for: .body,weight: .thin)
        let attributedMessage = NSAttributedString(string: message ?? "", attributes: [.font: messageFont])
        let imageSave = UIImage(systemName: "square.and.arrow.down.fill")
        
        
        saveAction.setValue(imageSave, forKey: "image")
        
        alertController.setValue(attributedTitle, forKey: "attributedTitle")
        alertController.setValue(attributedMessage, forKey: "attributedMessage")
        
        present(alertController,animated: true)
    }
}
