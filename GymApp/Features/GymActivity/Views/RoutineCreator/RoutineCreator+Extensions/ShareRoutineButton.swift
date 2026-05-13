//
//  ShareRoutineButton.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

extension RoutineCreatorView {
    
    var shareButton: some View {
        Button(action: {
            print("\(vm.gymActivity)")
            Task {
//                let success = await vm.saveToFirebase()
//                if success {
//                    print("🎉 Rutina guardada!")
//                }
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "square.and.arrow.up")
                    .font(.title2)
                
                Text(StringConstants.shareRoutine)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.primaryFitnessBlue)
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(Color.primaryFitnessBlue.opacity(0.1))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.primaryFitnessBlue.opacity(0.3), lineWidth: 2)
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }

}
