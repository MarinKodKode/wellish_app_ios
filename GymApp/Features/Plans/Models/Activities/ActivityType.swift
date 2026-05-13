//
//  ActivityType.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 20/10/25.
//

import Foundation

public enum ActivityType: Codable, Hashable, Identifiable {
    
    case gym(GymActivity)
    case running(RunningActivity)
    case cycling(CyclingActivity)
    case swimming(SwimmingActivity)
    case walking(WalkingActivity)
    case rest(RestActivity)
    // Fácil agregar nuevos tipos:
    // case yoga(YogaActivity)
    // case pilates(PilatesActivity)
    // case hiking(HikingActivity)
    
    // MARK: - Identifiable
    
    public var id: String {
        switch self {
        case .gym(let activity):
            return "gym-\(activity.id)"
        case .running(let activity):
            return "running-\(activity.id)"
        case .cycling(let activity):
            return "cycling-\(activity.id)"
        case .swimming(let activity):
            return "swimming-\(activity.id)"
        case .walking(let activity):
            return "walking-\(activity.id)"
        case .rest(let activity):
            return "rest-\(activity.id)"
        }
    }
    
    // MARK: - Access to Underlying Activity
    
    /// Retorna el modelo subyacente como protocol Activity
    public var activity: any Activity {
        switch self {
        case .gym(let activity): return activity
        case .running(let activity): return activity
        case .cycling(let activity): return activity
        case .swimming(let activity): return activity
        case .walking(let activity): return activity
        case .rest(let activity): return activity
        }
    }
    
    // MARK: - Common Properties (Delegados al modelo subyacente)
    
    /// Nombre de la actividad
    public var displayName: String {
        activity.name
    }
    
    /// Categoría de la actividad
    public var category: ActivityCategory {
        activity.activityType
    }
    
    /// Categoría como string
    public var categoryString: String {
        activity.activityType.rawValue
    }
    
    /// Duración estimada en minutos
    public var estimatedDuration: Int? {
        activity.estimatedDuration
    }
    
    /// Calorías estimadas
    public var estimatedCalories: Int? {
        activity.estimatedCalories
    }
    
    /// Descripción de la actividad
    public var description: String? {
        activity.description
    }
    
    /// Icono SF Symbol
    public var icon: String {
        activity.icon
    }
    
    /// Color en formato hexadecimal
    public var colorHex: String {
        activity.colorHex
    }
    
    /// Tags asociados
    public var tags: [String] {
        activity.tags
    }
    
    /// Indica si es compartible
    public var shareable: Bool {
        activity.shareable
    }
    
    /// Indica si es contenido de club
    public var isClubContent: Bool {
        activity.isClubContent
    }
    
    public var imageURL : String? {
        activity.imageURL
    }
    
    /// Fuente de la actividad
    public var source: ActivitySource {
        activity.source
    }
    
    // MARK: - Type Checking Helpers
    
    /// Indica si es una actividad de gym
    public var isGym: Bool {
        if case .gym = self { return true }
        return false
    }
    
    /// Indica si es una actividad de cardio
    public var isCardio: Bool {
        switch self {
        case .running, .cycling, .swimming, .walking:
            return true
        default:
            return false
        }
    }
    
    /// Indica si es descanso
    public var isRest: Bool {
        if case .rest = self { return true }
        return false
    }
    
    /// Indica si es una actividad de fuerza
    public var isStrength: Bool {
        switch self {
        case .gym:
            return true
        default:
            return false
        }
    }
    
    // MARK: - Codable Implementation
    
    enum CodingKeys: String, CodingKey {
        case type
        case data
    }
    
    enum ActivityTypeKey: String, Codable {
        case gym
        case running
        case cycling
        case swimming
        case walking
        case rest
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ActivityTypeKey.self, forKey: .type)
        
