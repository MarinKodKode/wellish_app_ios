//
//  InformationComponentRow.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/10/25.
//

import SwiftUI

struct InformationComponentRow: View {
    
    let plan : Plan
    
    let urlIMage = "https://i.pinimg.com/736x/3d/30/bf/3d30bf0c579fa14498b8b03ef53067f0.jpg"
    
    var body: some View {
        HStack(spacing: 12) {
                AsyncImage(url: URL(string: urlIMage)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.fitnessTextSecondary.opacity(0.2))
                        .overlay(
                            Image(systemName: "dumbbell.fill")
                                .foregroundColor(.fitnessTextSecondary)
                                .font(.title2)
                        )
                }
                .frame(width: 60, height: 60)
                .cornerRadius(12)
                .clipped()
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(plan.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.fitnessTextPrimary)
                        
                        Spacer()
                        
                        //                    Text(plan.goal.rawValue)
                        Text("Muscle Gain")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.fitnessInfo.opacity(0.8))
                            .cornerRadius(8)
                        
                    }
                    
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .font(.system(size: 12))
                                .foregroundColor(.fitnessTextSecondary)
                            Text("12 Routines")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.fitnessTextSecondary)
                        }
                        
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(.fitnessTextSecondary)
                            Text("4 weeks")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.fitnessTextSecondary)
                        }
                    }
                    .padding(.bottom, 6)
                    
                    
                    
                }
        }
        .padding(16)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.fitnessTextSecondary.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
//    InformationComponentRow()
}

