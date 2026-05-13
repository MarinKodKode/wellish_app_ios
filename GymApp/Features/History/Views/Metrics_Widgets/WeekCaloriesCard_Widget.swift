//
//  WeekCaloriesCard_Widget.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/12/25.
//

import SwiftUI

struct WeekCaloriesCard_Widget : View {
    let weekData: [DayCalories]
    let totalCalories: Int
    
    private var maxCalories: Int {
        weekData.map { $0.calories }.max() ?? 1
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Estadísticas")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "2C3E50"), Color(hex: "34495E")],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(spacing: 30) {
                    HStack(alignment: .bottom, spacing: 12) {
                        ForEach(weekData) { day in
                            VStack(spacing: 8) {
                                // Bar container
                                ZStack(alignment: .bottom) {
                                    // Background bar
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "3A4D5C"))
                                        .frame(height: 200)
                                    
                                    // Filled bar
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "6FA8DC"))
                                        .frame(height: barHeight(for: day.calories))
                                }
                                .frame(maxWidth: .infinity)
                                
                                // Day label
                                Text(day.day)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Total calories badge
                    HStack(spacing: 12) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                        
                        Text("\(totalCalories)")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(Color(hex: "E8B85D"))
                    )
                }
                .padding(.vertical, 30)
            }
        }
        .padding(20)
        .background(Color(hex: "1A2332"))
    }
    
    private func barHeight(for calories: Int) -> CGFloat {
        let ratio = CGFloat(calories) / CGFloat(maxCalories)
        return max(ratio * 200, 40)
    }
}

struct DayCalories: Identifiable {
    let id = UUID()
    let day: String
    let calories: Int
}


#Preview {
    WeekCaloriesCard_Widget (
        weekData: [
            DayCalories(day: "Lun", calories: 450),
            DayCalories(day: "Mar", calories: 380),
            DayCalories(day: "Mié", calories: 520),
            DayCalories(day: "Jue", calories: 410),
            DayCalories(day: "Vie", calories: 490),
            DayCalories(day: "Sáb", calories: 350),
            DayCalories(day: "Dom", calories: 400)
        ],
        totalCalories: 3000
    )
}
