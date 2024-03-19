//
//  Keychain Error Handler.swift
//  FeelFit
//
//  Created by Константин Малков on 09.03.2024.
//

import Foundation

enum KeychainError: Error {
    case noPassword
    case noEmail
    case emptyModel
    case duplicateAccount
    case unexpectedPasswordData
    case incorrectEmailOrPassword
    case incorrectOrEmptyEmail
    case incorrectOrEmptyPassword
    case emptyItem
    case unavailableToDeleteAccount
    case unhandledError(status: OSStatus)
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .emptyModel:
            return "You did not enter email or password. Fill all the fields and try again"
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
        case .duplicateAccount:
            return "You are trying to create almost created account. Try another login"
        case .unavailableToDeleteAccount:
            return "Unavailable to delete this account. Try again later."
        case .unhandledError(let status):
            if let errorMessage = SecCopyErrorMessageString(status, nil){
                return errorMessage as String
            } else {
                return "Unhandled error \(status.description)"
            }
        }
    }
}
