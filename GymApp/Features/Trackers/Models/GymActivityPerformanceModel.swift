//
//  GymActivityPerformanceModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//


import Foundation
import FirebaseFirestore

public struct GymActivityPerformance: ActivityPerformance {
    
    // MARK: - ActivityPerformance Protocol
    
    public let id: String
    public var planElementId: String?
    public var startedAt: Date
    public var completedAt: Date?
    public var actualDurationMinutes: Int?
    public var actualCalories: Int?
    public var rpe: Int?
    public var notes: String?
    public var userId: String?
    
    public var activityCategory: ActivityCategory {
        .gym
    }
    
    // MARK: - Gym-Specific Properties
    
    /// Referencia al GymActivity original (opcional)
    public var gymActivityId: String?
    
    /// Sets realmente ejecutados en la sesión
    public var performedSets: [PerformedRoutineSet]
    
    /// Volumen total levantado en kg
    public var totalVolumeKg: Double {
        performedSets.reduce(0) { $0 + $1.totalVolumeKg }
    }
    
    /// Total de series completadas
    public var totalSetsCompleted: Int {
        performedSets.reduce(0) { $0 + $1.completedSeries.count }
    }
    
    /// Total de repeticiones realizadas
    public var totalRepsCompleted: Int {
        performedSets.reduce(0) { $0 + $1.totalReps }
    }
    
    /// Promedio de peso levantado por serie
    public var averageWeightPerSet: Double {
        let totalSets = totalSetsCompleted
        guard totalSets > 0 else { return 0 }
        return totalVolumeKg / Double(totalSets)
    }
    
    // MARK: - Comparison with Planned Activity
    
    /// Comparación de volumen (si hay actividad planeada)
    public var volumeComparison: ComparisonMetric?
    
    /// Comparación de duración
    public var durationComparison: ComparisonMetric?
    
    // MARK: - Init
    
    public init(
        id: String = UUID().uuidString,
        planElementId: String? = nil,
        gymActivityId: String? = nil,
        userId: String? = nil,
        startedAt: Date = Date(),
        completedAt: Date? = nil,
        actualDurationMinutes: Int? = nil,
        actualCalories: Int? = nil,
        rpe: Int? = nil,
        notes: String? = nil,
        performedSets: [PerformedRoutineSet] = []
    ) {
        self.id = id
        self.planElementId = planElementId
        self.gymActivityId = gymActivityId
        self.userId = userId
        self.startedAt = startedAt
        self.completedAt = completedAt
        self.actualDurationMinutes = actualDurationMinutes
        self.actualCalories = actualCalories
        self.rpe = rpe
        self.notes = notes
        self.performedSets = performedSets
    }
    
    // MARK: - Methods
    
    /// Agregar un set realizado
    public mutating func addPerformedSet(_ set: PerformedRoutineSet) {
        performedSets.append(set)
    }
    
    /// Completar la sesión
    public mutating func complete(
        durationMinutes: Int? = nil,
        calories: Int? = nil,
        rpe: Int? = nil,
        notes: String? = nil
    ) {
        self.completedAt = Date()
        self.actualDurationMinutes = durationMinutes
        self.actualCalories = calories
        if let rpe = rpe {
            self.rpe = max(1, min(10, rpe))
        }
        self.notes = notes
    }
    
    /// Calcular comparaciones con la actividad planeada
    public mutating func calculateComparisons(plannedActivity: GymActivity) {
        // Comparar volumen
        let plannedVolume = plannedActivity.estimatedVolumeKg
        if plannedVolume > 0 {
            let variance = totalVolumeKg - plannedVolume
            let percentageVariance = (variance / plannedVolume) * 100
            volumeComparison = ComparisonMetric(
                planned: plannedVolume,
                actual: totalVolumeKg,
                variance: variance,
                percentageVariance: percentageVariance
            )
        }
        
        // Comparar duración
        if let plannedDuration = plannedActivity.estimatedDurationMinutes,
           let actualDuration = actualDurationMinutes {
            let variance = Double(actualDuration - plannedDuration)
            let percentageVariance = (variance / Double(plannedDuration)) * 100
            durationComparison = ComparisonMetric(
                planned: Double(plannedDuration),
                actual: Double(actualDuration),
                variance: variance,
                percentageVariance: percentageVariance
            )
        }
    }
    
    // MARK: - Computed Properties
    
    public var formattedVolume: String {
        String(format: "%.1f kg", totalVolumeKg)
    }
    
