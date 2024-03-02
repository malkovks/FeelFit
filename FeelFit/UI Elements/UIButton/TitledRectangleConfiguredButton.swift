//
//  TitledRectangleConfiguredButton.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit

class CustomConfigurationButton: UIButton  {
    
    convenience init(primaryAction action: UIAction,
                     configurationTitle: String? = nil,
                     baseBackgroundColor color: UIColor,
                     baseForegroundColor textColor: UIColor) {
        self.init()
        
        self.configuration?.title = configurationTitle
        self.configuration?.baseForegroundColor = textColor
        self.configuration?.baseBackgroundColor = color
        self.addAction(action, for: .primaryActionTriggered)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuration = .filled()
        self.configuration?.titleAlignment = .center
        self.contentMode = .center
        self.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
