//
//  Signin_Components_Header.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 26/11/25.
//

import Foundation
import SwiftUI

extension SignInView {
    
    var Signin_Header : some View {
        VStack(spacing: 8) {
            Text(StringConstants.welcome)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top, 16)
            
            Text(StringConstants.enterYourCredentials)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.top, 32)
    }
}
