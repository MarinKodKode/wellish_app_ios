//
//  GymLiveTracker+ExerciseListView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_ExerciseListView: View {
    let sets: [RoutineSet]
    let currentIndex: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "list.bullet")
                    .foregroundColor(Color(red: 0.7, green: 0.4, blue: 0.95))
                Text("Ejercicios restantes")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.bottom, 4)
            
            ForEach(Array(sets.enumerated()), id: \.element.id) { index, set in
                GymLiveTracker_ExerciseRow(
                    set: set,
                    isCurrent: index == currentIndex,
                    isCompleted: index < currentIndex
                )
            }
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.14, blue: 0.22))
        .cornerRadius(20)
    }
}
//
//#Preview {
//    let routineSet = ActivityDataset.gymActivities[0].sets
//    GymLiveTracker_ExerciseListView(sets: routineSet, currentIndex: 1)
//}
