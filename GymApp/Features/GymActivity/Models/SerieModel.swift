//
//  SerieModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 30/09/25.
//

import Foundation

// MARK: - Serie (Atomic)
public struct Serie: Identifiable, Codable, Hashable {
    public let id: String
    public var repetitions: Int
    public var idealWeightKg: Double?
    public var performedWeightKg: Double?
    public var tempo: String?
    public var restSeconds: Int?
    public var rpe: Int? // Rate of Perceived Exertion (1-10)
    public var notes: String?
    public var completedAt: Date?

    public init(
        id: String = UUID().uuidString,
        repetitions: Int = 10,
        idealWeightKg: Double? = nil,
        performedWeightKg: Double? = nil,
        tempo: String? = nil,
        restSeconds: Int? = 60,
        rpe: Int? = nil,
        notes: String? = nil,
        completedAt: Date? = nil
    ) {
        self.id = id
        self.repetitions = repetitions
        self.idealWeightKg = idealWeightKg
        self.performedWeightKg = performedWeightKg
        self.tempo = tempo
        self.restSeconds = restSeconds
        self.rpe = rpe
        self.notes = notes
        self.completedAt = completedAt
    }
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case id
        case repetitions
        case idealWeightKg
        case performedWeightKg
        case tempo
        case restSeconds
        case rpe
        case notes
        case completedAt
    }

    // MARK: - Computed Properties
    
    /// Estimated volume (kg) for this serie (uses idealWeightKg if available)
    public var estimatedVolumeKg: Double {
        guard let w = idealWeightKg else { return 0 }
        return Double(repetitions) * w
    }
    
    /// Performed volume (kg) - uses performedWeightKg if available
    public var performedVolumeKg: Double {
        guard let w = performedWeightKg else { return 0 }
        return Double(repetitions) * w
    }
    
    /// Returns the weight to display (performed weight if available, otherwise ideal)
    public var displayWeight: Double? {
        performedWeightKg ?? idealWeightKg
    }
    
    /// Formatted weight string
    public var formattedWeight: String {
        if let weight = displayWeight {
            return String(format: "%.1f kg", weight)
        }
        return "Peso corporal"
    }
    
    /// Display text for UI (e.g., "10 reps × 60.0 kg")
    public var displayText: String {
        if let weight = displayWeight {
            return "\(repetitions) reps × \(String(format: "%.1f", weight)) kg"
        } else {
            return "\(repetitions) reps"
        }
    }
    
    /// Formatted rest time
    public var formattedRestTime: String {
        guard let seconds = restSeconds else { return "Sin descanso" }
        
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        
        if minutes > 0 {
            return remainingSeconds > 0 ? "\(minutes)m \(remainingSeconds)s" : "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }
    
    /// Check if serie was completed (has performed weight or completedAt date)
    public var isCompleted: Bool {
        performedWeightKg != nil || completedAt != nil
    }
    
    /// Difference between ideal and performed weight
    public var weightDifference: Double? {
        guard let ideal = idealWeightKg,
              let performed = performedWeightKg else { return nil }
        return performed - ideal
    }
    
    /// Percentage of completion (performed vs ideal weight)
    public var completionPercentage: Double? {
        guard let ideal = idealWeightKg,
              let performed = performedWeightKg,
              ideal > 0 else { return nil }
        return (performed / ideal) * 100
    }
    
    /// Formatted RPE display
    public var formattedRPE: String {
        guard let rpe = rpe else { return "—" }
        return "RPE \(rpe)/10"
    }
    
    /// RPE difficulty description
    public var rpeDifficulty: String {
        guard let rpe = rpe else { return "Sin registrar" }
        
        switch rpe {
        case 1...3:
            return "Muy fácil"
        case 4...5:
            return "Fácil"
        case 6...7:
            return "Moderado"
        case 8:
            return "Difícil"
        case 9:
            return "Muy difícil"
        case 10:
            return "Máximo esfuerzo"
        default:
            return "Fuera de rango"
        }
    }
    
    /// Check if tempo is set
    public var hasTempo: Bool {
        tempo != nil && !(tempo?.isEmpty ?? true)
    }
    
    /// Formatted tempo display
    public var formattedTempo: String {
        guard let tempo = tempo, !tempo.isEmpty else { return "Normal" }
        return tempo
    }
    
    // MARK: - Firestore Helper
    
    /// Convierte la Serie a un diccionario para Firestore
    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "repetitions": repetitions
        ]
        
        if let idealWeightKg = idealWeightKg {
            dict["idealWeightKg"] = idealWeightKg
        }
        
        if let performedWeightKg = performedWeightKg {
            dict["performedWeightKg"] = performedWeightKg
        }
        
        if let tempo = tempo {
            dict["tempo"] = tempo
        }
        
        if let restSeconds = restSeconds {
            dict["restSeconds"] = restSeconds
        }
        
        if let rpe = rpe {
            dict["rpe"] = rpe
        }
        
        if let notes = notes {
            dict["notes"] = notes
        }
        
        if let completedAt = completedAt {
            dict["completedAt"] = completedAt
        }
        
        return dict
    }
    
    // MARK: - Mutating Methods
    
    /// Mark serie as completed with current date
    public mutating func markAsCompleted(weight: Double? = nil) {
        completedAt = Date()
        if let weight = weight {
            performedWeightKg = weight
        }
    }
    
    /// Reset completion status
    public mutating func resetCompletion() {
        completedAt = nil
        performedWeightKg = nil
    }
}

