//
//  FFNavigationController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

final class FFNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure(){
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.titleTextAttributes = [.foregroundColor : FFResources.Colors.textColor, .font: FFResources.Fonts.futuraFont(size: 24)]
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
        
        self.navigationBar.isTranslucent = false
        
        
        navigationBar.tintColor = FFResources.Colors.activeColor
        navigationBar.barTintColor = FFResources.Colors.tabBarBackgroundColor
    }
    

}
