//
//  ChallengeCardView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 20/11/25.
//

import SwiftUI

struct ChallengeCard: View {
    let challenge: BaseChallenge
    @State private var imageLoadFailed = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            fusedBackgroundView
            
            // Content
            VStack(alignment: .leading, spacing: 12) {
                // Icon & Title
                HStack(spacing: 8) {
                    Image(systemName: challenge.icon)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(challenge.period.displayName)
                            .font(.caption)
                            .opacity(0.9)
                        
                        Text(challenge.subtitle)
                            .font(.headline)
                            .fontWeight(.bold)
                    }
                }
                
                Spacer()
                
                // Value
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(challenge.currentValue)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    
                    Text(challenge.unit)
                        .font(.title3)
                        .opacity(0.9)
                }
                
                // Progress Bar
                VStack(spacing: 6) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 8)
                            
                            // Progress
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                                .frame(
                                    width: geometry.size.width * challenge.progress,
                                    height: 8
                                )
                                .animation(.spring(), value: challenge.progress)
                        }
                    }
                    .frame(height: 8)
                    
                    HStack {
                        Text("\(challenge.currentValue) / \(challenge.goalValue) \(challenge.unit.lowercased())")
                            .font(.caption)
                        
                        Spacer()
                        
                        if challenge.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                        }
                    }
                }
            }
            .foregroundColor(.white)
            .padding(20)
        }
        .frame(width: UIScreen.screenWidth * 0.80, height: 200)
        .cornerRadius(20)
        .shadow(color: challenge.color.opacity(0.4), radius: 10, x: 0, y: 5)
    }
    
    @ViewBuilder
    private var fusedBackgroundView: some View {
        GeometryReader { geometry in
            ZStack {
                // Base gradient background
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: challenge.colors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Image with fusion effect
                if let imageURL = challenge.imageUrl, !imageURL.isEmpty, !imageLoadFailed {
                    HStack(spacing: 0) {
                        Spacer()
                        
                        AsyncImage(url: URL(string: imageURL)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width * 0.75)
                                    .overlay(Color.black.opacity(0.6))
                                    .clipped()
                                    .mask(
                                        // Mask with smooth gradient for seamless fusion
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color.clear, location: 0),
                                                .init(color: Color.black.opacity(0.1), location: 0.15),
                                                .init(color: Color.black.opacity(0.4), location: 0.35),
                                                .init(color: Color.black.opacity(0.8), location: 0.55),
                                                .init(color: Color.black, location: 0.75),
                                                .init(color: Color.black, location: 1.0)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .blendMode(.normal)
                                    .opacity(0.7)
                                
                            case .failure(_):
                                Color.clear
                            case .empty:
                                Color.clear
                            @unknown default:
                                Color.clear
                            }
                        }
                        .onAppear {
                            imageLoadFailed = false
                        }
                    }
                }
            }
        }
    }
    
    private var gradientBackground: some View {
        LinearGradient(
            colors: [
                .primaryFitnessBlue.opacity(0.8),
                .premiumFitnessPurple.opacity(0.9),
                .infoFitnessCyan.opacity(0.7)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
