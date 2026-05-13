//
//  State.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 29/07/25.
//

import Foundation
import FirebaseAuth

enum AuthenticationState {
    case loading
    case authenticated(User)
    case unauthenticated
}
