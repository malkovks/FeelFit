//
//  AlertInfo+UIViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 26.10.2023.
//

import UIKit
import SnapKit

extension UIViewController {
    /// Function necessary for displaying custom alert
    /// - Parameters:
    ///   - text: custom text variations
    ///   - duration: time duration of presenting alert
    ///   - controllerView: view of UIViewController where this alert will presented
    func viewAlertController(text: String,startDuration startTime: Double,timer endTime: Double,controllerView: UIView){
        let customView = UIView()
        customView.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        customView.layer.cornerRadius = 12
        self.view.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.top.equalTo(controllerView.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.size.width/2)
            make.height.equalTo(view.frame.size.height/18)
            
        }
        
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium, width: .standard)
        label.text = text
        label.numberOfLines = 0
        label.textColor = FFResources.Colors.activeColor
        label.textAlignment = .center
        customView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(customView.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(2)
            make.bottom.equalTo(customView.safeAreaLayoutGuide.snp.bottom)
        }
        
        UIView.animate(withDuration: startTime) {
            label.alpha = 1.0
            customView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+endTime) {
            UIView.animate(withDuration: 0.5,delay: 0) {
                customView.alpha = 0.0
                customView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } completion: { success in
                customView.removeFromSuperview()
            }
        }
    }
}
