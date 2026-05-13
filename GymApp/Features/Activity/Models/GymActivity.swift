//
//  GymActivity.swift
//  Wellish
//

import Foundation
import FirebaseFirestore

public struct GymActivity: Activity {

    // MARK: - Core Properties

    public let id: String
    public var name: String
    public var description: String?
    public var createdAt: Date
    public var updatedAt: Date
    public var tags: [String]
    public var source: ActivitySource
    public var globalActivityId: String?
    public var shareable: Bool
    public var clubId: String?
    public var creator: String?
    public var imageURL: String?

    // MARK: - Activity Protocol

    public var activityType: ActivityCategory { .gym }
    public var icon: String { "dumbbell.fill" }
    public var colorHex: String { "3B82F6" }

    // MARK: - Gym-Specific Properties

    public var sets: [RoutineSet]
    public var category: ExerciseCategory?
    public var estimatedDurationMinutes: Int?
    public var primaryMuscles: [ExerciseMuscle]
    public var secondaryMuscles: [ExerciseMuscle]
    public var estimatedCaloriesValue: Int?
    public var isPremiumRoutine: Bool
    public var difficulty: ExerciseDifficulty?

    // MARK: - Activity Protocol Computed Properties

    public var estimatedDuration: Int? { estimatedDurationMinutes }
    public var estimatedCalories: Int? { estimatedCaloriesValue }

    // MARK: - Computed Properties

    public var estimatedVolumeKg: Double {
        sets.reduce(0) { $0 + $1.estimatedVolumeKg }
    }

    public var totalSeriesCount: Int {
        sets.reduce(0) { $0 + $1.series.count }
    }

    public var totalReps: Int {
        sets.reduce(0) { $0 + $1.totalReps }
    }

    public var primaryMusclesDisplay: String {
        primaryMuscles.isEmpty ? "—" : primaryMuscles.map(\.rawValue).joined(separator: ", ")
    }

    public var secondaryMusclesDisplay: String {
        secondaryMuscles.isEmpty ? "—" : secondaryMuscles.map(\.rawValue).joined(separator: ", ")
    }

    public var isToday: Bool {
        Calendar.current.isDateInToday(createdAt)
    }

    // MARK: - Init

    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        sets: [RoutineSet] = [],
        tags: [String] = [],
        category: ExerciseCategory? = nil,
        difficulty: ExerciseDifficulty? = nil,
        estimatedDurationMinutes: Int? = nil,
        primaryMuscles: [ExerciseMuscle] = [],
        secondaryMuscles: [ExerciseMuscle] = [],
        estimatedCalories: Int? = nil,
        source: ActivitySource = .created,
        globalActivityId: String? = nil,
        shareable: Bool = false,
        clubId: String? = nil,
        creator: String? = nil,
        isPremiumRoutine: Bool = false,
        imageURL: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.sets = sets
        self.tags = tags
        self.category = category
        self.difficulty = difficulty
        self.estimatedDurationMinutes = estimatedDurationMinutes
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
        self.estimatedCaloriesValue = estimatedCalories
        self.source = source
        self.globalActivityId = globalActivityId
        self.shareable = shareable
        self.clubId = clubId
        self.creator = creator
        self.isPremiumRoutine = isPremiumRoutine
        self.imageURL = imageURL
    }

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case createdAt, updatedAt
        case sets, tags
        case category, difficulty
        case estimatedDurationMinutes
        case primaryMuscles, secondaryMuscles
        case estimatedCaloriesValue = "estimatedCalories"
        case source, globalActivityId
        case shareable, clubId, creator
        case isPremiumRoutine, imageURL
    }

    // MARK: - Custom Decoder (tolerante a campos faltantes y Timestamps)

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)

        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        sets = try c.decodeIfPresent([RoutineSet].self, forKey: .sets) ?? []
        tags = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
        category = try c.decodeIfPresent(ExerciseCategory.self, forKey: .category)
        difficulty = try c.decodeIfPresent(ExerciseDifficulty.self, forKey: .difficulty)
        estimatedDurationMinutes = try c.decodeIfPresent(Int.self, forKey: .estimatedDurationMinutes)
        estimatedCaloriesValue = try c.decodeIfPresent(Int.self, forKey: .estimatedCaloriesValue)
        primaryMuscles = try c.decodeIfPresent([ExerciseMuscle].self, forKey: .primaryMuscles) ?? []
        secondaryMuscles = try c.decodeIfPresent([ExerciseMuscle].self, forKey: .secondaryMuscles) ?? []
        source = try c.decodeIfPresent(ActivitySource.self, forKey: .source) ?? .global
        globalActivityId = try c.decodeIfPresent(String.self, forKey: .globalActivityId)
        shareable = try c.decodeIfPresent(Bool.self, forKey: .shareable) ?? false
        clubId = try c.decodeIfPresent(String.self, forKey: .clubId)
        creator = try c.decodeIfPresent(String.self, forKey: .creator)
        isPremiumRoutine = try c.decodeIfPresent(Bool.self, forKey: .isPremiumRoutine) ?? false
        imageURL = try c.decodeIfPresent(String.self, forKey: .imageURL)
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
    }

    // MARK: - Firestore Serialization

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "activityType": activityType.rawValue,
            "activityTypeKey": "gym",
            "createdAt": Timestamp(date: createdAt),
            "updatedAt": Timestamp(date: updatedAt),
            "sets": sets.map { $0.toDictionary() },
            "tags": tags,
            "source": source.rawValue,
            "shareable": shareable,
            "isPremiumRoutine": isPremiumRoutine,
            "primaryMuscles": primaryMuscles.map(\.rawValue),
            "secondaryMuscles": secondaryMuscles.map(\.rawValue)
        ]

        if let description = description { dict["description"] = description }
        if let category = category { dict["category"] = category.rawValue }
        if let difficulty = difficulty { dict["difficulty"] = difficulty.rawValue }
        if let duration = estimatedDurationMinutes { dict["estimatedDurationMinutes"] = duration }
        if let calories = estimatedCaloriesValue { dict["estimatedCalories"] = calories }
        if let creator = creator { dict["creator"] = creator }
        if let globalActivityId = globalActivityId { dict["globalActivityId"] = globalActivityId }
        if let clubId = clubId { dict["clubId"] = clubId }
        if let imageURL = imageURL { dict["imageURL"] = imageURL }

        return dict
    }
}

// MARK: - Preview

#if DEBUG
extension GymActivity {
    public static var example: GymActivity {
        GymActivity(
            name: "Empuje de pecho",
            description: "Rutina de empuje enfocada en pecho.",
            sets: [
                RoutineSet(
                    exerciseId: "8B747E73-EF22-4B53-8FBA-279B217C9D9F",
                    exerciseName: "Press de banca con barra",
                    series: [Serie(repetitions: 10, idealWeightKg: 60, restSeconds: 90)]
                )
            ],
            category: .hipertrofia,
            difficulty: .intermedio,
            primaryMuscles: [.pectorales],
            secondaryMuscles: [.triceps],
            estimatedCalories: 320,
            source: .global,
            isPremiumRoutine: false
        )
    }
}
#endif
