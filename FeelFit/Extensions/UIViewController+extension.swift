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
    func addNavigationBarButton(at position: BarButtonPosition,title: String?,imageName: String,action: Selector?,menu: UIMenu?){
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
            switch position {
                
            case .left:
                button.addTarget(self, action: action, for: .touchUpInside)
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            case .right:
                button.addTarget(self, action: action, for: .touchUpInside)
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
            }
        } else {
            switch position {
                
            case .left:
                button.menu = menu
                navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
            case .right:
                button.menu = menu
                navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
            }
        }
        
    }
}