        switch type {
        case .gym:
            let activity = try container.decode(GymActivity.self, forKey: .data)
            self = .gym(activity)

        case .running:
            let activity = try container.decode(RunningActivity.self, forKey: .data)
            self = .running(activity)
            
        case .cycling:
            let activity = try container.decode(CyclingActivity.self, forKey: .data)
            self = .cycling(activity)
            
        case .swimming:
            let activity = try container.decode(SwimmingActivity.self, forKey: .data)
            self = .swimming(activity)
            
        case .walking:
            let activity = try container.decode(WalkingActivity.self, forKey: .data)
            self = .walking(activity)
            
        case .rest:
            let activity = try container.decode(RestActivity.self, forKey: .data)
            self = .rest(activity)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .gym(let activity):
            try container.encode(ActivityTypeKey.gym, forKey: .type)
            try container.encode(activity, forKey: .data)
            
        case .running(let activity):
            try container.encode(ActivityTypeKey.running, forKey: .type)
            try container.encode(activity, forKey: .data)
            
        case .cycling(let activity):
            try container.encode(ActivityTypeKey.cycling, forKey: .type)
            try container.encode(activity, forKey: .data)
            
        case .swimming(let activity):
            try container.encode(ActivityTypeKey.swimming, forKey: .type)
            try container.encode(activity, forKey: .data)
            
        case .walking(let activity):
            try container.encode(ActivityTypeKey.walking, forKey: .type)
            try container.encode(activity, forKey: .data)
            
        case .rest(let activity):
            try container.encode(ActivityTypeKey.rest, forKey: .type)
            try container.encode(activity, forKey: .data)
        }
    }
    
    // MARK: - Firestore Serialization
    
    /// Convierte el ActivityType a diccionario para Firestore
    public func toDictionary() -> [String: Any] {
        var dict = activity.toDictionary()
        
        // Agregar el tipo para facilitar deserialización
        let typeKey: String
        switch self {
        case .gym: typeKey = "gym"
        case .running: typeKey = "running"
        case .cycling: typeKey = "cycling"
        case .swimming: typeKey = "swimming"
        case .walking: typeKey = "walking"
        case .rest: typeKey = "rest"
        }
        
        dict["activityTypeKey"] = typeKey
        
        return dict
    }
    
    /// Crea un ActivityType desde un diccionario de Firestore
    public static func fromDictionary(_ dict: [String: Any]) throws -> ActivityType {
        guard let typeKey = dict["activityTypeKey"] as? String else {
            throw ActivityTypeError.missingTypeKey
        }
        
        let data = try JSONSerialization.data(withJSONObject: dict)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        switch typeKey {
        case "gym":
            let activity = try decoder.decode(GymActivity.self, from: data)
            return .gym(activity)
            
//        case "exercise":
//            let activity = try decoder.decode(ExerciseActivity.self, from: data)
//            return .exercise(activity)
            
        case "running":
            let activity = try decoder.decode(RunningActivity.self, from: data)
            return .running(activity)
            
        case "cycling":
            let activity = try decoder.decode(CyclingActivity.self, from: data)
            return .cycling(activity)
            
        case "swimming":
            let activity = try decoder.decode(SwimmingActivity.self, from: data)
            return .swimming(activity)
            
        case "walking":
            let activity = try decoder.decode(WalkingActivity.self, from: data)
            return .walking(activity)
            
        case "rest":
            let activity = try decoder.decode(RestActivity.self, from: data)
            return .rest(activity)
            
        default:
            throw ActivityTypeError.unknownType(typeKey)
        }
    }
    
    // MARK: - Factory Methods
    
    /// Crea un ActivityType basado en la categoría
    public static func create(category: ActivityCategory, name: String) -> ActivityType {
        switch category {
        case .gym:
            return .gym(GymActivity(name: name))

        case .running:
            return .running(RunningActivity(name: name))
            
        case .cycling:
            return .cycling(CyclingActivity(name: name))
            
        case .swimming:
            return .swimming(SwimmingActivity(name: name))
            
        case .walking:
            return .walking(WalkingActivity(name: name))
            
        case .rest:
            return .rest(RestActivity(name: name, restType: .complete))
    
        default :
            return .gym(GymActivity(name: name))
        }
    }
}

// MARK: - Errors

public enum ActivityTypeError: LocalizedError {
    case missingTypeKey
    case unknownType(String)
    case invalidData
    
    public var errorDescription: String? {
        switch self {
        case .missingTypeKey:
            return "El diccionario no contiene la clave 'activityTypeKey'"
        case .unknownType(let type):
            return "Tipo de actividad desconocido: \(type)"
        case .invalidData:
            return "Los datos de la actividad son inválidos"
        }
    }
}

// MARK: - Convenience Extensions

extension ActivityType {
    
    /// Formatea la duración estimada
    public var formattedDuration: String {
        activity.formattedDuration
    }
    
    /// Formatea las calorías estimadas
    public var formattedCalories: String {
        activity.formattedCalories
    }
    
    /// Resumen corto para UI
    public var shortSummary: String {
        var parts: [String] = [displayName]
        
        if let duration = estimatedDuration {
            parts.append("\(duration) min")
        }
        
        if let calories = estimatedCalories {
            parts.append("\(calories) kcal")
        }
        
        return parts.joined(separator: " · ")
    }
    
    /// Resumen largo para UI
    public var longSummary: String {
        var parts: [String] = []
        
        parts.append("📍 \(categoryString)")
        
        if let duration = estimatedDuration {
            parts.append("⏱️ \(duration) min")
        }
        
        if let calories = estimatedCalories {
            parts.append("🔥 \(calories) kcal")
        }
        
        if !tags.isEmpty {
            parts.append("🏷️ \(tags.joined(separator: ", "))")
        }
        
        return parts.joined(separator: "\n")
    }
}
