//
//  AuthService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation
import FirebaseAuth
import Combine
import AuthenticationServices

final class AuthService: AuthenticationServiceProtocol {
    static let shared = AuthService()
    
    private let auth = Auth.auth()
    private let authStateSubject = CurrentValueSubject<AuthUser?, Never>(nil)
    
    var currentUser: AuthUser? {
        guard let user = auth.currentUser else { return nil }
        return AuthUser(from: user)
    }
    
    var authStatePublisher: AnyPublisher<AuthUser?, Never> {
        authStateSubject.eraseToAnyPublisher()
    }
    
    private init() {
        auth.addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            self.authStateSubject.send(user != nil ? AuthUser(from: user!) : nil)
        }
    }

    // MARK: - Email & Password
    
    func createUser(with registration: UserRegistrationModel) async throws -> AuthUser {
        let result = try await auth.createUser(withEmail: registration.email, password: registration.password)
        try await result.user.sendEmailVerification()
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = registration.fullName
        try await changeRequest.commitChanges()
        return AuthUser(from: result.user)
    }
    
    func signIn(email: String, password: String) async throws -> AuthUser {
        let result = try await auth.signIn(withEmail: email, password: password)
        return AuthUser(from: result.user)
    }
    
    func sendPasswordReset(email: String) async throws {
        try await auth.sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Social Authentication
    
    func signInWithGoogle() async throws -> AuthUser {
        throw NSError(domain: "Wellish", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Google sign-in not implemented yet"])
    }

    // Not used: Facebook

    func signInWithApple(_ authorization: ASAuthorization) async throws -> AuthUser {
        throw NSError(domain: "Wellish", code: 1003, userInfo: [NSLocalizedDescriptionKey: "Apple sign-in not implemented yet"])
    }

    // MARK: - Phone Authentication
    
    /*
    func sendPhoneVerification(phoneNumber: String) async throws -> String {
        throw NSError(domain: "Wellish", code: 1004, userInfo: [NSLocalizedDescriptionKey: "Phone verification not implemented yet"])
    }

    func verifyPhoneCode(verificationID: String, verificationCode: String) async throws -> AuthUser {
        throw NSError(domain: "Wellish", code: 1005, userInfo: [NSLocalizedDescriptionKey: "Phone code verification not implemented yet"])
    }
    */

    // MARK: - Account Management
    
    /*
    func linkProvider(_ provider: AuthProvider, credential: AuthCredential) async throws {
        guard let user = auth.currentUser else { throw AuthError.userNotFound }
        try await user.link(with: credential)
    }

    func unlinkProvider(_ provider: AuthProvider) async throws {
        guard let user = auth.currentUser else { throw AuthError.userNotFound }
        try await user.unlink(fromProvider: provider.rawValue)
    }

    func reauthenticate(with credential: AuthCredential) async throws {
        guard let user = auth.currentUser else { throw AuthError.userNotFound }
        try await user.reauthenticate(with: credential)
    }
    */

    func signOut() throws {
        try auth.signOut()
    }

    func sendEmailVerification() async throws {
        guard let user = auth.currentUser else { throw AuthenticationError.userNotFound }
        try await user.sendEmailVerification()
    }

    func updateDisplayName(_ name: String) async throws {
        guard let user = auth.currentUser else { throw AuthenticationError.userNotFound }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        try await changeRequest.commitChanges()
    }

    func updatePhotoURL(_ url: URL) async throws {
        guard let user = auth.currentUser else { throw AuthenticationError.userNotFound }
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.photoURL = url
        try await changeRequest.commitChanges()
    }

    func deleteAccount() async throws {
        guard let user = auth.currentUser else { throw AuthenticationError.userNotFound }
        try await user.delete()
    }

    func refreshUser() async throws -> AuthUser {
        guard let user = auth.currentUser else { throw AuthenticationError.userNotFound }
        try await user.reload()
        return AuthUser(from: user)
    }
}
