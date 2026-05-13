//
//  PlanElement.swift
//  Wellish
//
//  Elemento de un plan de entrenamiento
//  Ahora usa ActivityType en vez de PlanActivity
//

import Foundation
import FirebaseFirestore

public struct PlanElement: Identifiable, Codable, Hashable {
    
    // MARK: - Core Properties
    
    public let id: String
    
    /// Actividad asociada a este elemento (usa el nuevo ActivityType)
    public var activity: ActivityType
    
    /// Día del plan (1-based)
    public var day: Int
    
    /// Hora programada (opcional)
    public var scheduledTime: Date?
    
    // MARK: - Completion Tracking
    
    /// Indica si el elemento fue completado
    public var completed: Bool
    
    /// Fecha y hora de completación
    public var completedAt: Date?
    
    // MARK: - Performance Tracking (Métricas Reales)
    
    /// Duración real en minutos
    public var actualDurationMinutes: Int?
    
    /// Distancia real en km (para cardio)
    public var actualDistanceKm: Double?
    
    /// Calorías reales quemadas
    public var actualCalories: Int?
    
    /// Rate of Perceived Exertion (1-10)
    public var rpe: Int?
    
    /// Notas sobre el rendimiento
    public var performanceNotes: String?
    
    // MARK: - Context
    
    /// Notas adicionales del usuario
    public var notes: String?
    
    //Parallax Element
    public var imageURL: String?
    
    // MARK: - Init
    
    public init(
        id: String = UUID().uuidString,
        activity: ActivityType,
        day: Int,
        scheduledTime: Date? = nil,
        completed: Bool = false,
        completedAt: Date? = nil,
        actualDurationMinutes: Int? = nil,
        actualDistanceKm: Double? = nil,
        actualCalories: Int? = nil,
        rpe: Int? = nil,
        performanceNotes: String? = nil,
        notes: String? = nil,
        imageURL : String? = nil
    ) {
        self.id = id
        self.activity = activity
        self.day = day
        self.scheduledTime = scheduledTime
        self.completed = completed
        self.completedAt = completedAt
        self.actualDurationMinutes = actualDurationMinutes
        self.actualDistanceKm = actualDistanceKm
        self.actualCalories = actualCalories
        self.rpe = rpe
        self.performanceNotes = performanceNotes
        self.notes = notes
        self.imageURL = imageURL
    }
    
    // MARK: - Computed Properties (Delegados a Activity)
    
    /// Nombre a mostrar
    public var displayName: String {
        activity.displayName
    }
    
    /// Categoría
    public var activityCategory: ActivityCategory {
        activity.category
    }
    
    /// Categoría como string
    public var activityCategoryString: String {
        activity.categoryString
    }
    
    /// Icono SF Symbol
    public var icon: String {
        activity.icon
    }
    
    /// Color hexadecimal
    public var colorHex: String {
        activity.colorHex
    }
    
    /// Descripción de la actividad
    public var activityDescription: String? {
        activity.description
    }
    
    /// Tags de la actividad
    public var activityTags: [String] {
        activity.tags
    }
    
    // MARK: - Performance Comparison (Esperado vs Real)
    
    /// Duración esperada (del modelo base)
    public var expectedDuration: Int? {
        activity.estimatedDuration
    }
    
    /// Calorías esperadas (del modelo base)
    public var expectedCalories: Int? {
        activity.estimatedCalories
    }
    
    /// Ratio de rendimiento de duración (real / esperado)
    public var durationPerformanceRatio: Double? {
        guard let actual = actualDurationMinutes,
              let expected = expectedDuration,
              expected > 0 else { return nil }
        return Double(actual) / Double(expected)
    }
    
    /// Diferencia en calorías (real - esperado)
    public var caloriesVariance: Int? {
        guard let actual = actualCalories,
              let expected = expectedCalories else { return nil }
        return actual - expected
    }
    
