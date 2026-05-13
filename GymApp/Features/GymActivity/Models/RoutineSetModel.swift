//
//  RoutineSetModel.swift
//  Wellish
//

import Foundation
import FirebaseFirestore

// MARK: - RoutineSet

public struct RoutineSet: Identifiable, Codable, Hashable {

    public let id: String

    /// ID del ejercicio en la coleccion global /exercises
    public var exerciseId: String

    /// Nombre cacheado del ejercicio para display sin fetch adicional
    public var exerciseName: String

    public var series: [Serie]
    public var restBetweenSeriesSeconds: Int?
    public var notes: String?
    public var intensityTechnique: IntensityTechnique?

    // MARK: - Init

    public init(
        id: String = UUID().uuidString,
        exerciseId: String,
        exerciseName: String,
        series: [Serie] = [Serie()],
        restBetweenSeriesSeconds: Int? = 60,
        notes: String? = nil,
        intensityTechnique: IntensityTechnique? = nil
    ) {
        self.id = id
        self.exerciseId = exerciseId
        self.exerciseName = exerciseName
        self.series = series
        self.restBetweenSeriesSeconds = restBetweenSeriesSeconds
        self.notes = notes
        self.intensityTechnique = intensityTechnique
    }

    /// Convenience init que acepta un Exercise completo
    /// Mantiene compatibilidad con el flujo de creacion de rutinas en UI
    public init(
        id: String = UUID().uuidString,
        exercise: Exercise,
        series: [Serie] = [Serie()],
        restBetweenSeriesSeconds: Int? = 60,
        notes: String? = nil,
        intensityTechnique: IntensityTechnique? = nil
    ) {
        self.id = id
        self.exerciseId = exercise.id
        self.exerciseName = exercise.name
        self.series = series
        self.restBetweenSeriesSeconds = restBetweenSeriesSeconds
        self.notes = notes
        self.intensityTechnique = intensityTechnique
    }

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id
        case exerciseId
        case exerciseName
        case series
        case restBetweenSeriesSeconds
        case notes
        case intensityTechnique
    }

    // MARK: - Computed Properties

    /// Volumen estimado total del set
    public var estimatedVolumeKg: Double {
        series.reduce(0) { $0 + $1.estimatedVolumeKg }
    }

    /// Total de repeticiones en el set
    public var totalReps: Int {
        series.reduce(0) { $0 + $1.repetitions }
    }

    /// Series completadas
    public var completedSeriesCount: Int {
        series.filter { $0.isCompleted }.count
    }

    /// Indica si todas las series estan completadas
    public var isCompleted: Bool {
        !series.isEmpty && series.allSatisfy { $0.isCompleted }
    }

    // MARK: - Firestore Serialization

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "exerciseId": exerciseId,
            "exerciseName": exerciseName,
            "series": series.map { $0.toDictionary() }
        ]

        if let rest = restBetweenSeriesSeconds {
            dict["restBetweenSeriesSeconds"] = rest
        }
        if let notes = notes {
            dict["notes"] = notes
        }
        if let technique = intensityTechnique {
            dict["intensityTechnique"] = technique.rawValue
        }

        return dict
    }
}
