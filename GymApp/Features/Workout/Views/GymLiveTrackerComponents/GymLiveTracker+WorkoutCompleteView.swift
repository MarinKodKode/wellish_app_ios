//
//  GymLiveTracker+WorkoutCompleteView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_WorkoutCompleteView: View {
    
    let totalTime: Int
    let caloriesBurned: Int
    let onDismiss: () -> Void
    
    @State private var bounce = false
    @ObservedObject private var vm = GymLiveTrackerViewModel.shared
    
    var body: some View {
        VStack(spacing: 32) {
            ZStack {
                Circle()
                    .fill(Color(red: 1.0, green: 0.84, blue: 0.0))
                    .frame(width: 140, height: 140)
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 70))
                    .foregroundColor(Color(red: 0.07, green: 0.09, blue: 0.15))
            }
            .scaleEffect(bounce ? 1.1 : 1.0)
            .animation(Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: bounce)
            .onAppear { bounce = true }
            
            Text("¡Rutina Completada!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            Text("🎉")
                .font(.system(size: 60))
            
            HStack(spacing: 16) {
                
                GymLiveTracker_CompletionStat(
                    icon: "clock.fill",
                    value: formatTime(totalTime),
                    label: "Tiempo total",
                    color: Color(red: 0.3, green: 0.6, blue: 1.0)
                )
                GymLiveTracker_CompletionStat(
                    icon: "flame.fill",
                    value: "\(caloriesBurned)",
                    label: "Calorías",
                    color: Color(red: 1.0, green: 0.5, blue: 0.2)
                )
            }
            .padding(.horizontal, 20)
            
            
            Button(action: {
                onDismiss()
            }, label: {
                Text("Finalizar")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                    .cornerRadius(16)
            })
            .padding(.horizontal, 32)
           
            
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

#Preview {
    GymLiveTracker_WorkoutCompleteView(
        totalTime: 340,
        caloriesBurned: 1238,
        onDismiss: {}
    )
}
