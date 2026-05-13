//
//  UserProfileModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/11/25.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Identifiable, Codable {
    @DocumentID var id: String?
    
    var username: String
    var email: String
    var bio: String?
    var photoURL: String?
    var createdDate: String?
    var lastActiveDate: Date?
    var fcmTokens: [String]?

    var isPremium: Bool?
    var onboardingCompleted: Bool?
    var version: String?
    
  
    var physicalProfile: PhysicalProfile?
    var preferences: UserPreferences?
    var goals: FitnessGoal?
    var stats: UserStats?

}


struct PhysicalProfile: Codable {
    var gender: Gender
    var birthDate: Date?
    var height: Double
    var currentWeight: Double
    var bodyFatPercentage: Double?
    
    var age: Int? {
        guard let birthDate = birthDate else { return nil }
        return Calendar.current.dateComponents([.year], from: birthDate, to: Date()).year
    }
}

struct UserPreferences: Codable {
    var unitSystem: UnitSystem
    var workoutReminderTime: Date?
    var allowNotifications: Bool
    var restTimerDuration: Int
}

struct FitnessGoal: Codable {
    var primaryGoal: GoalType
    var targetWeight: Double?
    var weeklyWorkoutDays: Int
    var experienceLevel: ExperienceLevel
}

struct UserStats: Codable {
    var routinesCompleted: Int
    var workoutsCompleted: Int
    var currentStreak: Int
    var highestStreak: Int
    var totalLiftedWeight: Double
    var totalWorkoutMinutes: Int
    var formattedHours: Int {
        return totalWorkoutMinutes / 60
    }
}


enum Gender: String, Codable, CaseIterable {
    case male, female, other, preferNotToSay
}

enum UnitSystem: String, Codable {
    case metric
    case imperial
}

enum GoalType: String, Codable, CaseIterable {
    case loseWeight
    case buildMuscle
    case improveEndurance
    case keepFit
    case strengthTraining
}

enum ExperienceLevel: String, Codable, CaseIterable {
    case beginner
    case intermediate
    case advanced
}

