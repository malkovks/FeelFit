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
        view.backgroundColor = UIColor(named: "tabBarBackgroundColor")
        navigationBar.isTranslucent = false
        navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "textColor") ?? UIColor.black,
                                                                .font: FFResources.Fonts.didotFont(size: UIFont.systemFontSize)]
        navigationBar.tintColor = FFResources.Colors.activeColor
    }
    
    static func checkOpensource(){
        
    }
    

}
