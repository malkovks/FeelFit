//
//  FFTrainingPlanViewModel.swift
//  FeelFit
//
//  Created by Константин Малков on 13.11.2023.
//

import UIKit
import RealmSwift

protocol TrainingPlanProtocol: AnyObject {
    func configurationUnavailableView(action: @escaping  () -> ()) -> UIContentUnavailableConfiguration
}

class FFTrainingPlanViewModel: TrainingPlanProtocol {
    
    private let realm = try! Realm()
    
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
    
    func startLoadingPlans(_ keyPath: String) -> [FFTrainingPlanRealmModel] {
        let sortingTypeValue = UserDefaults.standard.bool(forKey: "planSortValueType")
        let trainingPlans = realm.objects(FFTrainingPlanRealmModel.self).filter("trainingCompleteStatus == %@",false).sorted(byKeyPath: keyPath ,ascending: sortingTypeValue)
        
        return Array(trainingPlans)
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath,_ trainingPlans: [FFTrainingPlanRealmModel]) {
        let data = trainingPlans[indexPath.row]
        openSelectedPlan(data)
    }
    
    func openSelectedPlan(_ model: FFTrainingPlanRealmModel){
        let vc = FFPlanDetailsViewController(data: model)
        let nav = FFNavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.isNavigationBarHidden = false
        viewController.present(nav, animated: true)
    }
    
    
    
}
