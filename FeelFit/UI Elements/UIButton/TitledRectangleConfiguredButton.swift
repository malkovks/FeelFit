//
//  TitledRectangleConfiguredButton.swift
//  FeelFit
//
//  Created by Константин Малков on 02.03.2024.
//

import UIKit

class CustomConfigurationButton: UIButton  {
    
    convenience init(primaryAction action: UIAction? = nil,
                     configurationTitle: String? = nil,
                     configurationImage image: UIImage? = nil,
                     configurationImagePlacement placement: NSDirectionalRectEdge? = .trailing
    ) {
        self.init()
        
        self.configuration?.title = configurationTitle
        self.configuration?.image = image
        self.configuration?.imagePlacement = placement ?? .all
        guard let action = action else { return }
        self.addAction(action, for: .primaryActionTriggered)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configuration = .filled()
        self.configuration?.baseForegroundColor = FFResources.Colors.customBlack
        self.configuration?.baseBackgroundColor = .clear
        self.configuration?.cornerStyle = .small
        self.configuration?.background.strokeWidth = 0.5
        self.configuration?.background.strokeColor = FFResources.Colors.customBlack
        
        self.configuration?.titleAlignment = .center
        self.contentMode = .center
        self.isHidden = false
        self.configuration?.image = UIImage(systemName: "lock")
        self.configuration?.imagePlacement = .trailing
        self.configuration?.imagePadding = 2
        self.contentVerticalAlignment = .fill
        self.contentHorizontalAlignment = .fill
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
