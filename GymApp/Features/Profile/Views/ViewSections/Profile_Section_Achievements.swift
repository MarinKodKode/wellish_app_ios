//
//  Profile_Section_Achievements.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 02/12/25.
//

import Foundation
import SwiftUI

struct Profile_Achievements : View {
    
    var body : some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tus logros")
                .font(.title3.bold())
                .foregroundColor(.fitnessTextPrimary)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    
                    AchievementBadge(
                        icon: "trophy",
                        title: "Week Warrior",
                        subtitle: "7-day streak",
                        color: .energyFitnessOrange
                    )
                    AchievementBadge(
                        icon: "flame",
                        title: "Fire Starter",
                        subtitle: "10 routines",
                        color: .errorFitnessRed
                    )
                    AchievementBadge(
                        icon: "dumbbell",
                        title: "Strength Pro",
                        subtitle: "50 workouts",
                        color: .primaryFitnessBlue
                    )
                    AchievementBadge(
                        icon: "star",
                        title: "Perfect Week",
                        subtitle: "All plans done",
                        color: .premiumFitnessPurple
                    )
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    Profile_Achievements()
}
