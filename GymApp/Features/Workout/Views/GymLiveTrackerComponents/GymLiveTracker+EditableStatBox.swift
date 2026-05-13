//
//  GymLiveTracker+EditableStatBox.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_EditableStatBox: View {
    @Binding var value: Int
    let label: String
    let color: Color
    let isEditable: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            
            // Usa un TextField si es editable, o solo Text si no lo es
            if isEditable {
                TextField("0", value: $value, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(color)
                    .fixedSize()
                    .frame(minWidth: 50) // Asegurar un tamaño mínimo para el touch
            } else {
                Text(value > 0 ? "\(value)" : "BW")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(color)
            }
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(red: 0.15, green: 0.17, blue: 0.25))
        .cornerRadius(12)
    }
}
