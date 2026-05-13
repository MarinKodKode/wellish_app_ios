//
//  Signin_Components_ThirdPartyButtons.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 26/11/25.
//

import Foundation
import SwiftUI

extension SignInView {
    
    var Signin_ThirdPartyButtons : some View {
    
        HStack(spacing: 36) {
            Button(action: {
                Task {
                    await signUpWithGoogle()
                }
            }) {
                HStack(spacing: 8) {
                    Image("google_ic")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                        .foregroundColor(.primary)
                    
                }
                .frame(height: 50)
                
            }
            
            Button(action: {
                
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .foregroundColor(.primary)
                        .frame(width: 32.0, height: 38.0)
                }
                .frame(height: 50)
                
            }
        }
        
    }
    
}
