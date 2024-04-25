//
//  AppDelegate.swift
//  FeelFit
//
//  Created by Константин Малков on 18.09.2023.
//

import UIKit
import UserNotifications
import HealthKit
import RealmSwift
import BackgroundTasks
import TipKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let healthDataLoading = FFHealthDataManager.shared
    private let calendar = Calendar.current
    private let taskId = "Malkov.KS.FeelFit.fitApp.refresh"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        registerBackgroundTask()
        scheduleAppRefresh()
        registerTipsConfigure()
        return true
    }
    
    
    
    
    /// Function register tip kit in app
    private func registerTipsConfigure(){
        try? Tips.resetDatastore()
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
    }
    
    /// Function register Background Tasks for collecting users steps
    private func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
            self.refreshData()
            task.setTaskCompleted(success: true)
        }
    }
    
    private func scheduleAppRefresh(){
        let request = BGProcessingTaskRequest(identifier: taskId)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh : \(error.localizedDescription)")
        }
    }
    
    func refreshData(){
        
//        let vm = FFFavouriteUserCategoriesViewModel(viewController: UIViewController())
//        vm.refreshView()
        print("data is refreshing")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.badge)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        guard let object = getRealmModel(identifier) else {
            return
        }
        guard let rootVC = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
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
            
        }        
        completionHandler()
        
    }
    
    func getRealmModel(_ identifier: String) -> FFTrainingPlanRealmModel? {
        let realm = try! Realm()
        let object = realm.objects(FFTrainingPlanRealmModel.self).filter("trainingUniqueID == %@",identifier)
        return object.first
    }
}

