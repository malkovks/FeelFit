//
//  FFPlanCompletedTrainingViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 05.01.2024.
//

import UIKit

class FFPlanCompletedTrainingViewModel {
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func configUnavailableView() -> UIContentUnavailableConfiguration {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No completed workouts"
        config.image = UIImage(systemName: "figure.highintensity.intervaltraining")
        return config
        
    }
}
