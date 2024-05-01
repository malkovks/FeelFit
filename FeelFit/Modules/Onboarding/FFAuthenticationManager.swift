//
//  FFAuthenticationManager.swift
//  FeelFit
//
//  Created by Константин Малков on 01.05.2024.
//

import UIKit

class FFAuthenticationManager {
    
    static let shared = FFAuthenticationManager()
    private let key: String = "userLoggedIn"
    
    private init () {}
    
    func didEnteredToAccount(){
        UserDefaults.standard.set(true, forKey: key)
    }
    
    func didExitFromAccount(){
        UserDefaults.standard.set(false, forKey: key)
    }
    
    func isUserEnteredInAccount() -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
}
