//
//  AuthenticationError.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation

enum AuthenticationError: LocalizedError, Equatable {
    case invalidEmail
    case invalidPhoneNumber
    case weakPassword
    case emailAlreadyInUse
    case userNotFound
    case wrongPassword
    case networkError
    case tooManyRequests
    case operationNotAllowed
    case unknownError(String)
    case invalidDisplayName
    case userDisabled
    case requiresRecentLogin
    case providerAlreadyLinked
    case noSuchProvider
    case accountExistsWithDifferentCredential(AuthProvider)
    case invalidVerificationCode
    case invalidVerificationID
    case quotaExceeded
    case missingAppCredential
    case socialSignInCancelled
    case socialSignInFailed(String)
    case phoneAuthMissingOrInvalid
    case userNotAuthenticated
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .invalidPhoneNumber:
            return "Please enter a valid phone number."
        case .weakPassword:
            return "Password must be at least 8 characters with uppercase, lowercase, and numbers."
        case .emailAlreadyInUse:
            return "An account with this email already exists."
        case .userNotFound:
            return "No account found with this email address."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .networkError:
            return "Network error. Please check your connection."
        case .tooManyRequests:
            return "Too many failed attempts. Please try again later."
        case .operationNotAllowed:
            return "This operation is not allowed. Please contact support."
        case .invalidDisplayName:
            return "Please enter a valid name."
        case .userDisabled:
            return "This account has been disabled."
        case .requiresRecentLogin:
            return "Please sign in again to continue."
        case .providerAlreadyLinked:
            return "This account is already linked to another provider."
        case .noSuchProvider:
            return "This provider is not linked to your account."
        case .accountExistsWithDifferentCredential(let provider):
            return "An account already exists with this email using \(provider.displayName)."
        case .invalidVerificationCode:
            return "The verification code is invalid."
        case .invalidVerificationID:
            return "The verification ID is invalid."
        case .quotaExceeded:
            return "SMS quota exceeded. Please try again later."
        case .missingAppCredential:
            return "Missing app credential. Please contact support."
        case .socialSignInCancelled:
            return "Sign in was cancelled."
        case .socialSignInFailed(let message):
            return "Sign in failed: \(message)"
        case .phoneAuthMissingOrInvalid:
            return "Phone authentication missing or invalid."
        case .unknownError(let message):
            return message.isEmpty ? "An unexpected error occurred." : message
        case .userNotAuthenticated:
            return "User is not authenticated"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .weakPassword:
            return "Use at least 8 characters with uppercase, lowercase letters, and numbers."
        case .emailAlreadyInUse:
            return "Try signing in instead, or use password reset if you forgot your password."
        case .accountExistsWithDifferentCredential(let provider):
            return "Try signing in with \(provider.displayName) instead."
        case .networkError:
            return "Check your internet connection and try again."
        case .tooManyRequests:
            return "Wait a few minutes before attempting again."
        default:
            return nil
        }
    }
}
