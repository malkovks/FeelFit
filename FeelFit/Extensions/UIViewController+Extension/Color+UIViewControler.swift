//
//  Color+UIViewControler.swift
//  FeelFit
//
//  Created by Константин Малков on 10.02.2024.
//

import UIKit

extension UIViewController {
    func setGradientBackground(topColor: UIColor, bottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor.cgColor,bottom.cgColor]
        gradientLayer.locations = [0.0,1.0]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
