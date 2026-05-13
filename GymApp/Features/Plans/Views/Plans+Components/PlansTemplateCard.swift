//
//  PlansTemplateCard.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 04/09/25.
//

import SwiftUI

struct TemplateCard: View {
    let plan : Plan
    var action: () -> Void
    
    @State private var imageLoadFailed = false
    
    var body: some View {
        ZStack {
            backgroundView
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text(plan.name)
                        .font(.system(size: 24, weight: .bold))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(plan.description ?? "Descubre nuevos límites!")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    Label("\(plan.durationWeeks) weeks", systemImage: "calendar")
                        .font(.system(size: 18))
                        .foregroundColor(.white.opacity(0.8))
                    
                    HStack{
                        Label(
                            "\(plan.goal.rawValue)",
                            systemImage: plan.goal.icon
                        )
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(plan.goal.color))
                        .cornerRadius(8)
                        
                    }
                    .padding(.bottom, 12)
                
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.6)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )
            }
        }
        .frame(width: 280, height: 200)
        .cornerRadius(16)
        .clipped()
        .onTapGesture(perform: action)
    }
    
    
    @ViewBuilder
    private var backgroundView: some View {
        if let imageURL = plan.thumbnailURL, !imageURL.isEmpty, !imageLoadFailed {
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 280, height: 200)
                        .aspectRatio(contentMode: .fit)
                        .overlay(Color.backgroundPrimary.opacity(0.6))
                case .failure(_):
                    gradientBackground
                case .empty:
                    gradientBackground
                @unknown default:
                    gradientBackground
                }
            }
        } else {
            gradientBackground
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



