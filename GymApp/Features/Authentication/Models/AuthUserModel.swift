//
//  AuthUser.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase

struct AuthUser :  Identifiable, Equatable  {
    var id: String { uid }  //Identifiable conform
    let uid: String
    let email: String?
    let displayName: String?
    let photoURL: URL?
    let phoneNumber: String?
    let isEmailVerified: Bool
    let creationDate: Date?
    let providers: [AuthProvider]
    let isAnonymous: Bool
    var safePhotoURL: URL {
        photoURL ?? URL(string: "https://your-default-avatar.com/image.png")!
    }
    
    
    init(from firebaseUser: User) {
        self.uid = firebaseUser.uid
        self.email = firebaseUser.email
        self.displayName = firebaseUser.displayName
        self.photoURL = firebaseUser.photoURL
        self.phoneNumber = firebaseUser.phoneNumber
        self.isEmailVerified = firebaseUser.isEmailVerified
        self.creationDate = firebaseUser.metadata.creationDate
        self.isAnonymous = firebaseUser.isAnonymous
        
        // Map Firebase provider IDs to our enum
        self.providers = firebaseUser.providerData.compactMap { userInfo in
            AuthProvider(rawValue: userInfo.providerID)
        }
    }
    
    var primaryProvider: AuthProvider? {
        return providers.first
    }
    
    var hasMultipleProviders: Bool {
        return providers.count > 1
    }
}

