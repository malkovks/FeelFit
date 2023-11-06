//
//  FFExerciseMuscleGroupViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 02.11.2023.
//

import UIKit

protocol FFExerciseProtocol: AnyObject {
    func viewWillLoadData()
    func viewDidLoadData(result: Result<[Exercises],Error>)
}

class FFExerciseMuscleGroupViewModel {
    
    weak var delegate: FFExerciseProtocol?
    
    func loadData(name: String){
        delegate?.viewWillLoadData()
        FFGetExerciseRequest.shared.getRequest(searchValue: name, searchType: .muscle) { result in
            switch result {
            case .success(let success):
                self.delegate?.viewDidLoadData(result: .success(success))
            case .failure(let failure):
                self.delegate?.viewDidLoadData(result: .failure(failure))
            }
        }
    }

    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath,viewController: UIViewController,model: [[Exercises]]) {
        tableView.deselectRow(at: indexPath, animated: true)
        let exercise = model[indexPath.section][indexPath.row]
        let vc = FFExerciseDescriptionViewController(exercise: exercise)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
