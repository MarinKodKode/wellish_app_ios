//
//  GymLiveTracker+StartWorkoutView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_StartWorkoutView: View {
    
    
    let planElement: PlanElement
    let onStart: () -> Void
    
    var body: some View {
        
        VStack(spacing: 24) {
            if case .gym(let gymActivity) = planElement.activity {
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
                
                Text(gymActivity.name)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                if let description = gymActivity.description {
                    Text(description)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                VStack(spacing: 12) {
                    HStack {
                        Label("\(gymActivity.sets.count) ejercicios", systemImage: "list.bullet")
                        Spacer()
                        if let duration = gymActivity.estimatedDurationMinutes {
                            Label("\(duration) min", systemImage: "clock")
                        }
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                }
                .padding()
                .background(Color(red: 0.12, green: 0.14, blue: 0.22))
                .cornerRadius(16)
                .padding(.horizontal, 32)
                
                Button(action: onStart) {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("Comenzar Entrenamiento")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.9, green: 0.3, blue: 0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 32)
                .padding(.top, 16)
            }
        }
    }
}
