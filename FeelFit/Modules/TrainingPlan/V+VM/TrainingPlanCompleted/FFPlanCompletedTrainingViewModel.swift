//
//  FFPlanCompletedTrainingViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 05.01.2024.
//

import UIKit
import RealmSwift

class FFPlanCompletedTrainingViewModel {
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func loadRealmData() -> [FFTrainingPlanRealmModel]? {
        let realm = try! Realm()
        let objects = realm.objects(FFTrainingPlanRealmModel.self).filter("trainingCompleteStatus == %@", true)
        let data = Array(objects)
        return data
    }
    
    func configUnavailableView() -> UIContentUnavailableConfiguration {
        var config = UIContentUnavailableConfiguration.empty()
        config.text = "No completed workouts"
        config.image = UIImage(systemName: "figure.highintensity.intervaltraining")
        return config
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath,data: [FFTrainingPlanRealmModel]) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = FFPlanDetailsViewController(data: data[indexPath.row])
        let nav = FFNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.isNavigationBarHidden = false
        viewController.present(nav, animated: true)
    }
}
