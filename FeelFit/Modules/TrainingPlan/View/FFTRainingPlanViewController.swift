//
//  FFTRainingPlanViewController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

class FFTRainingPlanViewController: UIViewController,SetupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationController()
        
        
    }
    
    func setupView() {
        view.backgroundColor = .systemGray4
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No planned trainings"
        config.secondaryText = "Add new training plan to list"
        config.image = UIImage(systemName: "rectangle")
        config.button = .tinted()
        config.buttonProperties.role = .primary
        contentUnavailableConfiguration = config
    }
    
    func setupNavigationController() {
        title = "Plan"
    }
    

}
