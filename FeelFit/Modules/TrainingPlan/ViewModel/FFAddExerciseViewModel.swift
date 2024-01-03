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
    
    
    @objc func didTapSavePlan(){
        
    }
    
    func didTapEditPlan(_ trainProgram: CreateTrainProgram?,_ model: [FFExerciseModelRealm],_ fullModel: FFTrainingPlanRealmModel?){
        guard let train = trainProgram,
              let fullModel = fullModel else {
            return
        }
        FFTrainingPlanStoreManager.shared.editPlanRealmModel(
            train,
            model,
            fullModel)
        viewController.navigationController?.popToRootViewController(animated: true)
        viewController.dismiss(animated: true)
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,_ model: [FFExerciseModelRealm]) {
        let value = model[indexPath.row]
        viewController.setupExerciseSecondaryParameters() { data in
            value.exerciseWeight = data[0]
            value.exerciseApproach = data[1]
            value.exerciseRepeat = data[2]
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int,_ isViewEditing: Bool,editAction: Selector,saveAction: Selector) -> UIView? {
        let button = UIButton()
        button.configuration = .filled()
        button.configuration?.cornerStyle = .capsule
        button.configuration?.title = isViewEditing ? "Save edits" : "Save"
        button.configuration?.image = isViewEditing ? UIImage(systemName: "arrow.up.right.circle") : UIImage(systemName: "arrow.down.circle")
        button.configuration?.imagePlacement = .leading
        button.configuration?.imagePadding = 6
        button.configuration?.baseBackgroundColor = FFResources.Colors.activeColor
        button.configuration?.baseForegroundColor = FFResources.Colors.backgroundColor
        if isViewEditing {
            button.addTarget(viewController, action: editAction, for: .primaryActionTriggered)
        } else {
            button.addTarget(viewController, action: saveAction, for: .primaryActionTriggered)
        }
        button.frame = CGRect(x: 10, y: 0, width: tableView.frame.width-20, height: tableView.rowHeight)
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.rowHeight
    }
    
    //MARK: - UITableViewDragDelegate
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath,_ model: [FFExerciseModelRealm]) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = model[indexPath.row]
        return [dragItem]
    }
}
