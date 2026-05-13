//
//  GymLiveTracker+CompletionStat.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_CompletionStat: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(16)
    }
}

#Preview {
    GymLiveTracker_CompletionStat(
        icon: "flame",
        value: "200",
        label: "Good",
        color: Color.fitnessSuccess
    )
}