    public var performanceSummary: String {
        var parts: [String] = []
        
        parts.append("\(totalSetsCompleted) series")
        parts.append("\(totalRepsCompleted) reps")
        parts.append(formattedVolume)
        
        if let duration = actualDurationMinutes {
            parts.append("\(duration) min")
        }
        
        if let rpe = rpe {
            parts.append("RPE \(rpe)/10")
        }
        
        return parts.joined(separator: " · ")
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        case planElementId
        case gymActivityId
        case userId
        case startedAt
        case completedAt
        case actualDurationMinutes
        case actualCalories
        case rpe
        case notes
        case performedSets
        case volumeComparison
        case durationComparison
    }
    
    // MARK: - Firestore Serialization
    
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "activityCategory": activityCategory.rawValue,
            "startedAt": Timestamp(date: startedAt),
            "performedSets": performedSets.map { $0.toDictionary() },
            "totalVolumeKg": totalVolumeKg,
            "totalSetsCompleted": totalSetsCompleted,
            "totalRepsCompleted": totalRepsCompleted
        ]
        
        if let planElementId = planElementId {
            dict["planElementId"] = planElementId
        }
        
        if let gymActivityId = gymActivityId {
            dict["gymActivityId"] = gymActivityId
        }
        
        if let userId = userId {
            dict["userId"] = userId
        }
        
        if let completedAt = completedAt {
            dict["completedAt"] = Timestamp(date: completedAt)
        }
        
        if let actualDurationMinutes = actualDurationMinutes {
            dict["actualDurationMinutes"] = actualDurationMinutes
        }
        
        if let actualCalories = actualCalories {
            dict["actualCalories"] = actualCalories
        }
        
        if let rpe = rpe {
            dict["rpe"] = rpe
        }
        
        if let notes = notes {
            dict["notes"] = notes
        }
        
        if let volumeComparison = volumeComparison {
            dict["volumeComparison"] = volumeComparison.toDictionary()
        }
        
        if let durationComparison = durationComparison {
            dict["durationComparison"] = durationComparison.toDictionary()
        }
        
        return dict
    }
    
    /// Crear desde diccionario de Firestore
    public static func fromDictionary(_ dict: [String: Any]) throws -> GymActivityPerformance {
        guard let id = dict["id"] as? String,
              let startedAtTimestamp = dict["startedAt"] as? Timestamp else {
            throw ActivityPerformanceError.invalidData
        }
        
        let performedSetsArray = dict["performedSets"] as? [[String: Any]] ?? []
        let performedSets = try performedSetsArray.map { try PerformedRoutineSet.fromDictionary($0) }
        
        return GymActivityPerformance(
            id: id,
            planElementId: dict["planElementId"] as? String,
            gymActivityId: dict["gymActivityId"] as? String,
            userId: dict["userId"] as? String,
            startedAt: startedAtTimestamp.date,
            completedAt: (dict["completedAt"] as? Timestamp)?.date,
            actualDurationMinutes: dict["actualDurationMinutes"] as? Int,
            actualCalories: dict["actualCalories"] as? Int,
            rpe: dict["rpe"] as? Int,
            notes: dict["notes"] as? String,
            performedSets: performedSets
        )
    }
}

// MARK: - PerformedRoutineSet

public struct PerformedRoutineSet: Identifiable, Codable, Hashable {
    
    public let id: String
    
    /// Referencia al RoutineSet original (opcional)
    public var routineSetId: String?
    
    /// Nombre del set/superset
    public var name: String
    
    /// Series realmente completadas
    public var completedSeries: [PerformedSeries]
    
    /// Volumen total del set en kg
    public var totalVolumeKg: Double {
        completedSeries.reduce(0) { $0 + $1.volumeKg }
    }
    
    /// Total de repeticiones
    public var totalReps: Int {
        completedSeries.reduce(0) { $0 + $1.reps }
    }
    
    /// Tiempo de descanso promedio entre series (en segundos)
    public var averageRestSeconds: Int?
    
    public init(
        id: String = UUID().uuidString,
        routineSetId: String? = nil,
        name: String,
        completedSeries: [PerformedSeries] = [],
        averageRestSeconds: Int? = nil
    ) {
        self.id = id
        self.routineSetId = routineSetId
        self.name = name
        self.completedSeries = completedSeries
        self.averageRestSeconds = averageRestSeconds
    }
    
    // MARK: - Methods
    
