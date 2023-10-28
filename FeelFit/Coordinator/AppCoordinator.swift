//
//  AppCoordinator.swift
//  FeelFit
//
//  Created by Константин Малков on 13.10.2023.
//

import UIKit
import SafariServices

class AppCoordinator: Coordinator {
    
    var tabbarController: FFTabBarController?
    
    var navigationController: FFNavigationController?
    
    func start() {
        newsPageVC()
        setupControllerBar()
    }
    
    func newsPageVC(){
        let vc = FFNewsPageViewController()
        vc.viewModel = FFNewsPageViewModel()
        vc.viewModel.coordinator = self
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func detailVC(model: Articles){
        let vc  = FFNewsPageDetailViewController(model: model)
        print("Check func")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func eventOccurredNewsModule(event: NewsEvent, model: Articles? = nil) {
        
        switch event {
        case .tableViewDidSelect:
            let vc = FFNewsPageDetailViewController(model: model!)
            navigationController?.pushViewController(vc, animated: true)
        case .openFavourite:
            let vc = FFNewsFavouriteViewController()
            
            navigationController?.pushViewController(vc, animated: true)
        case .openNewsSettings:
            let vc = FFNewsSetupRequestViewController()
            
            navigationController?.pushViewController(vc, animated: true)
        case .openURL:
            guard let link = model?.url,let url = URL(string: link) else { return }
            let vc = SFSafariViewController(url: url)
            navigationController?.present(vc, animated: true)
        }
    }
    
    private func tabBarSetup(vc: UIViewController, title: String, image: String,tag: Int) -> UINavigationController {
        let image = UIImage(systemName: image)
        vc.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        let navigationController = FFNavigationController(rootViewController: vc)
        return navigationController
    }
    
    private func setupControllerBar(){
        let news = tabBarSetup(vc: FFNewsPageViewController(), title: "News", image: "newspaper",tag: FFTabBarIndex.news.rawValue)
        let exercises = tabBarSetup(vc: FFExercisesViewController(), title: "Exercises", image: "figure.strengthtraining.traditional",tag: FFTabBarIndex.exercises.rawValue)
        let health = tabBarSetup(vc: FFHealthViewController(), title: "Health", image: "heart.text.square",tag: FFTabBarIndex.health.rawValue)
        let plan = tabBarSetup(vc: FFTRainingPlanViewController(), title: "Plan", image: "checkmark.diamond",tag: FFTabBarIndex.trainingPlan.rawValue)
        let profile = tabBarSetup(vc: FFProfileViewController(), title: "My Profile", image: "person.fill",tag: FFTabBarIndex.user.rawValue)
        tabbarController?.setViewControllers([news, exercises, plan, health, profile], animated: true)
    }
    
    
}
