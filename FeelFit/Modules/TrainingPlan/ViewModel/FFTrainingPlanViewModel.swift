//
//  FFTrainingPlanViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 13.11.2023.
//

import UIKit

protocol TrainingPlanProtocol: AnyObject {
    func configurationUnavailableView(action: @escaping  () -> ()) -> UIContentUnavailableConfiguration
}

class FFTrainingPlanViewModel: TrainingPlanProtocol {
    
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func configurationUnavailableView(action: @escaping () -> ()) -> UIContentUnavailableConfiguration {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No planned trainings"
        config.secondaryText = "Add new training plan to list"
        config.image = UIImage(systemName: "rectangle")
        config.button = .tinted()
        config.button.image = UIImage(systemName: "plus.rectangle")
        config.button.title = "Add new training plan"
        config.button.imagePlacement = .top
        config.button.imagePadding = 2
        config.button.baseBackgroundColor = FFResources.Colors.activeColor
        config.button.baseForegroundColor = FFResources.Colors.activeColor
        config.buttonProperties.primaryAction = UIAction(handler: { _ in
            action()
        })
        return config
    }
    
    func setupMockTest() -> [TrainingPlan] {
        var trainingPlans = [TrainingPlan]()
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
        trainingPlans.append(TrainingPlan(firstName: "Run", secondName: "Interval", detailTraining: "Running with bycicle by pulse ", plannedDate: Date(), durationMinutes: 60, location: "Outside", exercises: [Exercise(bodyPart: "Legs", equipment: "shoes", imageLink: "someLink", exerciseID: "01", exerciseName: "100x10", muscle: "quads,calves", secondaryMuscles: ["some secondary"], instructions: ["Some text"])]))
        return trainingPlans
    }
    
    
}
