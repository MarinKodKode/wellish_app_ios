//
//  ExcerciseModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 11/08/25.
//

import SwiftUI

struct ActivityData {
    let steps: Int
    let time: (hours: Int, minutes: Int)
    let caloriesData: [CalorieData]
}

struct CalorieData {
    let day: String
    let calories: Int
}

struct WorkoutPlan {
    let id = UUID()
    let name: String
    let level: String
    let reps: String
    let duration: String
    let imageURL: String
    let progress: Double
}

struct ActivityHistoryItem {
    let id = UUID()
    let name: String
    let date: String
    let time: String
    let calories: Int
    let duration: String
    let sets: Int
}

struct WorkoutSession {
    let name: String
    let currentTime: Double
    let totalTime: Double
    let calories: Int
    let duration: Int
    let reps: String
}

// MARK: - Data Models
struct WorkoutChallenge {
    let steps: Int
    let isActive: Bool
}

struct WorkoutItem {
    let id = UUID()
    let name: String
    let imageURL: String
    let tutorials: Int
    let duration: Int
}



