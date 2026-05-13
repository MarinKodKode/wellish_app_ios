//
//  Profile_Section_Summary.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 15/12/25.
//

import SwiftUI


struct SummarySectionView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Resumen")
                .font(.title3.bold())
                .foregroundColor(.fitnessTextPrimary)
//                .padding(.horizontal)
            
            SummaryStatsCard(
                icon: "dumbbell.fill",
                title: "Rutinas completadas",
                value: "42",
                subtitle: "Este mes • +12 vs. anterior",
                gradientColors: [
                    Color(red: 0.4, green: 0.7, blue: 1.0),
                    Color(red: 0.6, green: 0.8, blue: 1.0)
                ]
            )
            
            SummaryStatsCard(
                icon: "flame.fill",
                title: "Calorías quemadas",
                value: "12,450",
                subtitle: "Total • Promedio 415/día",
                gradientColors: [
                    Color(red: 1.0, green: 0.5, blue: 0.3),
                    Color(red: 1.0, green: 0.7, blue: 0.4)
                ]
            )
            
            // Tiempo total
            SummaryStatsCard(
                icon: "clock.fill",
                title: "Tiempo entrenando",
                value: "28h 30m",
                subtitle: "Este mes • 54 min/sesión",
                gradientColors: [
                    Color(red: 0.5, green: 0.8, blue: 0.6),
                    Color(red: 0.6, green: 0.9, blue: 0.7)
                ]
            )
        }
        .padding(.horizontal)
    }
}


#Preview {
    SummarySectionView()
}
