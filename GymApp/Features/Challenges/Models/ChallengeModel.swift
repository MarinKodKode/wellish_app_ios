//
//  ChallengeModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/11/25.
//


import Foundation
import SwiftUI

// MARK: - Challenge Protocol

public protocol Challenge: Identifiable, Codable, Hashable, Decodable {
    var id: String { get }
    var title: String { get }
    var subtitle: String { get }
    var icon: String { get }
    var colorHex: String { get }
    var currentValue: Int { get set }
    var goalValue: Int { get }
    var unit: String { get }
    var period: ChallengePeriod { get }
    var startDate: Date { get }
    var lastUpdated: Date { get set }
    var isCompleted: Bool { get }
    var progress: Double { get }
    var coverBackground: ChallengeCoverBackground { get set }
    var colors : [Color] { get }
    mutating func increment(by value: Int)
    mutating func decrement(by value: Int)
    mutating func reset()
}

// MARK: - Challenge Period

public enum ChallengePeriod: String, Codable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    
    var displayName: String {
        switch self {
        case .daily: return "Diario"
        case .weekly: return "Semanal"
        case .monthly: return "Mensual"
        }
    }
    
    var daysCount: Int {
        switch self {
        case .daily: return 1
        case .weekly: return 7
        case .monthly: return 30
        }
    }
}

// MARK: - Challenge Type Enum

public enum ChallengeType: String, Codable {
    case steps
    case water
    case workout
    case sleep
    case calories
    
    var defaultIcon: String {
        switch self {
        case .steps: return "figure.walk"
        case .water: return "drop.fill"
        case .workout: return "flame.fill"
        case .sleep: return "moon.fill"
        case .calories: return "fork.knife"
        }
    }
    
    var defaultColor: String {
        switch self {
        case .steps: return "4A90E2"
        case .water: return "5B9AA0"
        case .workout: return "9B59B6"
        case .sleep: return "34495E"
        case .calories: return "E67E22"
        }
    }
}

// MARK: - Base Challenge Implementation

public struct BaseChallenge: Challenge {
    public let id: String
    public var title: String
    public var subtitle: String
    public var icon: String
    public var colorHex: String
    public var currentValue: Int
    public var goalValue: Int
    public var unit: String
    public var period: ChallengePeriod
    public var startDate: Date
    public var lastUpdated: Date
    public var type: ChallengeType
    public var imageUrl : String?
    public var coverBackground : ChallengeCoverBackground
    
    public var isCompleted: Bool {
        currentValue >= goalValue
    }
    
    public var progress: Double {
        guard goalValue > 0 else { return 0 }
        return min(Double(currentValue) / Double(goalValue), 1.0)
    }
    
    public var progressPercentage: Int {
        Int(progress * 100)
    }
    
    public var remainingValue: Int {
        max(goalValue - currentValue, 0)
    }
    
    public var color: Color {
        Color(hex: colorHex) ?? .blue
    }
    
    public var colors: [Color] {
        return coverBackground.colors
    }
    
    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        icon: String,
        colorHex: String,
        currentValue: Int = 0,
        goalValue: Int,
        unit: String,
        period: ChallengePeriod,
        startDate: Date = Date(),
        lastUpdated: Date = Date(),
        type: ChallengeType,
        imageUrl : String?,
        coverColors : ChallengeCoverBackground
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.colorHex = colorHex
        self.currentValue = currentValue
        self.goalValue = goalValue
        self.unit = unit
        self.period = period
        self.startDate = startDate
        self.lastUpdated = lastUpdated
        self.type = type
        self.imageUrl = imageUrl
        self.coverBackground = coverColors
    }
    
    public mutating func increment(by value: Int = 1) {
        currentValue = min(currentValue + value, goalValue * 2) // Max 200% para no romper UI
        lastUpdated = Date()
    }
    
    public mutating func decrement(by value: Int = 1) {
        currentValue = max(currentValue - value, 0)
        lastUpdated = Date()
    }
    
    public mutating func reset() {
        currentValue = 0
        lastUpdated = Date()
    }
    
    public mutating func setValue(_ value: Int) {
        currentValue = max(0, min(value, goalValue * 2))
        lastUpdated = Date()
    }
}

// MARK: - Challenge History Entry

public struct ChallengeHistoryEntry: Identifiable, Codable {
    public let id: String
    public let challengeId: String
    public let date: Date
    public let value: Int
    public let goalValue: Int
    public let completed: Bool
    
    public init(
        id: String = UUID().uuidString,
        challengeId: String,
        date: Date = Date(),
        value: Int,
        goalValue: Int,
        completed: Bool
    ) {
        self.id = id
        self.challengeId = challengeId
        self.date = date
        self.value = value
        self.goalValue = goalValue
        self.completed = completed
    }
    
    public var progress: Double {
        guard goalValue > 0 else { return 0 }
        return min(Double(value) / Double(goalValue), 1.0)
    }
}

// MARK: - Predefined Challenges

extension BaseChallenge {
    
    public static func stepsChallenge(goal: Int = 10000) -> BaseChallenge {
        BaseChallenge(
            title: "Daily Steps Challenge",
            subtitle: "Step Into Fitness!",
            icon: "figure.walk",
            colorHex: "4A90E2",
            goalValue: goal,
            unit: "Steps",
            period: .daily,
            type: .steps,
            imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=200&fit=crop&crop=faces",
            coverColors: .stepsBlue
        )
    }
    
    public static func waterChallenge(goal: Int = 8) -> BaseChallenge {
        BaseChallenge(
            title: "Daily Water Challenge",
            subtitle: "Hydration Hero",
            icon: "drop.fill",
            colorHex: "5B9AA0",
            goalValue: goal,
            unit: "Glasses",
            period: .daily,
            type: .water,
            imageUrl: "https://images.unsplash.com/photo-1520206183501-b80df61043c2?w=200&h=200&fit=crop",
            coverColors: .coolMint
        )
    }
    
    public static func workoutStreakChallenge(goal: Int = 7) -> BaseChallenge {
        BaseChallenge(
            title: "7-Day Workout Streak",
            subtitle: "Streak Master",
            icon: "flame.fill",
            colorHex: "9B59B6",
            goalValue: goal,
            unit: "Days",
            period: .weekly,
            type: .workout,
            imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=200&fit=crop&crop=faces",
            coverColors: .graphite
        )
    }
    
    public static func sleepChallenge(goal: Int = 8) -> BaseChallenge {
        BaseChallenge(
            title: "Sleep Goal",
            subtitle: "Rest & Recover",
            icon: "moon.fill",
            colorHex: "34495E",
            goalValue: goal,
            unit: "Hours",
            period: .daily,
            type: .sleep,
            imageUrl: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=200&h=200&fit=crop",
            coverColors: .royalPurple
        )
    }
    
    public static func caloriesChallenge(goal: Int = 2000) -> BaseChallenge {
        BaseChallenge(
            title: "Calorie Burn Goal",
            subtitle: "Burn It Up!",
            icon: "flame.circle.fill",
            colorHex: "E67E22",
            goalValue: goal,
            unit: "kcal",
            period: .daily,
            type: .calories,
            imageUrl: "https://images.unsplash.com/photo-1534258936925-c58bed479fcb?w=200&h=200&fit=crop",
            coverColors: .forestGold
        )
    }
}

