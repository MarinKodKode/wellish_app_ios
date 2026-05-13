//
//  ActivityPerformanceModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import Foundation
import FirebaseFirestore

// MARK: - Protocol

public protocol ActivityPerformance: Identifiable, Codable, Hashable {
    
    /// ID único del performance
    var id: String { get }
    
    /// Referencia al PlanElement asociado (puede ser nil si fue actividad libre)
    var planElementId: String? { get set }
    
    /// Tipo de actividad
    var activityCategory: ActivityCategory { get }
    
    /// Timestamp de inicio de la sesión
    var startedAt: Date { get set }
    
    /// Timestamp de finalización de la sesión
    var completedAt: Date? { get set }
    
    /// Duración real en minutos
    var actualDurationMinutes: Int? { get set }
    
    /// Calorías reales quemadas
    var actualCalories: Int? { get set }
    
    /// Rate of Perceived Exertion (1-10)
    var rpe: Int? { get set }
    
    /// Notas sobre el rendimiento
    var notes: String? { get set }
    
    /// Indica si la sesión fue completada
    var isCompleted: Bool { get }
    
    /// Usuario que realizó la actividad
    var userId: String? { get set }
    
    // MARK: - Serialization
    
    func toDictionary() -> [String: Any]
}

// MARK: - Default Implementations

extension ActivityPerformance {
    
    public var isCompleted: Bool {
        completedAt != nil
    }
    
    public var formattedDuration: String {
        guard let duration = actualDurationMinutes else { return "N/A" }
        if duration < 60 {
            return "\(duration) min"
        } else {
            let hours = duration / 60
            let minutes = duration % 60
            return minutes > 0 ? "\(hours)h \(minutes)m" : "\(hours)h"
        }
    }
    
    public var formattedCalories: String {
        guard let calories = actualCalories else { return "N/A" }
        return "\(calories) kcal"
    }
    
    public var formattedRPE: String {
        guard let rpe = rpe else { return "N/A" }
        return "\(rpe)/10"
    }
    
    public var rpeEmoji: String? {
        guard let rpe = rpe else { return nil }
        switch rpe {
        case 1...3: return "😌" // Fácil
        case 4...6: return "💪" // Moderado
        case 7...8: return "😰" // Difícil
        case 9...10: return "🔥" // Muy difícil
        default: return nil
        }
    }
    
    public var sessionDuration: TimeInterval? {
        guard let completedAt = completedAt else { return nil }
        return completedAt.timeIntervalSince(startedAt)
    }
    
    public var formattedStartTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: startedAt)
    }
}

// MARK: - Errors

public enum ActivityPerformanceError: LocalizedError {
    case invalidData
    case missingRequiredField(String)
    case invalidRPE
    case sessionNotCompleted
    
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Los datos del performance son inválidos"
        case .missingRequiredField(let field):
            return "Falta el campo requerido: \(field)"
        case .invalidRPE:
            return "El RPE debe estar entre 1 y 10"
        case .sessionNotCompleted:
            return "La sesión aún no ha sido completada"
        }
    }
}
