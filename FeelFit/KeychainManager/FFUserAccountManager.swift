//
//  FFUserAccountManager.swift
//  FeelFit
//
//  Created by Константин Малков on 06.03.2024.
//

import Foundation
import AuthenticationServices

struct CredentialUser {
    let user: String
    let password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

class FFUserAccountManager {
    static let shared = FFUserAccountManager()
    
    
    
    func save(){
        
    }
    
    func read(){
        
    }
    
    func edit(){
        
    }
    
    func delete(){
        
    }
}
