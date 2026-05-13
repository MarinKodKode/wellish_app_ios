//
//  GymLiveTracker+CurrentExerciseCard.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_CurrentExerciseCard: View {
    let routineSet: RoutineSet
    let currentSet: Int
    @Binding var property : Int
    let currentExerciseIndex: Int
    let totalExercises: Int
    let completedSets: [Int]
    let totalSetsInExercise: Int
    let isTimerRunning: Bool
    let isResting: Bool
    let onStart: () -> Void
    let onPause: () -> Void
    let onResume: () -> Void
    let onCompleteSet: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(routineSet.exerciseName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("Ejercicio \(currentExerciseIndex + 1)/\(totalExercises)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.6, green: 0.4, blue: 0.9))
                    .cornerRadius(20)
            }
            
            // Stats del set actual
            if currentSet <= routineSet.series.count {
                let series = routineSet.series[currentSet - 1]
                HStack(spacing: 12) {
                    GymLiveTracker_StatBox(
                        value: "\(currentSet)",
                        label: "Set",
                        color: Color(red: 0.7, green: 0.4, blue: 0.95)
                    )
                    GymLiveTracker_StatBox(
                        value: "\(series.repetitions)",
                        label: "Reps",
                        color: Color(
                            red: 0.9,
                            green: 0.3,
                            blue: 0.7
                        ),
                    )
                    if let weight = series.idealWeightKg {
                        GymLiveTracker_StatBox(
                            value: "\(weight)",
                            label: "kg",
                            color: Color(red: 0.3, green: 0.6, blue: 1.0),
                        )
                    }
                }
            }
            
            // Indicadores de sets completados
            HStack(spacing: 6) {
                ForEach(1...totalSetsInExercise, id: \.self) { set in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            completedSets.contains(set) ? Color(red: 0.2, green: 0.8, blue: 0.5) :
                            set == currentSet ? Color(red: 0.7, green: 0.4, blue: 0.95) :
                            Color(red: 0.2, green: 0.22, blue: 0.3)
                        )
                        .frame(height: 6)
                }
            }
            
            // Botones de control
            HStack(spacing: 12) {
                if !isTimerRunning {
                    Button(action: onStart) {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 16))
                            Text("Iniciar Rutina")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 0.2, green: 0.8, blue: 0.5), Color(red: 0.1, green: 0.7, blue: 0.4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                } else {
                    Button(action: onPause) {
                        HStack(spacing: 8) {
                            Image(systemName: "pause.fill")
                                .font(.system(size: 16))
                            Text("Pausar")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.5, blue: 0.2), Color(red: 0.9, green: 0.3, blue: 0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    
                    Button(action: onCompleteSet) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                            Text("Completar Set")
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
//                            isResting ? Color(red: 0.2, green: 0.22, blue: 0.3) :
                            LinearGradient(
                                colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.9, green: 0.3, blue: 0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundColor(isResting ? .gray : .white)
                        .cornerRadius(16)
                    }
                    .disabled(isResting)
                }
            }
        }
        .padding(20)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(24)
    }
}
