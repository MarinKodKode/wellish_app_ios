//
//  Profile_Component_ActionRow.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/12/25.
//

import SwiftUI

struct Profile_Component_ActionRow: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.primaryFitnessBlue)
                
                Text(label)
                    .font(.body)
                    .foregroundColor(.fitnessTextPrimary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 16))
                    .foregroundColor(.fitnessTextSecondary)
            }
            .padding(12)
            .background(Color.fitnessBackgroundSecondary)
            .cornerRadius(12)
        }
    }
}
