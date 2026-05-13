//
//  SaveRoutineButton.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

extension RoutineCreatorView{
    
    var saveButton: some View {
        Button(action: {
            Task {
                let ok = await vm.saveRoutine()
                if ok {
                    // Success feedback can be added later
                }
            }
            self.vm.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.vm.isLoading = false
                self.vm.savedSuccess = true
            }
        }) {
            HStack(spacing: 12) {
                if vm.isSaving {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                    
                    Text(StringConstants.saveRoutine)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                LinearGradient(
                    colors: vm.canSave ? [.fitnessSuccess, .fitnessSuccess.opacity(0.8)] : [Color.gray.opacity(0.5)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: vm.canSave ? .fitnessSuccess.opacity(0.3) : .clear, radius: 8, y: 4)
        }
        .disabled(!vm.canSave)
        .buttonStyle(ScaleButtonStyle())
    }
    
}
