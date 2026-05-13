//
//  AuthenticationServiceProtocol.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation
import AuthenticationServices
import FirebaseAuth
import Combine

protocol AuthenticationServiceProtocol {
    // MARK: - Email & Password
    func createUser(with registration: UserRegistrationModel) async throws -> AuthUser
    func signIn(email: String, password: String) async throws -> AuthUser
    func sendPasswordReset(email: String) async throws

    // MARK: - Social Authentication (For future use)
    // func signInWithGoogle() async throws -> AuthUser
    // func signInWithFacebook() async throws -> AuthUser
    // func signInWithApple(_ authorization: ASAuthorization) async throws -> AuthUser

    // MARK: - Phone Authentication (For future use)
    // func sendPhoneVerification(phoneNumber: String) async throws -> String
    // func verifyPhoneCode(verificationID: String, verificationCode: String) async throws -> AuthUser

    // MARK: - Account Management (For future use)
    // func linkProvider(_ provider: AuthProvider, credential: AuthCredential) async throws
    // func unlinkProvider(_ provider: AuthProvider) async throws
    // func reauthenticate(with credential: AuthCredential) async throws

    // MARK: - Common
    func signOut() throws
    func sendEmailVerification() async throws
    func updateDisplayName(_ name: String) async throws
    func updatePhotoURL(_ url: URL) async throws
    func deleteAccount() async throws
    func refreshUser() async throws -> AuthUser

    var currentUser: AuthUser? { get }
    var authStatePublisher: AnyPublisher<AuthUser?, Never> { get }
}
