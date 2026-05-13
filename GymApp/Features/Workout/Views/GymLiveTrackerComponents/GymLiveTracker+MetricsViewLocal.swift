//
//  GymLiveTracker+MetricsViewLocal.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_MetricsViewLocal: View {
    let elapsedTime: Int
    let caloriesBurned: Int
    let currentExercise: Int
    let totalExercises: Int
    
    var body: some View {
        HStack(spacing: 12) {
            MetricCard(
                icon: "clock.fill",
                value: formatTime(elapsedTime),
                label: "Tiempo",
                color: Color(red: 0.3, green: 0.6, blue: 1.0)
            )
            MetricCard(
                icon: "flame.fill",
                value: "\(caloriesBurned)",
                label: "kcal",
                color: Color(red: 1.0, green: 0.5, blue: 0.2)
            )
            MetricCard(
                icon: "dumbbell.fill",
                value: "\(currentExercise)/\(totalExercises)",
                label: "Ejercicio",
                color: Color(red: 0.7, green: 0.4, blue: 0.95)
            )
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%d:%02d", mins, secs)
    }
}

#Preview {
    GymLiveTracker_MetricsViewLocal(
        elapsedTime: 120,
        caloriesBurned: 750,
        currentExercise: 1,
        totalExercises: 3
    )
}

//MARK: - Metric card 

struct MetricCard: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(16)
    }
}
