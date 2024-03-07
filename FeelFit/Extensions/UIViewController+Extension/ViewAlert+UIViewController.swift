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
    func viewAlertController(text: String?,startDuration startTime: Double,timer endTime: Double,controllerView: UIView){
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
        self.view.addSubview(customView)
        customView.snp.makeConstraints { make in
            make.top.equalTo(controllerView.safeAreaLayoutGuide.snp.top).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        customView.addSubview(swipeButton)
        swipeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.bottom.equalToSuperview().offset(-5)
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
            } completion: { _ in
                customView.removeFromSuperview()
            }
        }
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer){
        guard let customView = gesture.view else { return }
        UIView.animate(withDuration: 0.0) {
            customView.alpha = 0.0
            customView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        } completion: { _ in
            customView.removeFromSuperview()
        }
    }
}
