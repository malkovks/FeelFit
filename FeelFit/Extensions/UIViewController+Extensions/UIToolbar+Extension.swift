//
//  UIToolbar+Extension.swift
//  FeelFit
//
//  Created by Константин Малков on 04.04.2024.
//

import UIKit

extension UIViewController {
    func setupToolBar(target: Any?) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        toolBar.sizeToFit()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: #selector(didTapDismissKeyboard))
        let items = [flexibleSpace,doneButtonItem]
        toolBar.setItems(items, animated: true)
        return toolBar
    }
    
    @objc private func didTapDismissKeyboard(){
        self.view.endEditing(true)
    }
}
