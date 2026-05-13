//
//  DifficultyModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import Foundation
import SwiftUI

enum Difficulty: String, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

extension Difficulty {
    var color: Color {
        switch self {
        case .beginner: .fitnessSuccess
        case .intermediate: .energyFitnessOrange
        case .advanced: .errorFitnessRed
        }
    }
}
