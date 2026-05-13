//
//  PlanCreator+ActivitiesSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import SwiftUI

extension CreatePlanView {
    
    var PlanCreator_ActivitiesSection : some View {
        
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.title2)
                    .foregroundColor(.orange)
                
                Text("Actividades del plan")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            if vm.plan.elements.isEmpty {
                
                PlanCreator_EmptyActivitiesState
                
            } else {
                PlanCreator_ActivitiesList
            }
            
            PlanCreator_CalendarGrid
            
            Button {
                // Show instruction to select a day
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Añade una actividad")
                            .font(.headline)
                        Text("Selecciona un día del calendario")
                            .font(.caption)
                            .opacity(0.8)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.right")
                        .font(.title3)
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: Color.blue.opacity(0.3), radius: 10, y: 5)
            }
            .padding(.horizontal)
        }
    }
    
}