    public mutating func addSeries(_ series: PerformedSeries) {
        completedSeries.append(series)
    }
    
    // MARK: - Firestore
    
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "completedSeries": completedSeries.map { $0.toDictionary() }
        ]
        
        if let routineSetId = routineSetId {
            dict["routineSetId"] = routineSetId
        }
        
        if let averageRestSeconds = averageRestSeconds {
            dict["averageRestSeconds"] = averageRestSeconds
        }
        
        return dict
    }
    
    public static func fromDictionary(_ dict: [String: Any]) throws -> PerformedRoutineSet {
        guard let id = dict["id"] as? String,
              let name = dict["name"] as? String else {
            throw ActivityPerformanceError.invalidData
        }
        
        let seriesArray = dict["completedSeries"] as? [[String: Any]] ?? []
        let series = try seriesArray.map { try PerformedSeries.fromDictionary($0) }
        
        return PerformedRoutineSet(
            id: id,
            routineSetId: dict["routineSetId"] as? String,
            name: name,
            completedSeries: series,
            averageRestSeconds: dict["averageRestSeconds"] as? Int
        )
    }
}

// MARK: - PerformedSeries

public struct PerformedSeries: Identifiable, Codable, Hashable {
    
    public let id: String
    
    /// Referencia al ejercicio
    public var exerciseId: String?
    public var exerciseName: String
    
    /// Peso utilizado en kg
    public var weightKg: Double
    
    /// Repeticiones completadas
    public var reps: Int
    
    /// Volumen de esta serie (peso × reps)
    public var volumeKg: Double {
        weightKg * Double(reps)
    }
    
    /// Timestamp de cuando se completó
    public var completedAt: Date
    
    /// Indica si fue completada exitosamente o hubo falla
    public var wasSuccessful: Bool
    
    /// Notas específicas de esta serie
    public var notes: String?
    
    public init(
        id: String = UUID().uuidString,
        exerciseId: String? = nil,
        exerciseName: String,
        weightKg: Double,
        reps: Int,
        completedAt: Date = Date(),
        wasSuccessful: Bool = true,
        notes: String? = nil
    ) {
        self.id = id
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.weightKg = weightKg
        self.reps = reps
        self.completedAt = completedAt
        self.wasSuccessful = wasSuccessful
        self.notes = notes
    }
    
    // MARK: - Firestore
    
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "exerciseName": exerciseName,
            "weightKg": weightKg,
            "reps": reps,
            "completedAt": Timestamp(date: completedAt),
            "wasSuccessful": wasSuccessful
        ]
        
        if let exerciseId = exerciseId {
            dict["exerciseId"] = exerciseId
        }
        
        if let notes = notes {
            dict["notes"] = notes
        }
        
        return dict
    }
    
    public static func fromDictionary(_ dict: [String: Any]) throws -> PerformedSeries {
        guard let id = dict["id"] as? String,
              let exerciseName = dict["exerciseName"] as? String,
              let weightKg = dict["weightKg"] as? Double,
              let reps = dict["reps"] as? Int,
              let completedAtTimestamp = dict["completedAt"] as? Timestamp,
              let wasSuccessful = dict["wasSuccessful"] as? Bool else {
            throw ActivityPerformanceError.invalidData
        }
        
        return PerformedSeries(
            id: id,
            exerciseId: dict["exerciseId"] as? String,
            exerciseName: exerciseName,
            weightKg: weightKg,
            reps: reps,
            completedAt: completedAtTimestamp.date,
            wasSuccessful: wasSuccessful,
            notes: dict["notes"] as? String
        )
    }
}

// MARK: - ComparisonMetric

public struct ComparisonMetric: Codable, Hashable {
    public let planned: Double
    public let actual: Double
    public let variance: Double
    public let percentageVariance: Double
    
    public var status: PerformanceStatus {
        if percentageVariance < -10 { return .underPerformed }
        if percentageVariance > 10 { return .overPerformed }
        return .onTarget
    }
    
    public var formattedVariance: String {
        let sign = variance > 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", variance))"
    }
    
    public var formattedPercentage: String {
        let sign = percentageVariance > 0 ? "+" : ""
        return "\(sign)\(String(format: "%.1f", percentageVariance))%"
    }
    
    public func toDictionary() -> [String: Any] {
        return [
            "planned": planned,
            "actual": actual,
            "variance": variance,
            "percentageVariance": percentageVariance
        ]
    }
}
