//
//  NavigationItemButton.swift
//  FeelFit
//
//  Created by Константин Малков on 16.12.2023.
//

import UIKit

enum BarButtonPosition {
    case left
    case right
}

extension UIViewController {
    /// Function for adding button in navigation controller with ready customization and full settings
    /// - Parameters:
    ///   - title: title of button (optional)
    ///   - imageName: image name in string value
    ///   - action: set action for button(optional)
    ///   - menu: set UIMenu for button (optional)
    /// - Returns: return customized UIBarButtonItem
    func addNavigationBarButton(title: String,imageName: String,action: Selector?,menu: UIMenu?) -> UIBarButtonItem {
        let image = UIImage(systemName: imageName)
        let button = UIButton(type: .system)
        if title.isEmpty {
            button.setImage(image, for: .normal)
        } else {
            button.setTitle(title, for: .normal)
        }
        button.setTitle(title, for: .normal)
        
        button.layer.cornerRadius = 14
        button.backgroundColor = .secondarySystemBackground
        button.showsMenuAsPrimaryAction = true
        button.sizeToFit()
        button.snp.makeConstraints { make in
            make.width.equalTo(60)
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
