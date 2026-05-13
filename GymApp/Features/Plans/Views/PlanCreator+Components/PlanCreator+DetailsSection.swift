//
//  PlanCreator_DetailsSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import SwiftUI

extension CreatePlanView {
    
    var PlanCreator_DetailsSection : some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "dumbbell.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text("Detalles del plan")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                TextField("Nuevo plan", text: $vm.plan.name)
                    .textFieldStyle(CustomTextFieldStyle())
                
                TextField("Añade una descripción (opcional)", text: Binding(
                    get: { vm.plan.description ?? "" },
                    set: { vm.plan.description = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                    .textFieldStyle(CustomTextFieldStyle())
                    .lineLimit(3...5)
            }
            .padding()
            .background(Color(hex: "1E293B"))
            .cornerRadius(20)
            .padding(.horizontal)
        }
    }
}

