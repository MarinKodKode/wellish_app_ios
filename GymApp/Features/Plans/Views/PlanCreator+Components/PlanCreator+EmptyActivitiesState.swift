//
//  PlanCreator+EmptyActivitiesState.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import SwiftUI

extension CreatePlanView {
    
    var PlanCreator_EmptyActivitiesState : some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.walk")
                .font(.system(size: 60))
                .foregroundColor(.secondary.opacity(0.5))
                .padding()
                .background(
                    Circle()
                        .fill(Color(hex: "1E293B").opacity(0.5))
                )
            
            VStack(spacing: 8) {
                Text("Aún no has agregado actividades")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Agrega actividades para cada día de tu plan")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "1E293B").opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal)
    }
    
    
}
