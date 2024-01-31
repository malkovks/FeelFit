//
//  FullSizeImagePresenter.swift
//  FeelFit
//
//  Created by Константин Малков on 16.12.2023.
//

import UIKit
import Alamofire

extension UIViewController {
    /// Function for opening image in custom created view
    /// - Parameter url: link of image which will opening
    func showFullSizeImage(url: String,image: UIImage = UIImage(systemName: "photo")!){
        let vc = FFNewsImageView()
        vc.isOpened = { opened in
            if !opened {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.tabBarController?.tabBar.isHidden = false
            }
        }
        if let url = URL(string: url) {
            AF.request(url,method: .get).response { response in
                switch response.result {
                case .success(let imageData):
                    let image = UIImage(data: imageData ?? Data(),scale: 1)
                    vc.imageView.image = image
                case .failure(_):
                    vc.imageView.image = UIImage(systemName: "photo")
                }
            }
        } else {
            vc.imageView.image = image
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
