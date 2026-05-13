//
//  PlanCreator+Header.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import SwiftUI

extension CreatePlanView {
    
    var PlanCreator_Header : some View {
        HStack {
            Text("¡Construye el plan perfecto para ti!")
                .font(.title3)
                .foregroundColor(.secondary)
            Spacer()
            Button {
            } label: {
                Image(systemName: "questionmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal)
    }
}


