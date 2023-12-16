//
//  FFTabBarController.swift
//  FeelFit
//
//  Created by Константин Малков on 20.09.2023.
//

import UIKit

final class FFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        setupControllerBar()
        configureTabBar()
        
    }
    
    private func configureTabBar(){
        tabBar.tintColor = FFResources.Colors.activeColor
        tabBar.barTintColor = .systemBackground
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.masksToBounds = true
        let height = tabBar.frame.size.height/2
        tabBar.frame.size.height = height
        tabBar.frame.origin.y = tabBar.frame.size.height - height
    }
    
    private func tabBarSetup(vc: UIViewController, title: String, image: String,tag: Int) -> UINavigationController {
        let image = UIImage(systemName: image)
        vc.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        let navigationController = FFNavigationController(rootViewController: vc)
        return navigationController
    }
    
    private func setupControllerBar(){
        let news = tabBarSetup(vc: FFNewsPageViewController(), title: "News", image: "newspaper",tag: FFTabBarIndex.news.rawValue)
        let exercises = tabBarSetup(vc: FFMusclesGroupViewController(), title: "Muscles", image: "figure.strengthtraining.traditional",tag: FFTabBarIndex.exercises.rawValue)
        let health = tabBarSetup(vc: FFHealthViewController(), title: "Health", image: "heart.text.square",tag: FFTabBarIndex.health.rawValue)
        let plan = tabBarSetup(vc: FFTRainingPlanViewController(), title: "Plan", image: "checkmark.diamond",tag: FFTabBarIndex.trainingPlan.rawValue)
        let profile = tabBarSetup(vc: FFProfileViewController(), title: "My Profile", image: "person.fill",tag: FFTabBarIndex.user.rawValue)
        setViewControllers([news, exercises, plan, health, profile], animated: true)
    }
}
