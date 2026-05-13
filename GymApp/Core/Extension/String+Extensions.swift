//
//  String+Extensions.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var isValidPhoneNumber: Bool {
        let phoneRegex = #"^\+[1-9]\d{1,14}$"#
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self)
    }
    
    var isStrongPassword: Bool {
        guard count >= 8 else { return false }
        
        let hasUppercase = rangeOfCharacter(from: .uppercaseLetters) != nil
        let hasLowercase = rangeOfCharacter(from: .lowercaseLetters) != nil
        let hasDigit = rangeOfCharacter(from: .decimalDigits) != nil
        
        return hasUppercase && hasLowercase && hasDigit
    }
    
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
