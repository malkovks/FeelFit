//
//  FFExerciseMuscleGroupViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 02.11.2023.
//

import UIKit

protocol FFExerciseProtocol: AnyObject {
    func viewWillLoadData()
    func viewDidLoadData(result: Result<[Exercise],Error>)
}

class FFExerciseMuscleGroupViewModel {
    
    weak var delegate: FFExerciseProtocol?
    
    func loadData(name: String){
        delegate?.viewWillLoadData()
        FFGetExercisesDataBase.shared.getMuscleDatabase(muscle: name) { result in
            switch result {
                
            case .success(let data):
                self.delegate?.viewDidLoadData(result: .success(data))
            case .failure(let error):
                self.delegate?.viewDidLoadData(result: .failure(error))
            }
        }
    }

    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath,viewController: UIViewController,model: [Exercise]) {
        tableView.deselectRow(at: indexPath, animated: true)
        let exercise = model[indexPath.row]
        let vc = FFExerciseDescriptionViewController(exercise: exercise)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