    /// Indicador de sobre/bajo rendimiento en duración
    public var durationPerformanceStatus: PerformanceStatus? {
        guard let ratio = durationPerformanceRatio else { return nil }
        if ratio < 0.9 { return .underPerformed }
        if ratio > 1.1 { return .overPerformed }
        return .onTarget
    }
    
    /// Indicador de sobre/bajo rendimiento en calorías
    public var caloriesPerformanceStatus: PerformanceStatus? {
        guard let variance = caloriesVariance,
              let expected = expectedCalories,
              expected > 0 else { return nil }
        let ratio = Double(abs(variance)) / Double(expected)
        if variance < 0 && ratio > 0.1 { return .underPerformed }
        if variance > 0 && ratio > 0.1 { return .overPerformed }
        return .onTarget
    }
    
    // MARK: - Formatting Helpers
    
    /// Formato de día
    public var formattedDay: String {
        "Día \(day)"
    }
    
    /// Hora formateada
    public var formattedTime: String? {
        guard let scheduledTime = scheduledTime else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: scheduledTime)
    }
    
    /// Fecha completa formateada (día + hora)
    public var formattedSchedule: String {
        var result = formattedDay
        if let time = formattedTime {
            result += " a las \(time)"
        }
        return result
    }
    
    /// Resumen de rendimiento (si está completado)
    public var performanceSummary: String? {
        guard completed else { return nil }
        
        var parts: [String] = []
        
        if let duration = actualDurationMinutes {
            parts.append("\(duration) min")
        }
        
        if let distance = actualDistanceKm {
            parts.append(String(format: "%.1f km", distance))
        }
        
        if let calories = actualCalories {
            parts.append("\(calories) kcal")
        }
        
        if let rpe = rpe {
            parts.append("RPE \(rpe)/10")
        }
        
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
    
    /// Resumen de comparación (esperado vs real)
    public var comparisonSummary: String? {
        guard completed else { return nil }
        
        var parts: [String] = []
        
        if let ratio = durationPerformanceRatio, let expected = expectedDuration {
            let actual = actualDurationMinutes ?? 0
            let diff = actual - expected
            if diff != 0 {
                parts.append("Duración: \(diff > 0 ? "+" : "")\(diff) min")
            }
        }
        
        if let variance = caloriesVariance, variance != 0 {
            parts.append("Calorías: \(variance > 0 ? "+" : "")\(variance) kcal")
        }
        
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
    
    /// Badge de estado del rendimiento
    public var performanceBadge: String? {
        guard completed else { return nil }
        
        if let status = durationPerformanceStatus {
            switch status {
            case .underPerformed: return "⚠️"
            case .onTarget: return "✅"
            case .overPerformed: return "🔥"
            }
        }
        
        return nil
    }
    
    /// Resumen completo para UI
    public var fullSummary: String {
        var lines: [String] = [displayName]
        
        if let desc = activityDescription {
            lines.append(desc)
        }
        
        lines.append(formattedSchedule)
        
        if completed, let performance = performanceSummary {
            lines.append("Completado: \(performance)")
            
            if let comparison = comparisonSummary {
                lines.append(comparison)
            }
        } else {
            // Mostrar métricas esperadas
            var expected: [String] = []
            if let duration = expectedDuration {
                expected.append("\(duration) min")
            }
            if let calories = expectedCalories {
                expected.append("\(calories) kcal")
            }
            if !expected.isEmpty {
                lines.append("Estimado: \(expected.joined(separator: " · "))")
            }
        }
        
        return lines.joined(separator: "\n")
    }
    
    // MARK: - Methods
    
    /// Marcar como completado con datos de rendimiento
    public mutating func markCompleted(
        durationMinutes: Int? = nil,
        distanceKm: Double? = nil,
        calories: Int? = nil,
        rpe: Int? = nil,
        performanceNotes: String? = nil
    ) {
        self.completed = true
        self.completedAt = Date()
        self.actualDurationMinutes = durationMinutes
        self.actualDistanceKm = distanceKm
        self.actualCalories = calories
        self.rpe = rpe
        self.performanceNotes = performanceNotes
    }
    
    /// Resetear completación y datos de rendimiento
    public mutating func resetCompletion() {
        self.completed = false
        self.completedAt = nil
        self.actualDurationMinutes = nil
        self.actualDistanceKm = nil
        self.actualCalories = nil
        self.rpe = nil
        self.performanceNotes = nil
    }
    
    /// Validar y setear RPE (debe estar entre 1 y 10)
    public mutating func setRPE(_ value: Int) {
        self.rpe = max(1, min(10, value))
    }
    
    /// Actualizar la actividad subyacente
    public mutating func updateActivity(_ newActivity: ActivityType) {
        self.activity = newActivity
    }
    
    // MARK: - Type Checking Helpers
    
    /// Indica si es una actividad de cardio
    public var isCardioActivity: Bool {
        activity.isCardio
    }
    
    /// Indica si es una actividad de fuerza
    public var isStrengthActivity: Bool {
        activity.isStrength
    }
    
    /// Indica si es descanso
    public var isRestActivity: Bool {
        activity.isRest
    }
    
    // MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
        case id
        case activity
        case day
        case scheduledTime
        case completed
        case completedAt
        case actualDurationMinutes
        case actualDistanceKm
        case actualCalories
        case rpe
        case performanceNotes
        case notes
    }
    
    // MARK: - Firestore Serialization
    
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "activity": activity.toDictionary(), // Usa serialización de ActivityType
            "day": day,
            "completed": completed
        ]
        
        if let scheduledTime = scheduledTime {
            dict["scheduledTime"] = Timestamp(date: scheduledTime)
        }
        
        if let completedAt = completedAt {
            dict["completedAt"] = Timestamp(date: completedAt)
        }
        
        if let actualDurationMinutes = actualDurationMinutes {
            dict["actualDurationMinutes"] = actualDurationMinutes
        }
        
        if let actualDistanceKm = actualDistanceKm {
            dict["actualDistanceKm"] = actualDistanceKm
        }
        
        if let actualCalories = actualCalories {
            dict["actualCalories"] = actualCalories
        }
        
        if let rpe = rpe {
            dict["rpe"] = rpe
        }
        
        if let performanceNotes = performanceNotes {
            dict["performanceNotes"] = performanceNotes
        }
        
        if let notes = notes {
            dict["notes"] = notes
        }
        
        return dict
    }
    
    /// Crea un PlanElement desde un diccionario de Firestore
    public static func fromDictionary(_ dict: [String: Any]) throws -> PlanElement {
        guard let id = dict["id"] as? String,
              let activityDict = dict["activity"] as? [String: Any],
              let day = dict["day"] as? Int,
              let completed = dict["completed"] as? Bool else {
            throw PlanElementError.invalidData
        }
        
        // Deserializar la actividad usando ActivityType
        let activity = try ActivityType.fromDictionary(activityDict)
        
        // Convertir Timestamps a Date
        let scheduledTime = (dict["scheduledTime"] as? Timestamp)?.date
        let completedAt = (dict["completedAt"] as? Timestamp)?.date
        
        return PlanElement(
            id: id,
            activity: activity,
            day: day,
            scheduledTime: scheduledTime,
            completed: completed,
            completedAt: completedAt,
            actualDurationMinutes: dict["actualDurationMinutes"] as? Int,
            actualDistanceKm: dict["actualDistanceKm"] as? Double,
            actualCalories: dict["actualCalories"] as? Int,
            rpe: dict["rpe"] as? Int,
            performanceNotes: dict["performanceNotes"] as? String,
            notes: dict["notes"] as? String,
            imageURL: dict["imageURL"] as? String
        )
    }
}

// MARK: - Errors

public enum PlanElementError: LocalizedError {
    case invalidData
    case missingRequiredField(String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Los datos del elemento del plan son inválidos"
        case .missingRequiredField(let field):
            return "Falta el campo requerido: \(field)"
        }
    }
}
