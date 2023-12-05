//
//  UIViewController+extension.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit
import Alamofire

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
    
    func addBackButtonItem(title: String,action: Selector?) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        
        button.layer.cornerRadius = 14
        button.backgroundColor = .secondarySystemBackground
        button.showsMenuAsPrimaryAction = true
        button.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        if let action = action {
            button.addTarget(self, action: action, for: .touchUpInside)
        }
        return button
        
    }
    
    
    /// Function for opening image in custom created view
    /// - Parameter url: link of image which will opening
    func showFullSizeImage(url: String){
        let vc = FFNewsImageView()
        vc.isOpened = { opened in
            if !opened {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.tabBarController?.tabBar.isHidden = false
            }
        }
        guard let url = URL(string: url) else { return }
        AF.request(url,method: .get).response { response in
            switch response.result {
            case .success(let imageData):
                let image = UIImage(data: imageData ?? Data(),scale: 1)
                vc.imageView.image = image
            case .failure(_):
                vc.imageView.image = UIImage(systemName: "photo")
            }
        }
        self.view.addSubview(vc)
        vc.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.tabBarController?.tabBar.isHidden = true
            vc.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
}
