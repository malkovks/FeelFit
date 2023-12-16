//
//  FFFavouriteExerciseViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 19.11.2023.
//

import UIKit
import RealmSwift

class FFFavouriteExerciseViewModel {
    let viewController: FFFavouriteExercisesViewController
    
    init(viewController: FFFavouriteExercisesViewController) {
        self.viewController = viewController
    }
    
    func loadFavouriteExerciseData(){
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,sortedModel: [String: [FFFavouriteExerciseRealmModel]]) {
        tableView.deselectRow(at: indexPath, animated: true)
        let key = Array(sortedModel.keys.sorted())[indexPath.section]
        let values = sortedModel[key]
        let value = values![indexPath.row]
        let model = Exercise(bodyPart: value.exerciseBodyPart, equipment: value.exerciseEquipment, imageLink: value.exerciseImageLink, exerciseID: value.exerciseID, exerciseName: value.exerciseName, muscle: value.exerciseMuscle, secondaryMuscles: [value.exerciseSecondaryMuscles], instructions: [value.exerciseInstructions])
        let vc = FFExerciseDescriptionViewController(exercise: model, isElementsHidden: false)
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath, sortedModel: [String: [FFFavouriteExerciseRealmModel]]) -> UISwipeActionsConfiguration? {
        var sortedModel = sortedModel
        let key = Array(sortedModel.keys.sorted())[indexPath.section]
        let values = sortedModel[key]
        let value = values![indexPath.row]
        let deleteInstance = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            tableView.beginUpdates()
            FFFavouriteExerciseStoreManager.shared.clearExerciseWith(realmModel: value)
            sortedModel[key]?.remove(at: indexPath.row)
            if let updatedArray = sortedModel[key] {
                sortedModel[key] = updatedArray
            } else {
                sortedModel.removeValue(forKey: key)
            }

            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
        }
        deleteInstance.backgroundColor = UIColor.systemRed
        deleteInstance.image = UIImage(systemName: "trash.fill")?
            .withTintColor(.clear)
        return UISwipeActionsConfiguration(actions: [deleteInstance])
    }
}
