//
//  UIButton+Extension.swift
//  FeelFit
//
//  Created by Константин Малков on 13.03.2024.
//

import UIKit



extension UIButton {
    static func setupCustomFont(size: CGFloat = 16, textStyle: UIFont.TextStyle = .body, weight: UIFont.Weight = .regular, width: UIFont.Width = .standard) -> UIConfigurationTextAttributesTransformer {
        return UIConfigurationTextAttributesTransformer { container in
            var outgoing = container
            outgoing.font = UIFont.textLabelFont(size: size, for: textStyle, weight: weight, width: width)
            return outgoing
        }
    }
}
