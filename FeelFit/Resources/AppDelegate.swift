//
//  AppDelegate.swift
//  FeelFit
//
//  Created by Константин Малков on 18.09.2023.
//

import UIKit
import UserNotifications
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.list)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        guard let object = getRealmModel(identifier) else {
            print("Error getting model from realm")
            return
        }
        guard let tabBarController = UIApplication.shared.delegate?.window??.rootViewController as? FFTabBarController else { return }
        tabBarController.selectedIndex = 2
        let navVC = tabBarController.selectedViewController as? FFNavigationController
        let rootVC = FFTRainingPlanViewController()
        rootVC.didTapCreateProgram()
        let vc = UINavigationController(rootViewController: rootVC)
        navVC?.pushViewController(vc, animated: true)
//        let vc = FFProfileViewController()
        
//        
//        if let tabBar = window?.rootViewController as? FFTabBarController,
//           let navCon = tabBar.selectedViewController as? FFNavigationController {
//            
//            navCon.pushViewController(vc, animated: true)
//        } else {
//            print("Error")
//        }
        
        completionHandler()
        
    }
    
    func getRealmModel(_ identifier: String) -> FFTrainingPlanRealmModel? {
        let realm = try! Realm()
        let object = realm.objects(FFTrainingPlanRealmModel.self).filter("trainingUniqueID == %@",identifier)
        return object.first
    }
    
    
}

