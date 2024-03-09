//
//  Keychain Error Handler.swift
//  FeelFit
//
//  Created by Константин Малков on 09.03.2024.
//

import UIKit

enum KeychainError: Error {
    case noPassword
    case noEmail
    case unexpectedPasswordData
    case incorrectEmailOrPassword
    case incorrectOrEmptyEmail
    case incorrectOrEmptyPassword
    case emptyItem
    case unhandledError(status: OSStatus)
}
