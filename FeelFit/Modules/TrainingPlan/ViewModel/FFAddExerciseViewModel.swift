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
    
    func didTapConfirmSaving(plan: CreateTrainProgram?,exercises: [Exercise],handler: @escaping (Bool) -> ()){
        viewController.alertControllerActionConfirm(title: "Warning", message: "Save created program?", confirmActionTitle: "Save", secondTitleAction: "Don't save", style: .actionSheet) { [ unowned self] in
            savePlanProgram(basic: plan, exercises: exercises) { status in
                handler(status)
            }
            viewController.navigationController?.popToRootViewController(animated: true)
        } secondAction: { [unowned self] in
            viewController.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func savePlanProgram(basic: CreateTrainProgram?,exercises: [Exercise],handler: @escaping (Bool) -> ()){
        guard let data = basic else { return }
        FFTrainingPlanStoreManager.shared.savePlan(plan: data, exercises: exercises) { status in
            handler(status)
        }
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
    
    //MARK: - TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }
}
