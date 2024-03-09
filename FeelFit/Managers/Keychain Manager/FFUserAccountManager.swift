//
//  FFUserAccountManager.swift
//  FeelFit
//
//  Created by Константин Малков on 06.03.2024.
//

import Foundation
import AuthenticationServices
import Security

struct CredentialUser {
    let email: String
    let password: String
}



extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noPassword:
            return "Enter the password"
        case .noEmail:
            return "Enter the email"
        case .unexpectedPasswordData:
            return "Incorrect password. Please enter correct or try to reset password."
        case .incorrectEmailOrPassword:
            return "This account is not created or you input incorrect email or password. Please try again."
        case .incorrectOrEmptyEmail:
            return "Please enter correct login."
        case .incorrectOrEmptyPassword:
            return "Please enter correct password."
        case .emptyItem:
            return "Can't check inputs data. Try again later."
        case .unhandledError(let status):
            if let errorMessage = SecCopyErrorMessageString(status, nil){
                return errorMessage as String
            } else {
                return "Unhandled error \(status.description)"
            }
            
        }
    }
}

class FFUserAccountManager {
    static let shared = FFUserAccountManager()
    
    
    
    func save(userData: CredentialUser) throws {
        let email = userData.email
        let passwordText = userData.password
        guard !email.isEmpty else { throw KeychainError.noEmail }
        guard !passwordText.isEmpty else { throw KeychainError.noPassword}
        guard let password = passwordText.data(using: .utf8) else { throw KeychainError.unexpectedPasswordData }
        let query: [String:Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email,
            kSecValueData as String: password
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status)}
    }
    
    func read(userData: CredentialUser) throws -> CredentialUser {
        let enteredEmail = userData.email
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: enteredEmail,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.incorrectEmailOrPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status )}
        guard let existingItem = item as? [String: Any] else { throw KeychainError.emptyItem }
        guard let email = existingItem[kSecAttrAccount as String] as? String,
              !email.isEmpty
        else {
            throw KeychainError.incorrectOrEmptyEmail
        }
        
        guard let passwordData = existingItem[kSecValueData as String] as? Data,
              let password = String(data: passwordData, encoding: .utf8),
              !password.isEmpty
        else {
            throw KeychainError.incorrectOrEmptyPassword
        }
        return CredentialUser(email: email, password: password)
    }
    
    func edit(){
        
    }
    
    func delete(){
        
    }
}
