//
//  GymLiveTracker+RestTimer.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_RestTimer: View {
    let restTimer: Int
    let onSkip: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("DESCANSO")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.2).opacity(0.8))
                .tracking(1)
            
            Text("\(restTimer)s")
                .font(.system(size: 56, weight: .bold))
                .foregroundColor(Color(red: 1.0, green: 0.5, blue: 0.2))
            
            Text("Prepárate para el siguiente set")
                .font(.system(size: 13))
                .foregroundColor(.gray)
            
            Button(action: onSkip) {
                Text("Saltar descanso")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(red: 1.0, green: 0.5, blue: 0.2).opacity(0.3))
                    .cornerRadius(20)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color(red: 0.15, green: 0.1, blue: 0.08))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(red: 1.0, green: 0.5, blue: 0.2).opacity(0.3), lineWidth: 2)
        )
    }
}

#Preview {
    GymLiveTracker_RestTimer(restTimer: 30, onSkip: {})
}
