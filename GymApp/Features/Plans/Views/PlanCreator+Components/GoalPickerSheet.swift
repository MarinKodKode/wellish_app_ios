//
//  GoalPickerSheet.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import SwiftUI

struct GoalPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedGoal: PlanGoal
    
    var body: some View {
        NavigationView {
            List {
                ForEach(PlanGoal.allCases, id: \.self) { goal in
                    Button {
                        selectedGoal = goal
                        dismiss()
                    } label: {
                        HStack(spacing: 16) {
                            Image(systemName: goal.icon)
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color(goal.color))
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(goal.displayName)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text(goal.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if goal == selectedGoal {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("Selecciona tu objetivo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
        }
    }
}
