//
//  UIImageView+Extensions.swift
//  FeelFit
//
//  Created by Константин Малков on 20.02.2024.
//

import UIKit

extension UIImageView {
    func setupShadowLayer(){
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = FFResources.Colors.textColor.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 4
    }
}
