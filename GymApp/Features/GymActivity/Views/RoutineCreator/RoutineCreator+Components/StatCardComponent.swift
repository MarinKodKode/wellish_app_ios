//
//  StatCardComponent.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 15/08/25.
//

import SwiftUI

struct StatCardComponent: View {
    let icon: String
    let label: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.primary)
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
    }
}

