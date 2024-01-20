//
//  SceneDelegate.swift
//  FeelFit
//
//  Created by Константин Малков on 18.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let rootViewController = FFTabBarController()
        window.rootViewController = rootViewController
        self.window = window
        
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        let application = UIApplication.shared
        application.shortcutItems = [
            UIApplicationShortcutItem(type: "NewsModule",
                                      localizedTitle: "News",
                                      localizedSubtitle: "Open News window",
                                      icon: UIApplicationShortcutIcon(systemImageName: "newspaper")),
            UIApplicationShortcutItem(type: "MusclesModule",
                                      localizedTitle: "Muscles",
                                      localizedSubtitle: "Open Muscles window",
                                      icon: UIApplicationShortcutIcon(systemImageName: "figure.strengthtraining.traditional")),
            UIApplicationShortcutItem(type: "TrainingPlanModule",
                                      localizedTitle: "Plan",
                                      localizedSubtitle: "Open Plan window",
                                      icon: UIApplicationShortcutIcon(systemImageName: "checkmark.diamond")),
            UIApplicationShortcutItem(type: "HealthModule",
                                      localizedTitle: "Health",
                                      localizedSubtitle: "Open Health window",
                                      icon: UIApplicationShortcutIcon(systemImageName: "heart.text.square"))
            
        ]
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

