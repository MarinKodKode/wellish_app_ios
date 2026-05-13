//
//  GymLiveTracker+ExerciseRow.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_ExerciseRow: View {
    let set: RoutineSet
    let isCurrent: Bool
    let isCompleted: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            if isCompleted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.2, green: 0.8, blue: 0.5))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(set.exerciseName)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                Text("\(set.series.count) sets")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if isCurrent {
                Text("Actual")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(red: 0.7, green: 0.4, blue: 0.95))
                    .cornerRadius(12)
            }
        }
        .padding(12)
        .background(
            isCurrent ? Color(red: 0.15, green: 0.13, blue: 0.25) :
            isCompleted ? Color(red: 0.08, green: 0.15, blue: 0.12) :
            Color(red: 0.15, green: 0.17, blue: 0.25)
        )
        .cornerRadius(12)
    }
}
//
//#Preview {
//    let set = ActivityDataset.gymActivities[0].sets[0]
//    GymLiveTracker_ExerciseRow(set: set, isCurrent: true, isCompleted: false)
//}
