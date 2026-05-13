//
//  SystemColor.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 29/07/25.
//

import Foundation
import UIKit
import SwiftUI

enum SystemColor : String {
    case clear
    case black
}

// MARK: - Helper Functions
public func levelColor(for level: String) -> Color {
    switch level.lowercased() {
    case "beginner":
        return .fitnessSuccess
    case "intermediate":
        return .fitnessWarning
    case "advanced":
        return .fitnessError
    default:
        return .fitnessInfo
    }
}

public func progressColor(for progress: Double) -> Color {
    switch progress {
    case 0.0..<0.3:
        return .fitnessError
    case 0.3..<0.7:
        return .fitnessWarning
    default:
        return .fitnessSuccess
    }
}
