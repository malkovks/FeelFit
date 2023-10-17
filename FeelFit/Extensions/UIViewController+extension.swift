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
    
    /// Function for adding button in navigation controller with ready customization and full settings
    /// - Parameters:
    ///   - title: title of button (optional)
    ///   - imageName: image name in string value
    ///   - action: set action for button(optional)
    ///   - menu: set UIMenu for button (optional)
    /// - Returns: return customized UIBarButtonItem
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
    
    
    /// Function for opening image in custom created view
    /// - Parameter url: link of image which will opening
    func showFullSizeImage(url: String){
        let vc = FFNewsImageView()
        vc.isOpened = { opened in
            if !opened {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.tabBarController?.tabBar.isHidden = false
                //            self.view.alpha = 1.0
            }
        }
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                vc.imageView.image = image
            }
        }.resume()
        self.view.addSubview(vc)
        vc.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        UIView.animate(withDuration: 0.5) {
//            self.view.alpha = 0.8
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            self.tabBarController?.tabBar.isHidden = true
            vc.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
    
}
