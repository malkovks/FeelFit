//
//  FFPlanExercisesViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 04.12.2023.
//

import UIKit

enum FFTrainingPlanType: String {
    case muscle = "muscle"
    case bodyPart = "bodyPart"
}

class FFPlanExercisesViewModel {
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func checkDataAvailable(key: String,type request: FFTrainingPlanType ){
        
    }
}
