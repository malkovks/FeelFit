//
//  FFOnboardingManager.swift
//  FeelFit
//
//  Created by Константин Малков on 28.04.2024.
//

import UIKit

class FFOnboardingManager {
    
    static let shared = FFOnboardingManager()
    private let key = "isOnboardingLaunched"
    
    private init () {}
    
    func hasShownOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func setOnboardingShown() {
        UserDefaults.standard.setValue(true, forKey: key)
    }
    
}
