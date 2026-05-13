//
//  UserRegistrationModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//


import Foundation
import SwiftUI

struct UserRegistrationModel {
    let fullName: String
    let email: String
    let password: String
    let provider: AuthProvider
    
    var isValid: Bool {
        switch provider {
        case .email:
            return !fullName.isEmpty && email.isValidEmail && password.isStrongPassword
        case .phone:
            return !fullName.isEmpty && email.isValidPhoneNumber
        default:
            return !fullName.isEmpty // Social providers handle validation
        }
    }
}
