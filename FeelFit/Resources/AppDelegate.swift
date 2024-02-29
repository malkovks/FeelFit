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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let healthDataLoading = FFHealthDataLoading.shared
    private let calendar = Calendar.current
    private let taskId = "Malkov.KS.FeelFit.fitnessApp.fetch"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
//        convertResult { model in
//            guard let model = model else { return }
//            let stepcount: Int = Int(model.last!.value)
//        }
        
        //register handler for task
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskId, using: nil) { task in
            //handle the task when its run
            guard let task = task as? BGProcessingTask else { return }
            self.handleTask(task: task,taskID: self.taskId)
        }
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        print("Task ran \(count) times")
        
        //submit a task to be scheduled
        scheduleBackgroundTask(taskID: taskId)
//        schedule(taskID: taskId)
        return true
    }
    //MARK: - Guideline from GTP
    private func handleTask(task: BGProcessingTask,taskID: String) {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        let operation = BlockOperation {
            //call func every 60 sec
            self.scheduleBackgroundTask(taskID: taskID)
        }
        
        task.expirationHandler = {
            queue.cancelAllOperations()
        }
        
        task.setTaskCompleted(success: true)
        scheduleBackgroundTask(taskID: taskID)
        let count = UserDefaults.standard.integer(forKey: "task_run_count")
        UserDefaults.standard.set(count+1, forKey: "task_run_count")
    }
    
    private func scheduleBackgroundTask(taskID: String){
        let request = BGProcessingTaskRequest(identifier: taskID)
        request.requiresNetworkConnectivity = false
        request.requiresExternalPower = false
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Work correct in background")
        } catch {
            print("Error schedule data from background task. \n\(error.localizedDescription)")
        }
    }
    
    //MARK: - Guideline from Apple
    private func handleAppRefresh(task: BGAppRefreshTask){
        schedule(taskID: taskId)
        //доделать
    }
    
    private func schedule(taskID: String) {
        let request = BGAppRefreshTaskRequest(identifier: taskID)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 61)
            do {
                try BGTaskScheduler.shared.submit(request)
                print("schedule work correct in background ")
            } catch {
                //ignore
                print("Error submiting schedule")
            }
    }
    
    
    
    private func convertResult(completion: @escaping (_ model: [FFUserHealthDataProvider]?) -> ()){
        let intervalDateComponents = DateComponents(day: 1)
        let interval: Int = -1
        let startDate = calendar.startOfDay(for: Date())
        healthDataLoading.performQuery(identifications: [.stepCount], value: intervalDateComponents, interval: interval, selectedOptions: .cumulativeSum, startDate: startDate, completion: completion)
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

