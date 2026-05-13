//
//  EnhancedSerieRowView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

struct EnhancedSerieRowView: View {
    @Binding var serie: Serie
    var onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: "repeat")
                    .foregroundColor(.energyFitnessOrange)
                    .frame(width: 36)
                
                Text("Repeticiones")
                    .font(.system(size: 20))
                    .foregroundColor(.fitnessTextSecondary)
                Spacer()
                
                TextField("0", value: $serie.repetitions, formatter: NumberFormatter.integer)
                    .keyboardType(.numberPad)
                    .font(.system(size: 20))
                    .foregroundColor(.fitnessTextPrimary)
                    .padding(8)
                    .frame(width: 60)
                    .background(Color.fitnessBackgroundPrimary)
                    .cornerRadius(6)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack{
                Image(systemName: "scalemass")
                    .frame(width: 36)
                    .foregroundColor(.fitnessSuccess)
                    .padding(.trailing, 6)
                
                Text("Weight")
                    .font(.system(size: 20))
                    .foregroundColor(.fitnessTextSecondary)
                
                Spacer()
                
                TextField("0.0", value: Binding(
                    get: { serie.idealWeightKg ?? 0.0 },
                    set: { serie.idealWeightKg = $0 > 0 ? $0 : nil }
                ), formatter: NumberFormatter.decimal)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .keyboardType(.decimalPad)
                .foregroundColor(.fitnessTextPrimary)
                .cornerRadius(6)
                .padding(.trailing, -20)
                .fixedSize()
                
                
                Text("kg")
                    .font(.system(size: 20))
                    .foregroundColor(.fitnessTextSecondary)
                    .fontWeight(.bold)
                    .padding(.trailing, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Bottom row: Volume display
            HStack(spacing: 4) {
                Image(systemName: "medal")
                    .frame(width: 36)
                    .foregroundColor(.fitnessSuccess)
                    .padding(.trailing, 12)
                Text("Volume")
                    .font(.system(size: 20))
                    .foregroundColor(.fitnessTextSecondary)
                Spacer()
                Text(String(format: "%.0f kg", serie.estimatedVolumeKg))
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.fitnessSuccess)
                    .padding(.trailing, 12)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 16)
        .background(Color.fitnessBackgroundPrimary)
        .cornerRadius(12)
    }
}
