//
//  UIContentUnavailableConfiguration+Extension.swift
//  FeelFit
//
//  Created by Константин Малков on 29.03.2024.
//

import UIKit

extension UIContentUnavailableConfiguration {
    
    static func error(mainText text: String = "Error loading data", message secondaryText: String = "Refresh the page or try again later.", action: (()-> Void)? = nil ) -> UIContentUnavailableConfiguration {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = text
        config.textProperties.color = .main
        config.textProperties.font = UIFont.headerFont(size: 24,for: .largeTitle)
        config.secondaryText = secondaryText
        config.secondaryTextProperties.color = .customBlack
        config.secondaryTextProperties.font = UIFont.textLabelFont(size: 16, for: .body, weight: .thin)
        config.button.image = UIImage(systemName: "arrow.clockwise.square")
        config.button.imagePlacement = .leading
        config.button.title = "Refresh"
        config.button.imagePadding = 5
        config.button.baseBackgroundColor = .main
        config.button.baseForegroundColor = .customBlack
        guard let action = action else { return config }
        config.buttonProperties.primaryAction = UIAction(handler: { _ in
            action()
        })
        return config
    }
}