// MARK: - Extensions for Preview/Testing

extension Serie {
    /// Example for previews
    public static var example: Serie {
        Serie(
            repetitions: 10,
            idealWeightKg: 60.0,
            performedWeightKg: 60.0,
            tempo: "3-0-1-0",
            restSeconds: 90,
            rpe: 7,
            notes: "Buena ejecución"
        )
    }
    
    /// Empty serie for new entries
    public static var empty: Serie {
        Serie()
    }
    
    /// Warmup set example
    public static var warmup: Serie {
        Serie(
            repetitions: 12,
            idealWeightKg: 20.0,
            tempo: "2-0-1-0",
            restSeconds: 60,
            rpe: 3,
            notes: "Serie de calentamiento"
        )
    }
    
    /// Heavy working set example
    public static var heavy: Serie {
        Serie(
            repetitions: 5,
            idealWeightKg: 100.0,
            performedWeightKg: 100.0,
            tempo: "3-1-1-0",
            restSeconds: 180,
            rpe: 9,
            completedAt: Date()
        )
    }
    
    /// Bodyweight exercise example
    public static var bodyweight: Serie {
        Serie(
            repetitions: 15,
            restSeconds: 45,
            rpe: 6,
            notes: "Peso corporal"
        )
    }
    
    /// Failed attempt example
    public static var failed: Serie {
        Serie(
            repetitions: 8,
            idealWeightKg: 80.0,
            performedWeightKg: 75.0,
            rpe: 10,
            notes: "No pude completar con el peso ideal"
        )
    }
}

// MARK: - Array Extension for Serie Statistics

extension Array where Element == Serie {
    /// Total volume across all series
    public var totalVolume: Double {
        reduce(0) { $0 + $1.estimatedVolumeKg }
    }
    
    /// Total performed volume
    public var totalPerformedVolume: Double {
        reduce(0) { $0 + $1.performedVolumeKg }
    }
    
    /// Total repetitions
    public var totalReps: Int {
        reduce(0) { $0 + $1.repetitions }
    }
    
    /// Average weight (using display weight)
    public var averageWeight: Double? {
        let weights = compactMap { $0.displayWeight }
        guard !weights.isEmpty else { return nil }
        return weights.reduce(0, +) / Double(weights.count)
    }
    
    /// Total rest time in seconds
    public var totalRestTime: Int {
        compactMap { $0.restSeconds }.reduce(0, +)
    }
    
    /// Number of completed series
    public var completedCount: Int {
        filter { $0.isCompleted }.count
    }
    
    /// Completion rate (0.0 to 1.0)
    public var completionRate: Double {
        guard !isEmpty else { return 0 }
        return Double(completedCount) / Double(count)
    }
    
    /// Average RPE
    public var averageRPE: Double? {
        let rpes = compactMap { $0.rpe }
        guard !rpes.isEmpty else { return nil }
        return Double(rpes.reduce(0, +)) / Double(rpes.count)
    }
    
    /// Formatted average RPE
    public var formattedAverageRPE: String {
        guard let avg = averageRPE else { return "—" }
        return String(format: "%.1f/10", avg)
    }
}
