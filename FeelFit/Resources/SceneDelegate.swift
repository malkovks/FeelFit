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
        
        openViewController(windowScene)
        
        guard let shortcutItem = connectionOptions.shortcutItem else { return }
        handleShortcutItem(shortcutItem.type, windowScene)
    }

    func sceneWillResignActive(_ scene: UIScene) {
        let application = UIApplication.shared
        application.shortcutItems = [
            UIApplicationShortcutItem(type: "Malkov.KS.FeelFit.fitness.news",
                                      localizedTitle: "News",
                                      localizedSubtitle: "Open News window",
                                      icon: UIApplicationShortcutIcon(systemImageName: "newspaper")),
            UIApplicationShortcutItem(type: "Malkov.KS.FeelFit.fitness.muscles",
                                      localizedTitle: "Muscles",
                                      localizedSubtitle: "Open Muscles window",
                                      icon: UIApplicationShortcutIcon(systemImageName: "figure.strengthtraining.traditional")),
            UIApplicationShortcutItem(type: "Malkov.KS.FeelFit.fitness.muscles.plan",
                                      localizedTitle: "Plan",
                                      localizedSubtitle: "Open Plan window",
                                      icon: UIApplicationShortcutIcon(systemImageName: "checkmark.diamond")),
            UIApplicationShortcutItem(type: "Malkov.KS.FeelFit.fitness.health",
                                      localizedTitle: "Health",
                                      localizedSubtitle: "Open Health window",
                                      icon: UIApplicationShortcutIcon(systemImageName: "heart.text.square"))
            
        ]
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        openViewController(windowScene)
    }
    
    private func openViewController(_ windowScene: UIWindowScene){
        let tabBar = FFTabBarController()
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    private func handleShortcutItem(_ shortcutItemType: String,_ windowScene: UIWindowScene){
        switch shortcutItemType {
          
        case "Malkov.KS.FeelFit.fitness.news":
            UserDefaults.standard.set(0, forKey: "viewIndex")
        case "Malkov.KS.FeelFit.fitness.muscles":
            UserDefaults.standard.set(1, forKey: "viewIndex")
        case "Malkov.KS.FeelFit.fitness.plan":
            UserDefaults.standard.set(2, forKey: "viewIndex")
        case "Malkov.KS.FeelFit.fitness.health":
            UserDefaults.standard.set(3, forKey: "viewIndex")
        default:
            break
        }
        
        openViewController(windowScene)
    }


}

