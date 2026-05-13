//
//  GymLiveTracker+Header.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import Foundation
import SwiftUI

struct GymLiveTracker_HeaderView: View {
    let workoutName: String
    let elapsedTime: Int
    
    var body: some View {
        HStack {
            Text(workoutName)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .lineLimit(2)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("Tiempo activo")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text(formatTime(elapsedTime))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

#Preview {
    GymLiveTracker_HeaderView(workoutName: "Bench Press", elapsedTime: 120)
}
