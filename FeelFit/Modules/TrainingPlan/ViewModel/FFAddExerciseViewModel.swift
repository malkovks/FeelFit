//
//  FFAddExerciseViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 01.12.2023.
//

import UIKit


class FFAddExerciseViewModel {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func didTapConfirmSaving(plan: CreateTrainProgram?,model: [FFExerciseModelRealm]){
        viewController.alertControllerActionConfirm(title: "Warning", message: "Save created program?", confirmActionTitle: "Save", secondTitleAction: "Don't save", style: .actionSheet) { [ unowned self] in
            savePlanProgram(plan: plan,model)
            viewController.navigationController?.popToRootViewController(animated: true)
        } secondAction: { [unowned self] in
            viewController.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func savePlanProgram(plan basic: CreateTrainProgram?,_ model: [FFExerciseModelRealm]){
        guard let data = basic else { return }
        FFTrainingPlanStoreManager.shared.savePlanRealmModel(data, model)
    }
    
    func configureView(action: @escaping () -> ()) -> UIContentUnavailableConfiguration {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No exercises"
        config.image = UIImage(systemName: "figure.strengthtraining.traditional")
        config.button = .plain()
        config.button.image = UIImage(systemName: "plus")
        config.button.baseForegroundColor = FFResources.Colors.activeColor
        config.button.title = "Add exercise"
        config.button.imagePlacement = .leading
        config.button.imagePadding = 2
        config.buttonProperties.primaryAction = UIAction(handler: { _ in
            action()
        })
        return config
    }
    
    func addExercise(vc: UIViewController){
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func convertExerciseToRealm(exercises: [Exercise]) -> [FFExerciseModelRealm] {
        let object: [FFExerciseModelRealm] = exercises.map { data -> FFExerciseModelRealm in
            let model = FFExerciseModelRealm()
            model.exerciseID = data.exerciseID
            model.exerciseBodyPart = data.bodyPart
            model.exerciseEquipment = data.equipment
            model.exerciseImageLink = data.imageLink
            model.exerciseName = data.exerciseName
            model.exerciseMuscle = data.muscle
            model.exerciseSecondaryMuscles = data.secondaryMuscles.joined(separator: ", ")
            model.exerciseInstructions = data.instructions.joined(separator: ". ")
            return model
        }
        return object
    }
    
    func convertRealmModelToExercise(_ model: [FFExerciseModelRealm]) -> [Exercise]{
        let object: [Exercise] = model.map { data -> Exercise in
            let exercise = Exercise(
                bodyPart: data.exerciseBodyPart,
                equipment: data.exerciseEquipment,
                imageLink: data.exerciseImageLink,
                exerciseID: data.exerciseID,
                exerciseName: data.exerciseName,
                muscle: data.exerciseMuscle,
                secondaryMuscles: [data.exerciseSecondaryMuscles],
                instructions: [data.exerciseInstructions])
            return exercise
        }
        return object
    }
    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
}
