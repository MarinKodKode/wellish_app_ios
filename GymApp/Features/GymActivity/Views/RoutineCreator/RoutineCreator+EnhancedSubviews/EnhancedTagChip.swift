//
//  EnhancedTagChip.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

struct EnhancedTagChip: View {
    let tag: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(tag)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.premiumFitnessPurple)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.premiumFitnessPurple.opacity(0.1))
                .cornerRadius(20)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.fitnessTextSecondary)
                    .font(.caption)
            }
        }
    }
}
