//
//  RoutineStatisticsRowView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 24/09/25.
//

import SwiftUI

struct RoutineStatisticsRowView: View {
    
    let size: CGFloat
    let gap: CGFloat
    let numberOfStats: Int
    let alignTo: Alignment
    
    let calories: String
    let time: String
    let exercises: String
    
    init(
        size: CGFloat = 14,
        gap: CGFloat = 8,
        numberOfStats: Int = 3,
        alignTo: Alignment = .center,
        
        calories: String,
        time: String,
        exercises: String
    ) {
        self.size = size
        self.gap = gap
        self.numberOfStats = numberOfStats
        self.alignTo = alignTo
        self.calories = calories
        self.time = time
        self.exercises = exercises
    }
    
    var body: some View {
        HStack(spacing: gap) {
//            HStack(spacing: 4) {
//                Image(systemName: "dumbbell")
//                    .foregroundColor(.white)
//                    .font(.system(size: size))
//                Text(exercises)
//                    .font(.system(size: size, weight: .medium))
//                    .foregroundColor(.white)
//            }
            
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .foregroundColor(.white)
                    .font(.system(size: size))
                Text(time)
                    .font(.system(size: size, weight: .medium))
                    .foregroundColor(.white)
            }
            
//            if numberOfStats == 3 {
                HStack(spacing: 4) {
                    Image(systemName: "flame")
                        .foregroundColor(.white)
                        .font(.system(size: size))
                    Text(calories)
                        .font(.system(size: size, weight: .medium))
                        .foregroundColor(.white)
                }
//            }
        }
        .frame(maxWidth: .infinity, alignment: alignTo)
    }
}
