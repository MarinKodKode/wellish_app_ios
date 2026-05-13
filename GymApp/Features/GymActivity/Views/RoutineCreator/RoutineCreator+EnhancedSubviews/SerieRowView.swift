//
//  SerieRowView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 03/09/25.
//

import SwiftUI

struct SerieRowView: View {
    @Binding var serie: Serie
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Reps:")
                        .foregroundColor(.white)
                    TextField("Reps", value: $serie.repetitions, formatter: NumberFormatter.integer)
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                }
                HStack {
                    Text("Weight (kg):")
                        .foregroundColor(.white)
                    TextField("kg", value: Binding(get: { serie.idealWeightKg ?? 0.0 },
                                                  set: { new in serie.idealWeightKg = new > 0 ? new : nil }),
                              formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .frame(width: 80)
                }
            }
            Spacer()
            Text(String(format: "%.0f kg", serie.estimatedVolumeKg))
                .font(.caption)
                .foregroundColor(.gray)

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
    }
}

