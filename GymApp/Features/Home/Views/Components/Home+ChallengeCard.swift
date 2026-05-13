//
//  Home+ChallengeCard.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 04/09/25.
//

import SwiftUI

struct Home_ChallengeCard : View {
    
    
    let challenge : BaseChallenge
    @State private var imageLoadFailed = false
    
    var body: some View {
        ZStack {
            
            fusedBackgroundView
            
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .offset(x: 20, y: -20)
                }
                Spacer()
                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 40, height: 40)
                        .offset(x: -10, y: 15)
                    Spacer()
                }
            }
            
            HStack(spacing: 16) {
                // Left content
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: challenge.icon)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                            Text(challenge.subtitle)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Text(challenge.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    // Main number and progress
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .bottom, spacing: 6) {
                            Text("\(challenge.goalValue)")
                                .font(.system(size: 36, weight: .heavy))
                                .foregroundColor(.white)
                            Text(challenge.unit)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.bottom, 6)
                        }
                        
                        // Progress bar
                        VStack(alignment: .leading, spacing: 4) {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 6)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                    .frame(width: 120 * challenge.progress, height: 6)
                            }
                            .frame(width: 120)
                            
                            Text("\(challenge.currentValue)")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .zIndex(1)
                
                Spacer()
                
            }
            .padding(20)
        }
        .frame(width: UIScreen.main.bounds.width * 0.85, height: 180)
        .clipShape(RoundedRectangle(cornerRadius: 20))
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
                                    .frame(width: geometry.size.width * 0.75) // Extended to 70% for better blending
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

//#Preview {
//    Home_ChallengeCard(challenge: challenges[4])
//}
