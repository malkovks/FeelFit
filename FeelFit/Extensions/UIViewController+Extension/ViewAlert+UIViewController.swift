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
    func viewAlertController(text: String?,startDuration startTime: Double = 0.5,timer endTime: Double = 4,controllerView: UIView){
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .up
        let swipeButton = UIButton(type: .custom)
        swipeButton.configuration = .tinted()
        swipeButton.configuration?.baseBackgroundColor = .darkGray
        swipeButton.addGestureRecognizer(swipeGesture)
        
        let customView = UIView()
        customView.backgroundColor = FFResources.Colors.tabBarBackgroundColor
        customView.layer.cornerRadius = 12
        customView.addGestureRecognizer(swipeGesture)
        controllerView.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.top.equalTo(controllerView.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.greaterThanOrEqualToSuperview().multipliedBy(0.05)
            make.height.lessThanOrEqualToSuperview().multipliedBy(0.3)
        }
        customView.addSubview(swipeButton)
        swipeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(55)
            make.height.equalTo(5)
            make.bottom.equalToSuperview().offset(-2)
        }
        
        let label = UILabel()
        label.font = UIFont.textLabelFont(size: 12,for: .largeTitle)
        label.text = text
        label.numberOfLines = 0
        label.textColor = FFResources.Colors.activeColor
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        customView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().inset(20)
            make.height.lessThanOrEqualToSuperview().offset(-15)
        }
        
        UIView.animate(withDuration: startTime) {
            label.alpha = 1.0
            customView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+endTime) {
            UIView.animate(withDuration: 0.5,delay: 0) {
                customView.alpha = 0.0
                customView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            } completion: { _ in
                customView.removeFromSuperview()
            }
        }
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer){
        guard let customView = gesture.view else { return }
        UIView.animate(withDuration: 0.5) {
            customView.alpha = 0.0
            customView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            customView.removeFromSuperview()
        }
    }
}
