//
//  CoverBackground.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 20/11/25.
//

import Foundation
import SwiftUI


public enum ChallengeCoverBackground: String, Codable, CaseIterable {
    case stepsBlue         = "stepsBlue"
    case waterTeal         = "waterTeal"
    case workoutPurple     = "workoutPurple"
    case sleepIndigo       = "sleepIndigo"
    case mindfulGreen      = "mindfulGreen"
    case sunriseOrange     = "sunriseOrange"
    case fireRed           = "fireRed"
    case coolMint          = "coolMint"
    case deepOcean         = "deepOcean"
    case dustyRose         = "dustyRose"
    case vibrantMagenta    = "vibrantMagenta"
    case forestGold        = "forestGold"
    case graphite          = "graphite"
    case royalPurple       = "royalPurple"
    case electricLime      = "electricLime"

    public var colors: [Color] {
        switch self {
        case .stepsBlue:
            return [
                Color(red: 0.1, green: 0.2, blue: 0.4),
                Color(red: 0.2, green: 0.3, blue: 0.6)
            ]
        case .waterTeal:
            return [
                Color(red: 0.1, green: 0.3, blue: 0.4),
                Color(red: 0.2, green: 0.4, blue: 0.5)
            ]
        case .workoutPurple:
            return [
                Color(red: 0.3, green: 0.1, blue: 0.4),
                Color(red: 0.5, green: 0.2, blue: 0.6)
            ]
        case .sleepIndigo:
            return [
                Color(red: 0.2, green: 0.1, blue: 0.3),
                Color(red: 0.3, green: 0.2, blue: 0.5)
            ]
        case .mindfulGreen:
            return [
                Color(red: 0.1, green: 0.3, blue: 0.2),
                Color(red: 0.2, green: 0.4, blue: 0.3)
            ]
        
        case .sunriseOrange:
            return [
                Color(red: 0.9, green: 0.4, blue: 0.2),
                Color(red: 1.0, green: 0.6, blue: 0.0)
            ]
        case .fireRed:
            return [
                Color(red: 0.6, green: 0.1, blue: 0.1),
                Color(red: 0.9, green: 0.2, blue: 0.2)
            ]
        case .coolMint:
            return [
                Color(red: 0.4, green: 0.8, blue: 0.7),
                Color(red: 0.7, green: 0.9, blue: 0.8)
            ]
        case .deepOcean:
            return [
                Color(red: 0.0, green: 0.15, blue: 0.3),
                Color(red: 0.1, green: 0.3, blue: 0.5)
            ]
        case .dustyRose:
            return [
                Color(red: 0.7, green: 0.5, blue: 0.55),
                Color(red: 0.8, green: 0.7, blue: 0.75)
            ]
        case .vibrantMagenta:
            return [
                Color(red: 0.7, green: 0.0, blue: 0.7),
                Color(red: 0.9, green: 0.2, blue: 0.9)
            ]
        case .forestGold:
            return [
                Color(red: 0.2, green: 0.4, blue: 0.1),
                Color(red: 0.5, green: 0.7, blue: 0.3)
            ]
        case .graphite:
            return [
                Color(red: 0.2, green: 0.2, blue: 0.2),
                Color(red: 0.4, green: 0.4, blue: 0.4)
            ]
        case .royalPurple:
            return [
                Color(red: 0.4, green: 0.0, blue: 0.6),
                Color(red: 0.6, green: 0.2, blue: 0.8)
            ]
        case .electricLime:
            return [
                Color(red: 0.5, green: 1.0, blue: 0.0),
                Color(red: 0.8, green: 1.0, blue: 0.5)
            ]
        }
    }
}
