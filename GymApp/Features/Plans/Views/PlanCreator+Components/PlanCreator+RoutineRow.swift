//
//  PlanCreator+RoutineRow.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 21/10/25.
//

import Foundation
import SwiftUI

struct RoutineRow: View {
    let routine: GymActivity
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(routine.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(routine.category?.displayName ?? "Sin categoría")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack {
                    HStack(spacing: 4) {
                        
                        Image(systemName: "flame")
                            .font(.caption2)
                        
                        Text(String(routine.estimatedCalories ?? 10))
                            .font(.caption)
                        
                        Spacer()
                    }
                    .foregroundColor(.secondary.opacity(0.8))
                    
                    HStack(spacing: 4) {
                        
                        Image(systemName: "clock")
                            .font(.caption2)
                        
                        Text(routine.formattedDuration)
                            .font(.caption)
                        
                        Spacer()
                    }
                    .foregroundColor(.secondary.opacity(0.8))
                }
                
                
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 4)
        }
    }
}
