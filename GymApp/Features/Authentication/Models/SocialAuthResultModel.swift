//
//  SocialAuthResultModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation
import FirebaseAuth

struct SocialAuthResult {
    
    let credential: AuthCredential
    let additionalUserInfo: AdditionalUserInfo?
    
}
