//
//  StatisticCardWidgetSkeleton.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 21/11/25.
//

import SwiftUI

struct StatisticCardWidgetSkeleton: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Icono
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.fitnessTextSecondary.opacity(0.2))
                    .frame(width: 24, height: 24)
                    .shimmer(isAnimating: isAnimating)
                Spacer()
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 8) {
                // Label
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .frame(width: 70, height: 16)
                        .shimmer(isAnimating: isAnimating)
                    Spacer()
                }
                
                // Valor + unidad
                HStack(alignment: .bottom, spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .frame(width: 60, height: 24)
                        .shimmer(isAnimating: isAnimating)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .frame(width: 35, height: 14)
                        .shimmer(isAnimating: isAnimating)
                }
            }
        }
        .padding(16)
        .frame(width: UIScreen.screenWidth * 0.45)
        .frame(height: 120)
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.fitnessTextSecondary.opacity(0.15),
                        Color.fitnessInfo.opacity(0.2)
                    ]
                ),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}

