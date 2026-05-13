//
//  OnBoardingState.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//


import SwiftUI
import Combine
import Foundation

struct OnboardingState {
    let hasCompleted: Bool
    let completedDate: Date?
    let completedVersion: String?
    
    static let initial = OnboardingState(
        hasCompleted: false,
        completedDate: nil,
        completedVersion: nil
    )
}
