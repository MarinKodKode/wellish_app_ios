//
//  CompletedActivityCardSkeleton.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 21/11/25.
//

import Foundation
import SwiftUI

struct CompletedActivityCardSkeleton: View {
    @State private var isAnimating = false
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.fitnessTextSecondary.opacity(0.2))
                .frame(width: 60, height: 60)
                .shimmer(isAnimating: isAnimating)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .frame(width: 120, height: 16)
                        .shimmer(isAnimating: isAnimating)
                    
                    Spacer()
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .frame(width: 70, height: 24)
                        .shimmer(isAnimating: isAnimating)
                }
                
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .frame(width: 70, height: 12)
                        .shimmer(isAnimating: isAnimating)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .frame(width: 70, height: 12)
                        .shimmer(isAnimating: isAnimating)
                }
                
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .frame(height: 8)
                        .shimmer(isAnimating: isAnimating)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .frame(width: 35, height: 12)
                        .shimmer(isAnimating: isAnimating)
                }
            }
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    .backgroundPrimary.opacity(0.4),
                    .fitnessInfo.opacity(0.3),
                    .backgroundPrimary.opacity(0.4),
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.fitnessTextSecondary.opacity(0.1), lineWidth: 1)
        )
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
}
