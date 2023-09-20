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
    func addNavigationBarButton(at position: BarButtonPosition,title: String?,imageName: String,action: Selector){
        let image = UIImage(systemName: imageName)
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 14
        button.backgroundColor = .systemBackground
        button.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(30)
            
        }
        
        switch position {
            
        case .left:
            button.addTarget(self, action: action, for: .touchUpInside)
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        case .right:
            button.addTarget(self, action: action, for: .touchUpInside)
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        }
    }
}
