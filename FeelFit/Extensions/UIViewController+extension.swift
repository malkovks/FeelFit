//
//  UIViewController+extension.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

enum BarButtonPosition {
    case left
    case right
}

extension UIViewController {
    func addNavigationBarButton(title: String?,imageName: String,action: Selector?,menu: UIMenu?) -> UIBarButtonItem {
        let image = UIImage(systemName: imageName)
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 14
        button.backgroundColor = .systemBackground
        button.showsMenuAsPrimaryAction = true
        button.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(30)
            
        }
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
            return UIBarButtonItem(customView: button)
        } else {
            button.menu = menu
            return UIBarButtonItem(customView: button)
            
        }
    }
}
