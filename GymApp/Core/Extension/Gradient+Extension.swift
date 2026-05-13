//
//  Gradient+Extension.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marin on 21/09/25.
//
/*
 // Use pre-defined gradients
 .background(LinearGradient.homeWorkout)

 // Create custom gradient from base color
 .background(LinearGradient.customGradient(
     baseColor: .blue,
     direction: .topLeadingToBottomTrailing
 ))

 // Full custom control
 .background(
     LinearGradient(
         colors: [.purple, .pink, .orange],
         startPoint: .top,
         endPoint: .bottom
     )
 )
 */

import Foundation
import SwiftUI

extension LinearGradient {
    static let homeWorkout = LinearGradient(
        colors: [
            Color(red: 0.4, green: 0.2, blue: 0.8), // Purple
            Color(red: 0.2, green: 0.8, blue: 0.4)  // Green
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let outdoorRunning = LinearGradient(
        colors: [
            Color(red: 0.3, green: 0.4, blue: 0.9),
            Color(red: 0.6, green: 0.3, blue: 0.8),
            Color(red: 0.4, green: 0.8, blue: 0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static func customGradient(
        baseColor: Color,
        direction: GradientDirection = .topLeadingToBottomTrailing
    ) -> LinearGradient {
        let vibrantColors = generateVibrantColors(from: baseColor)
        
        return LinearGradient(
            colors: vibrantColors,
            startPoint: direction.startPoint,
            endPoint: direction.endPoint
        )
    }
    
    static func generateVibrantColors(from baseColor: Color) -> [Color] {
        let colors: [Color] = [
            baseColor.opacity(0.8),
            baseColor,
            adjustBrightness(color: baseColor, amount: 0.3),
            adjustHue(color: baseColor, amount: 60) // Shift hue by 60 degrees
        ]
        
        return colors
    }
    
    static func adjustBrightness(color: Color, amount: Double) -> Color {
        // This is a simplified implementation
        return color.opacity(1.0 + amount)
    }
    
    static func adjustHue(color: Color, amount: Double) -> Color {
        return color
    }
}

enum GradientDirection {
    case topToBottom
    case leftToRight
    case topLeadingToBottomTrailing
    case topTrailingToBottomLeading
    case bottomToTop
    case rightToLeft
    case bottomTrailingToTopLeading
    case bottomLeadingToTopTrailing
    
    var startPoint: UnitPoint {
        switch self {
        case .topToBottom: return .top
        case .leftToRight: return .leading
        case .topLeadingToBottomTrailing: return .topLeading
        case .topTrailingToBottomLeading: return .topTrailing
        case .bottomToTop: return .bottom
        case .rightToLeft: return .trailing
        case .bottomTrailingToTopLeading: return .bottomTrailing
        case .bottomLeadingToTopTrailing: return .bottomLeading
        }
    }
    
    var endPoint: UnitPoint {
        switch self {
        case .topToBottom: return .bottom
        case .leftToRight: return .trailing
        case .topLeadingToBottomTrailing: return .bottomTrailing
        case .topTrailingToBottomLeading: return .bottomLeading
        case .bottomToTop: return .top
        case .rightToLeft: return .leading
        case .bottomTrailingToTopLeading: return .topLeading
        case .bottomLeadingToTopTrailing: return .topTrailing
        }
    }
}


