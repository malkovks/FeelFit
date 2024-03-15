//
//  UILabel+Extension.swift
//  FeelFit
//
//  Created by Константин Малков on 15.03.2024.
//

import UIKit

extension UILabel {
    func setupLabelShadowColor(){
        self.shadowColor = .customBlack
        self.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    func setupLabelGradient(){
        let gradientColor = CAGradientLayer()
        gradientColor.colors = [UIColor.griRed.cgColor, UIColor.systemBlue.cgColor]
        self.layer.addSublayer(gradientColor)
        
    }
}
