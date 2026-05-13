//
//  UIColor+Extension.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/08/25.
//

import Foundation
import UIKit
import SwiftUI

extension UIColor {
    
    // MARK: - Primary Colors
    static let primaryFitnessBlue = UIColor(named: "PrimaryBlue")!
    static let fitnessSuccess = UIColor(named: "SuccessGreen")!
    static let energyFitnessOrange = UIColor(named: "EnergyOrange")!
    static let errorFitnessRed = UIColor(named: "ErrorRed")!
    static let premiumFitnessPurple = UIColor(named: "PremiumPurple")!
    static let infoFitnessCyan = UIColor(named: "InfoCyan")!
    
    // MARK: - Text Colors
    static let fitnessTextPrimary = UIColor(named: "PrimaryText")!
    static let fitnessTextSecondary = UIColor(named: "SecondaryText")!
    
    // MARK: - Background Colors
    static let fitnessBackgroundPrimary = UIColor(named: "BackgroundPrimary")!
    static let fitnessBackgroundSecondary = UIColor(named: "BackgroundSecondary")!
    
    // MARK: - Semantic Colors
    static let fitnessProgress = UIColor.successGreen
    static let fitnessWarning = UIColor.energyOrange
    static let fitnessError = UIColor.errorRed
    static let fitnessPrimary = UIColor.primaryBlue
    static let fitnessInfo = UIColor.infoCyan
    static let fitnessPremium = UIColor.premiumPurple
}

extension Color {
    
    // MARK: - Primary Colors
    static let primaryFitnessBlue = Color("PrimaryBlue")
    static let fitnessSuccess = Color("SuccessGreen")
    static let energyFitnessOrange = Color("EnergyOrange")
    static let errorFitnessRed = Color("ErrorRed")
    static let premiumFitnessPurple = Color("PremiumPurple")
    static let infoFitnessCyan = Color("InfoCyan")
    
    // MARK: - Text Colors
    static let fitnessTextPrimary = Color("PrimaryText")
    static let fitnessTextSecondary = Color("SecondaryText")
    
    // MARK: - Background Colors
    static let fitnessBackgroundPrimary = Color("BackgroundPrimary")
    static let fitnessBackgroundSecondary = Color("BackgroundSecondary")
    static let fitnessBackgroundDark = Color("BackgroundDark")
    
    // MARK: - Semantic Colors
    static let fitnessProgress = Color.successGreen
    static let fitnessWarning = Color.energyOrange
    static let fitnessError = Color.errorRed
    static let fitnessPrimary = Color.primaryBlue
    static let fitnessInfo = Color.infoCyan
    static let fitnessPremium = Color.premiumPurple
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
