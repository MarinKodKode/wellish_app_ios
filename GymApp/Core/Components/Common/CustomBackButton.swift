//
//  BackButton.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation
import SwiftUI

// MARK: - CustomBackButton Component
struct CustomBackButton: View {
    let action: () -> Void
    var iconName: String = "chevron.left"
    var iconColor: Color = .white
    var size: CGFloat = 40
    var backgroundOpacity: Double = 0.15
    var strokeOpacity: Double = 0.6
    var shadowOpacity: Double = 0.1
    var shadowRadius: CGFloat = 10
    var shadowOffset: CGPoint = CGPoint(x: 0, y: 5)
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(iconColor)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(Color.white.opacity(backgroundOpacity))
                        .background(.ultraThinMaterial, in: Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(strokeOpacity),
                                            Color.white.opacity(strokeOpacity * 0.33)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
                .shadow(
                    color: Color.black.opacity(shadowOpacity),
                    radius: shadowRadius,
                    x: shadowOffset.x,
                    y: shadowOffset.y
                )
        }
    }
}
