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
    
    weak var delegate: FFExerciseProtocol?
    
    func loadData(key: String, filter type: String){
        delegate?.viewWillLoadData()
        FFGetExercisesDataBase.shared.getMuscleDatabase(muscle: key,filter: type) { [weak self] result in
            switch result {
            case .success(let success):
                self?.delegate?.viewDidLoadData(result: .success(success))
            case .failure(let failure):
                self?.delegate?.viewDidLoadData(result: .failure(failure))
            }
        }
    }
}
