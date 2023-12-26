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
    
    func configView() -> UIContentUnavailableConfiguration {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No favourite exercises"
        config.secondaryText = "Add it by selecting muscles modules"
        config.image = UIImage(systemName: "heart.fill")
        config.image?.withTintColor(FFResources.Colors.activeColor)
        return config
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
}
