//
//  AuthProvider.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation

enum AuthProvider: String, CaseIterable {
    
    case email = "password"
    case google = "google.com"
    case facebook = "facebook.com"
    case apple = "apple.com"
    case phone = "phone"
    
    var displayName: String {
        switch self {
        case .email: return "Email"
        case .google: return "Google"
        case .facebook: return "Facebook"
        case .apple: return "Apple"
        case .phone: return "Phone"
        }
    }
    
    var iconName: String {
        switch self {
        case .email: return "envelope"
        case .google: return "google_ic"
        case .facebook: return "facebook_ic"
        case .apple: return "apple_ic"
        case .phone: return "phone"
        }
    }
}
