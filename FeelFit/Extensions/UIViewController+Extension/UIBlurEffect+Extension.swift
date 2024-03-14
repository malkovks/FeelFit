//
//  UIBlurEffect+Extension.swift
//  FeelFit
//
//  Created by Константин Малков on 13.03.2024.
//

import UIKit

extension UIViewController {
    func setupBlurEffectBackgroundView(_ blurEffect: UIBlurEffect.Style? = .systemMaterial,_ style: UIVibrancyEffectStyle? = .fill) {
        let blurEffect = UIBlurEffect(style: blurEffect ?? UIBlurEffect.Style.systemChromeMaterial)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: style ?? .fill)
        let blurEffectView = UIVisualEffectView(effect: vibrancyEffect)
        blurEffectView.frame = self.view.bounds
        self.view.insertSubview(blurEffectView, at: 0)
    }
}
