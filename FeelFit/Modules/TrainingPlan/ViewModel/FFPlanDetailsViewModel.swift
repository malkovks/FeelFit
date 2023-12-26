//
//  FFPlanDetailsViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 15.12.2023.
//

import UIKit
import RealmSwift

class FFPlanDetailsViewModel {
    let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func didTapEditTraining(_ data: FFTrainingPlanRealmModel) {
        let trainPlan = CreateTrainProgram(name: data.trainingName,
                                           note: data.trainingNotes,
                                           type: data.trainingType,
                                           location: data.trainingType,
                                           date: data.trainingDate,
                                           notificationStatus: data.trainingNotificationStatus)
        let exercises = data.trainingExercises
        let vc = FFCreateTrainProgramViewController(isViewEditing: true, trainPlanData: trainPlan,exercises, trainPlanRealmModel: data)
        
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1, 6:
            return UITableView.automaticDimension
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
