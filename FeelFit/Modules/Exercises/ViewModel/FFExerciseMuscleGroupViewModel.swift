//
//  FFExerciseMuscleGroupViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 02.11.2023.
//

import UIKit
import RealmSwift

protocol FFExerciseProtocol: AnyObject {
    func viewWillLoadData()
    func viewDidLoadData(result: Result<[Exercise],Error>)
}

class FFExerciseMuscleGroupViewModel {
    
    private let realm = try! Realm()
    
    weak var delegate: FFExerciseProtocol?
    
    func loadData(name: String,filter: String = "exerciseMuscle"){
        delegate?.viewWillLoadData()
        FFGetExercisesDataBase.shared.getMuscleDatabase(muscle: name,filter: filter) { result in
            switch result {
            case .success(let data):
                FFExerciseStoreManager.shared.saveLoadData(model: data)
                self.delegate?.viewDidLoadData(result: .success(data))
            case .failure(let error):
                self.delegate?.viewDidLoadData(result: .failure(error))
            }
        }
    }

    func checkAvailableData(loadName: String){
        delegate?.viewWillLoadData()
        let formattedKey = loadName.replacingOccurrences(of: "%20", with: " ")
        let value = FFExerciseStoreManager.shared.loadMusclesData(formattedKey)
        if value.count > 0 {
            self.delegate?.viewDidLoadData(result: .success(value))
        } else if value.count == 0 {
            loadData(name: loadName)
        } else {
            let error = NSError()
            self.delegate?.viewDidLoadData(result: .failure(error))
        }
    }
    
    func didSelectRowAt(_ tableView: UITableView, indexPath: IndexPath,viewController: UIViewController,model: [Exercise]) {
        tableView.deselectRow(at: indexPath, animated: true)
        let exercise = model[indexPath.row]
        let vc = FFExerciseDescriptionViewController(exercise: exercise)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
