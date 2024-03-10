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


class FFUserAccountManager {
    static let shared = FFUserAccountManager()
    
    
    
    func createNewUserAccount(userData: CredentialUser?) throws {
        guard let data = userData else {
            throw KeychainError.emptyModel
        }
        let email = data.email
        let passwordText = data.password
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
    
    func checkForCreatedUserAccount(userData: CredentialUser?) throws  {
        guard let data = userData else {
            throw KeychainError.emptyModel
        }
        
        let enteredEmail = data.email
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
    }
    
    func updateUserAccountData(userData: CredentialUser?) throws {
        guard let data = userData else {
            throw KeychainError.emptyModel
        }
        let email = data.email
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email
        ]
        
        let password = data.password
        guard !password.isEmpty
        else {
            throw KeychainError.incorrectOrEmptyPassword
        }
        
        let passwordData = password.data(using: String.Encoding.utf8)!
        
        let attribute: [String:Any] = [
            kSecAttrAccount as String: email,
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemUpdate(query as CFDictionary, attribute as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.incorrectEmailOrPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status )}
        
    }
    
    func deleteUserAccountData(userData: CredentialUser?) throws {
        guard let data = userData else {
            throw KeychainError.emptyModel
        }
        
        let email = data.email
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: email
        ]
    
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
        
    }
}
