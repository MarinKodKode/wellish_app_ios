//
//  AuthenticationState.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 29/07/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine

@MainActor
class AuthenticationService: ObservableObject {
    @Published var authenticationState: AuthenticationState = .loading
    @Published var authenticationState_test: AuthenticationState = .loading
    
    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private var sessionManager = SessionDataManager.shared
    
    init() {
        configureAuthStateListener()
    }
    
    deinit {
        if let handle = authStateHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    
    var currentUserId : String? {
        if case .authenticated(let user) = authenticationState {
            sessionManager.userId = user.uid
            return user.uid
        }
        return nil
    }
    
    private func configureAuthStateListener() {
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                if let user = user {
                    self?.authenticationState = .authenticated(user)
                } else {
                    self?.authenticationState = .unauthenticated
                }
            }
        }
    }
    
    func signOut() async throws {
        try Auth.auth().signOut()
    }
}

