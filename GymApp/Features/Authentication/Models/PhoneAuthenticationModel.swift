//
//  PhoneAuthenticationModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation


struct PhoneAuthenticationModel {
    let phoneNumber: String
    let verificationCode: String?
    let verificationID: String?
    
    var isPhoneValid: Bool {
        phoneNumber.isValidPhoneNumber
    }
    
    var isCodeValid: Bool {
        guard let code = verificationCode else { return false }
        return code.count >= 6
    }
}
