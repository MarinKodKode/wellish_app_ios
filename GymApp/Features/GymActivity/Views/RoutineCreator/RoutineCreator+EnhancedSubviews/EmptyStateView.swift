//
//  EmptyStateView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 48))
                .foregroundColor(.fitnessTextSecondary.opacity(0.5))
            
            Text(StringConstants.routineNoExcersicesYet)
                .font(.headline)
                .foregroundColor(.fitnessTextSecondary)
            
            Text(StringConstants.routineAddYourFirstExercise)
                .font(.subheadline)
                .foregroundColor(.fitnessTextSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding(32)
    }
}

#Preview {
    EmptyStateView()
}
