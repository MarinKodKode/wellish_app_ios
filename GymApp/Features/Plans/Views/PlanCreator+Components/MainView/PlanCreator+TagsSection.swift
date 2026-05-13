//
//  PlanCreator_TagsSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import SwiftUI

extension CreatePlanView {
    
    var PlanCreator_TagsSection : some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "tag.fill")
                    .font(.title2)
                    .foregroundColor(.pink)
                
                Text("Tags y categorías")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            VStack(spacing: 12) {
                HStack(spacing: 8) {
                    TextField("Agregar nuevo tag", text: .constant(""))
                        .textFieldStyle(CustomTextFieldStyle())
                    
                    Button {
                        // Add tag
                    } label: {
                        Text("Agregar")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color(hex: "475569"))
                            .cornerRadius(12)
                    }
                }
                
                TextField("Categorías (ej. cardio, fuerza)", text: .constant(""))
                    .textFieldStyle(CustomTextFieldStyle())
            }
            .padding()
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
}
