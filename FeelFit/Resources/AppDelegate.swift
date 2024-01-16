//
//  AppDelegate.swift
//  FeelFit
//
//  Created by Константин Малков on 18.09.2023.
//

import UIKit
import UserNotifications
import RealmSwift
import BackgroundTasks

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let taskId = "Malkov.KS.FeelFit.backgroundTask"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        //register handler for task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { [weak self] task in
            
            //handler the task
            guard let task = task as? BGAppRefreshTask else { return }
            self?.handlerAppRefreshTask(task: task)
            self?.handleTask(task: task)
        }
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        print("Задание выполнилось количество раз >>> \(count) <<<")
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let vc = FFHealthViewController()
        vc.scheduleAppRefresh()
    }
    private func handlerAppRefreshTask(task: BGAppRefreshTask){
        let timer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
            let vc = FFHealthViewController()
            vc.updateData()
        }
        RunLoop.current.add(timer, forMode: .default)
        
        task.expirationHandler = {
            timer.invalidate()
        }
        task.setTaskCompleted(success: true)
    }
    
    
    
    private func handleTask(task: BGAppRefreshTask) {
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        UserDefaults.standard.set(count+1, forKey: "task_run_count")
        print("Задание выполнилось количество раз >>> \(count) <<<")
        task.expirationHandler = {
            //cancel network call
        }
        task.setTaskCompleted(success: true)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.badge)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        guard let object = getRealmModel(identifier) else {
            print("error getting object")
            return
        }
        guard let rootVC = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
            print("Error getting rootVC")
            return
        }
        let vc = FFTRainingPlanViewController()
        if let tabbar = rootVC as? FFTabBarController,
           let nav = tabbar.selectedViewController as? FFNavigationController {
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                vc.openPlanDetail(object)
            }
            
            nav.modalPresentationStyle = .fullScreen
            nav.present(vc, animated: true)
            
        } else {
            print("Error getting tab bar or nav bar")
        }
        
        completionHandler()
        
    }
    
    func getRealmModel(_ identifier: String) -> FFTrainingPlanRealmModel? {
        let realm = try! Realm()
        let object = realm.objects(FFTrainingPlanRealmModel.self).filter("trainingUniqueID == %@",identifier)
        return object.first
    }
}

