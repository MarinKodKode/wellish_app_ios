//
//  CardioActivity.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/10/25.
//

import Foundation

extension PlanActivity {
    public struct CardioActivity: Codable, Hashable {
        public let id: String
        public var type: CardioType
        public var targetDistanceKm: Double?
        public var targetDurationMinutes: Int?
        public var targetPace: String?
        public var intensity: CardioIntensity?
        public var estimatedCalories: Int?
        public var notes: String?
        
        public init(
            id: String = UUID().uuidString,
            type: CardioType,
            targetDistanceKm: Double? = nil,
            targetDurationMinutes: Int? = nil,
            targetPace: String? = nil,
            intensity: CardioIntensity? = nil,
            estimatedCalories: Int? = nil,
            notes: String? = nil
        ) {
            self.id = id
            self.type = type
            self.targetDistanceKm = targetDistanceKm
            self.targetDurationMinutes = targetDurationMinutes
            self.targetPace = targetPace
            self.intensity = intensity
            self.estimatedCalories = estimatedCalories
            self.notes = notes
        }
    }

    public enum CardioType: String, Codable, CaseIterable {
        case running = "Correr"
        case cycling = "Ciclismo"
        case swimming = "Natación"
        case walking = "Caminar"
        case hiking = "Senderismo"
        case rowing = "Remo"
        case elliptical = "Elíptica"
        case stairClimber = "Escaladora"
        case jumpRope = "Saltar cuerda"
        case other = "Otro"
    }

    public enum CardioIntensity: String, Codable {
        case low = "Baja"
        case moderate = "Moderada"
        case high = "Alta"
        case interval = "Intervalos"
    }
}

