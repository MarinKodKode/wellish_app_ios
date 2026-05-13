//
//  Signin_Component_RemPassword.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 26/11/25.
//


import Foundation
import SwiftUI

extension SignInView {
    
    var Signin_RememberPasswordCheckBox : some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: {
                savePassword.toggle()
            }) {
                Image(systemName: savePassword ? "checkmark.square.fill" : "square")
                    .foregroundColor(savePassword ? .blue : .secondary)
                    .font(.title3)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(StringConstants.rememberPassword)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.primary)
                
                Text(StringConstants.rememberPasswordDetails)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}
