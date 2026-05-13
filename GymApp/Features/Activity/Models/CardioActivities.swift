//
//  CardioActivities.swift
//  Wellish
//

import Foundation
import FirebaseFirestore

// MARK: - RunningActivity

public struct RunningActivity: Activity {

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

    public var activityType: ActivityCategory { .running }
    public var icon: String { "figure.run" }
    public var colorHex: String { "EF4444" }

    public var runningType: RunningType
    public var targetDistanceKm: Double?
    public var targetDurationMinutes: Int?
    public var targetPaceMinPerKm: String?
    public var intensity: CardioIntensity?
    public var terrain: RunningTerrain?
    public var intervals: [RunningInterval]?
    public var elevationGainMeters: Int?
    public var estimatedCaloriesValue: Int?

    public var estimatedDuration: Int? { targetDurationMinutes }
    public var estimatedCalories: Int? { estimatedCaloriesValue }

    enum CodingKeys: String, CodingKey {
        case id, name, description, createdAt, updatedAt, tags
        case source, globalActivityId, shareable, clubId, creator, imageURL
        case runningType, targetDistanceKm, targetDurationMinutes
        case targetPaceMinPerKm, intensity, terrain, intervals
        case elevationGainMeters
        case estimatedCaloriesValue = "estimatedCalories"
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        tags = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
        source = try c.decodeIfPresent(ActivitySource.self, forKey: .source) ?? .global
        globalActivityId = try c.decodeIfPresent(String.self, forKey: .globalActivityId)
        shareable = try c.decodeIfPresent(Bool.self, forKey: .shareable) ?? false
        clubId = try c.decodeIfPresent(String.self, forKey: .clubId)
        creator = try c.decodeIfPresent(String.self, forKey: .creator)
        imageURL = try c.decodeIfPresent(String.self, forKey: .imageURL)
        runningType = try c.decodeIfPresent(RunningType.self, forKey: .runningType) ?? .steady
        targetDistanceKm = try c.decodeIfPresent(Double.self, forKey: .targetDistanceKm)
        targetDurationMinutes = try c.decodeIfPresent(Int.self, forKey: .targetDurationMinutes)
        targetPaceMinPerKm = try c.decodeIfPresent(String.self, forKey: .targetPaceMinPerKm)
        intensity = try c.decodeIfPresent(CardioIntensity.self, forKey: .intensity)
        terrain = try c.decodeIfPresent(RunningTerrain.self, forKey: .terrain)
        intervals = try c.decodeIfPresent([RunningInterval].self, forKey: .intervals)
        elevationGainMeters = try c.decodeIfPresent(Int.self, forKey: .elevationGainMeters)
        estimatedCaloriesValue = try c.decodeIfPresent(Int.self, forKey: .estimatedCaloriesValue)
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
    }

    public init(
        id: String = UUID().uuidString, name: String, description: String? = nil,
        createdAt: Date = Date(), updatedAt: Date = Date(), tags: [String] = [],
        runningType: RunningType = .steady, targetDistanceKm: Double? = nil,
        targetDurationMinutes: Int? = nil, targetPaceMinPerKm: String? = nil,
        intensity: CardioIntensity? = nil, terrain: RunningTerrain? = nil,
        intervals: [RunningInterval]? = nil, elevationGainMeters: Int? = nil,
        estimatedCalories: Int? = nil, source: ActivitySource = .created,
        globalActivityId: String? = nil, shareable: Bool = false,
        clubId: String? = nil, creator: String? = nil
    ) {
        self.id = id; self.name = name; self.description = description
        self.createdAt = createdAt; self.updatedAt = updatedAt; self.tags = tags
        self.runningType = runningType; self.targetDistanceKm = targetDistanceKm
        self.targetDurationMinutes = targetDurationMinutes
        self.targetPaceMinPerKm = targetPaceMinPerKm; self.intensity = intensity
        self.terrain = terrain; self.intervals = intervals
        self.elevationGainMeters = elevationGainMeters
        self.estimatedCaloriesValue = estimatedCalories; self.source = source
        self.globalActivityId = globalActivityId; self.shareable = shareable
        self.clubId = clubId; self.creator = creator; self.imageURL = nil
    }

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id, "name": name, "activityType": activityType.rawValue,
            "activityTypeKey": "running",
            "createdAt": Timestamp(date: createdAt), "updatedAt": Timestamp(date: updatedAt),
            "tags": tags, "runningType": runningType.rawValue,
            "source": source.rawValue, "shareable": shareable
        ]
        if let description = description { dict["description"] = description }
        if let v = targetDistanceKm { dict["targetDistanceKm"] = v }
        if let v = targetDurationMinutes { dict["targetDurationMinutes"] = v }
        if let v = targetPaceMinPerKm { dict["targetPaceMinPerKm"] = v }
        if let v = intensity { dict["intensity"] = v.rawValue }
        if let v = terrain { dict["terrain"] = v.rawValue }
        if let v = elevationGainMeters { dict["elevationGainMeters"] = v }
        if let v = estimatedCaloriesValue { dict["estimatedCalories"] = v }
        if let v = globalActivityId { dict["globalActivityId"] = v }
        if let v = clubId { dict["clubId"] = v }
        if let v = creator { dict["creator"] = v }
        if let intervals = intervals {
            dict["intervals"] = intervals.map { i -> [String: Any] in
                var d: [String: Any] = ["durationMinutes": i.durationMinutes, "paceMinPerKm": i.paceMinPerKm]
                if let r = i.recoveryMinutes { d["recoveryMinutes"] = r }
                return d
            }
        }
        return dict
    }
}

// MARK: - CyclingActivity

public struct CyclingActivity: Activity {

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

    public var activityType: ActivityCategory { .cycling }
    public var icon: String { "bicycle" }
    public var colorHex: String { "F59E0B" }

    public var cyclingType: CyclingType
    public var targetDistanceKm: Double?
    public var targetDurationMinutes: Int?
    public var targetAvgSpeedKmh: Double?
    public var intensity: CardioIntensity?
    public var terrain: CyclingTerrain?
    public var elevationGainMeters: Int?
    public var targetWatts: Int?
    public var cadenceRPM: Int?
    public var estimatedCaloriesValue: Int?

    public var estimatedDuration: Int? { targetDurationMinutes }
    public var estimatedCalories: Int? { estimatedCaloriesValue }

    enum CodingKeys: String, CodingKey {
        case id, name, description, createdAt, updatedAt, tags
        case source, globalActivityId, shareable, clubId, creator, imageURL
        case cyclingType, targetDistanceKm, targetDurationMinutes
        case targetAvgSpeedKmh, intensity, terrain, elevationGainMeters
        case targetWatts, cadenceRPM
        case estimatedCaloriesValue = "estimatedCalories"
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        tags = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
        source = try c.decodeIfPresent(ActivitySource.self, forKey: .source) ?? .global
        globalActivityId = try c.decodeIfPresent(String.self, forKey: .globalActivityId)
        shareable = try c.decodeIfPresent(Bool.self, forKey: .shareable) ?? false
        clubId = try c.decodeIfPresent(String.self, forKey: .clubId)
        creator = try c.decodeIfPresent(String.self, forKey: .creator)
        imageURL = try c.decodeIfPresent(String.self, forKey: .imageURL)
        cyclingType = try c.decodeIfPresent(CyclingType.self, forKey: .cyclingType) ?? .road
        targetDistanceKm = try c.decodeIfPresent(Double.self, forKey: .targetDistanceKm)
        targetDurationMinutes = try c.decodeIfPresent(Int.self, forKey: .targetDurationMinutes)
        targetAvgSpeedKmh = try c.decodeIfPresent(Double.self, forKey: .targetAvgSpeedKmh)
        intensity = try c.decodeIfPresent(CardioIntensity.self, forKey: .intensity)
        terrain = try c.decodeIfPresent(CyclingTerrain.self, forKey: .terrain)
        elevationGainMeters = try c.decodeIfPresent(Int.self, forKey: .elevationGainMeters)
        targetWatts = try c.decodeIfPresent(Int.self, forKey: .targetWatts)
        cadenceRPM = try c.decodeIfPresent(Int.self, forKey: .cadenceRPM)
        estimatedCaloriesValue = try c.decodeIfPresent(Int.self, forKey: .estimatedCaloriesValue)
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
    }

    public init(
        id: String = UUID().uuidString, name: String, description: String? = nil,
        createdAt: Date = Date(), updatedAt: Date = Date(), tags: [String] = [],
        cyclingType: CyclingType = .road, targetDistanceKm: Double? = nil,
        targetDurationMinutes: Int? = nil, targetAvgSpeedKmh: Double? = nil,
        intensity: CardioIntensity? = nil, terrain: CyclingTerrain? = nil,
        elevationGainMeters: Int? = nil, targetWatts: Int? = nil, cadenceRPM: Int? = nil,
        estimatedCalories: Int? = nil, source: ActivitySource = .created,
        globalActivityId: String? = nil, shareable: Bool = false,
        clubId: String? = nil, creator: String? = nil
    ) {
        self.id = id; self.name = name; self.description = description
        self.createdAt = createdAt; self.updatedAt = updatedAt; self.tags = tags
        self.cyclingType = cyclingType; self.targetDistanceKm = targetDistanceKm
        self.targetDurationMinutes = targetDurationMinutes
        self.targetAvgSpeedKmh = targetAvgSpeedKmh; self.intensity = intensity
        self.terrain = terrain; self.elevationGainMeters = elevationGainMeters
        self.targetWatts = targetWatts; self.cadenceRPM = cadenceRPM
        self.estimatedCaloriesValue = estimatedCalories; self.source = source
        self.globalActivityId = globalActivityId; self.shareable = shareable
        self.clubId = clubId; self.creator = creator; self.imageURL = nil
    }

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id, "name": name, "activityType": activityType.rawValue,
            "activityTypeKey": "cycling",
            "createdAt": Timestamp(date: createdAt), "updatedAt": Timestamp(date: updatedAt),
            "tags": tags, "cyclingType": cyclingType.rawValue,
            "source": source.rawValue, "shareable": shareable
        ]
        if let v = description { dict["description"] = v }
        if let v = targetDistanceKm { dict["targetDistanceKm"] = v }
        if let v = targetDurationMinutes { dict["targetDurationMinutes"] = v }
        if let v = targetAvgSpeedKmh { dict["targetAvgSpeedKmh"] = v }
        if let v = intensity { dict["intensity"] = v.rawValue }
        if let v = terrain { dict["terrain"] = v.rawValue }
        if let v = elevationGainMeters { dict["elevationGainMeters"] = v }
        if let v = targetWatts { dict["targetWatts"] = v }
        if let v = cadenceRPM { dict["cadenceRPM"] = v }
        if let v = estimatedCaloriesValue { dict["estimatedCalories"] = v }
        if let v = globalActivityId { dict["globalActivityId"] = v }
        if let v = clubId { dict["clubId"] = v }
        if let v = creator { dict["creator"] = v }
        return dict
    }
}

// MARK: - SwimmingActivity

public struct SwimmingActivity: Activity {

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

    public var activityType: ActivityCategory { .swimming }
    public var icon: String { "figure.pool.swim" }
    public var colorHex: String { "06B6D4" }

    public var strokeType: SwimmingStroke
    public var poolLengthMeters: Int?
    public var targetLaps: Int?
    public var targetDistanceMeters: Int?
    public var targetDurationMinutes: Int?
    public var intensity: CardioIntensity?
    public var intervals: [SwimmingInterval]?
    public var estimatedCaloriesValue: Int?

    public var estimatedDuration: Int? { targetDurationMinutes }
    public var estimatedCalories: Int? { estimatedCaloriesValue }

    enum CodingKeys: String, CodingKey {
        case id, name, description, createdAt, updatedAt, tags
        case source, globalActivityId, shareable, clubId, creator, imageURL
        case strokeType, poolLengthMeters, targetLaps, targetDistanceMeters
        case targetDurationMinutes, intensity, intervals
        case estimatedCaloriesValue = "estimatedCalories"
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        tags = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
        source = try c.decodeIfPresent(ActivitySource.self, forKey: .source) ?? .global
        globalActivityId = try c.decodeIfPresent(String.self, forKey: .globalActivityId)
        shareable = try c.decodeIfPresent(Bool.self, forKey: .shareable) ?? false
        clubId = try c.decodeIfPresent(String.self, forKey: .clubId)
        creator = try c.decodeIfPresent(String.self, forKey: .creator)
        imageURL = try c.decodeIfPresent(String.self, forKey: .imageURL)
        strokeType = try c.decodeIfPresent(SwimmingStroke.self, forKey: .strokeType) ?? .freestyle
        poolLengthMeters = try c.decodeIfPresent(Int.self, forKey: .poolLengthMeters)
        targetLaps = try c.decodeIfPresent(Int.self, forKey: .targetLaps)
        targetDistanceMeters = try c.decodeIfPresent(Int.self, forKey: .targetDistanceMeters)
        targetDurationMinutes = try c.decodeIfPresent(Int.self, forKey: .targetDurationMinutes)
        intensity = try c.decodeIfPresent(CardioIntensity.self, forKey: .intensity)
        intervals = try c.decodeIfPresent([SwimmingInterval].self, forKey: .intervals)
        estimatedCaloriesValue = try c.decodeIfPresent(Int.self, forKey: .estimatedCaloriesValue)
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
    }

    public init(
        id: String = UUID().uuidString, name: String, description: String? = nil,
        createdAt: Date = Date(), updatedAt: Date = Date(), tags: [String] = [],
        strokeType: SwimmingStroke = .freestyle, poolLengthMeters: Int? = nil,
        targetLaps: Int? = nil, targetDistanceMeters: Int? = nil,
        targetDurationMinutes: Int? = nil, intensity: CardioIntensity? = nil,
        intervals: [SwimmingInterval]? = nil, estimatedCalories: Int? = nil,
        source: ActivitySource = .created, globalActivityId: String? = nil,
        shareable: Bool = false, clubId: String? = nil, creator: String? = nil
    ) {
        self.id = id; self.name = name; self.description = description
        self.createdAt = createdAt; self.updatedAt = updatedAt; self.tags = tags
        self.strokeType = strokeType; self.poolLengthMeters = poolLengthMeters
        self.targetLaps = targetLaps; self.targetDistanceMeters = targetDistanceMeters
        self.targetDurationMinutes = targetDurationMinutes; self.intensity = intensity
        self.intervals = intervals; self.estimatedCaloriesValue = estimatedCalories
        self.source = source; self.globalActivityId = globalActivityId
        self.shareable = shareable; self.clubId = clubId; self.creator = creator
        self.imageURL = nil
    }

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id, "name": name, "activityType": activityType.rawValue,
            "activityTypeKey": "swimming",
            "createdAt": Timestamp(date: createdAt), "updatedAt": Timestamp(date: updatedAt),
            "tags": tags, "strokeType": strokeType.rawValue,
            "source": source.rawValue, "shareable": shareable
        ]
        if let v = description { dict["description"] = v }
        if let v = poolLengthMeters { dict["poolLengthMeters"] = v }
        if let v = targetLaps { dict["targetLaps"] = v }
        if let v = targetDistanceMeters { dict["targetDistanceMeters"] = v }
        if let v = targetDurationMinutes { dict["targetDurationMinutes"] = v }
        if let v = intensity { dict["intensity"] = v.rawValue }
        if let v = estimatedCaloriesValue { dict["estimatedCalories"] = v }
        if let v = globalActivityId { dict["globalActivityId"] = v }
        if let v = clubId { dict["clubId"] = v }
        if let v = creator { dict["creator"] = v }
        if let intervals = intervals {
            dict["intervals"] = intervals.map { i -> [String: Any] in
                var d: [String: Any] = ["laps": i.laps, "stroke": i.stroke.rawValue]
                if let r = i.restSeconds { d["restSeconds"] = r }
                return d
            }
        }
        return dict
    }
}

// MARK: - WalkingActivity

public struct WalkingActivity: Activity {

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

    public var activityType: ActivityCategory { .walking }
    public var icon: String { "figure.walk" }
    public var colorHex: String { "10B981" }

    public var targetDistanceKm: Double?
    public var targetDurationMinutes: Int?
    public var targetSteps: Int?
    public var intensity: CardioIntensity?
    public var terrain: WalkingTerrain?
    public var estimatedCaloriesValue: Int?

    public var estimatedDuration: Int? { targetDurationMinutes }
    public var estimatedCalories: Int? { estimatedCaloriesValue }

    enum CodingKeys: String, CodingKey {
        case id, name, description, createdAt, updatedAt, tags
        case source, globalActivityId, shareable, clubId, creator, imageURL
        case targetDistanceKm, targetDurationMinutes, targetSteps, intensity, terrain
        case estimatedCaloriesValue = "estimatedCalories"
    }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(String.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        tags = try c.decodeIfPresent([String].self, forKey: .tags) ?? []
        source = try c.decodeIfPresent(ActivitySource.self, forKey: .source) ?? .global
        globalActivityId = try c.decodeIfPresent(String.self, forKey: .globalActivityId)
        shareable = try c.decodeIfPresent(Bool.self, forKey: .shareable) ?? false
        clubId = try c.decodeIfPresent(String.self, forKey: .clubId)
        creator = try c.decodeIfPresent(String.self, forKey: .creator)
        imageURL = try c.decodeIfPresent(String.self, forKey: .imageURL)
        targetDistanceKm = try c.decodeIfPresent(Double.self, forKey: .targetDistanceKm)
        targetDurationMinutes = try c.decodeIfPresent(Int.self, forKey: .targetDurationMinutes)
        targetSteps = try c.decodeIfPresent(Int.self, forKey: .targetSteps)
        intensity = try c.decodeIfPresent(CardioIntensity.self, forKey: .intensity)
        terrain = try c.decodeIfPresent(WalkingTerrain.self, forKey: .terrain)
        estimatedCaloriesValue = try c.decodeIfPresent(Int.self, forKey: .estimatedCaloriesValue)
        createdAt = try c.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        updatedAt = try c.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
    }

    public init(
        id: String = UUID().uuidString, name: String, description: String? = nil,
        createdAt: Date = Date(), updatedAt: Date = Date(), tags: [String] = [],
        targetDistanceKm: Double? = nil, targetDurationMinutes: Int? = nil,
        targetSteps: Int? = nil, intensity: CardioIntensity? = nil,
        terrain: WalkingTerrain? = nil, estimatedCalories: Int? = nil,
        source: ActivitySource = .created, globalActivityId: String? = nil,
        shareable: Bool = false, clubId: String? = nil, creator: String? = nil
    ) {
        self.id = id; self.name = name; self.description = description
        self.createdAt = createdAt; self.updatedAt = updatedAt; self.tags = tags
        self.targetDistanceKm = targetDistanceKm
        self.targetDurationMinutes = targetDurationMinutes
        self.targetSteps = targetSteps; self.intensity = intensity
        self.terrain = terrain; self.estimatedCaloriesValue = estimatedCalories
        self.source = source; self.globalActivityId = globalActivityId
        self.shareable = shareable; self.clubId = clubId; self.creator = creator
        self.imageURL = nil
    }

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id, "name": name, "activityType": activityType.rawValue,
            "activityTypeKey": "walking",
            "createdAt": Timestamp(date: createdAt), "updatedAt": Timestamp(date: updatedAt),
            "tags": tags, "source": source.rawValue, "shareable": shareable
        ]
        if let v = description { dict["description"] = v }
        if let v = targetDistanceKm { dict["targetDistanceKm"] = v }
        if let v = targetDurationMinutes { dict["targetDurationMinutes"] = v }
        if let v = targetSteps { dict["targetSteps"] = v }
        if let v = intensity { dict["intensity"] = v.rawValue }
        if let v = terrain { dict["terrain"] = v.rawValue }
        if let v = estimatedCaloriesValue { dict["estimatedCalories"] = v }
        if let v = globalActivityId { dict["globalActivityId"] = v }
        if let v = clubId { dict["clubId"] = v }
        if let v = creator { dict["creator"] = v }
        return dict
    }
}

// MARK: - Supporting Enums (sin cambios)

public enum CardioIntensity: String, Codable, CaseIterable {
    case low      = "Baja"
    case moderate = "Moderada"
    case high     = "Alta"
    case interval = "Intervalos"
}

public enum RunningType: String, Codable, CaseIterable {
    case steady    = "Continuo"
    case intervals = "Intervalos"
    case tempo     = "Tempo"
    case fartlek   = "Fartlek"
    case longRun   = "Carrera larga"
    case recovery  = "Recuperacion"
}

public enum RunningTerrain: String, Codable, CaseIterable {
    case road      = "Carretera"
    case trail     = "Sendero"
    case track     = "Pista"
    case treadmill = "Caminadora"
    case mixed     = "Mixto"
}

public struct RunningInterval: Codable, Hashable {
    public var durationMinutes: Int
    public var paceMinPerKm: String
    public var recoveryMinutes: Int?
    public init(durationMinutes: Int, paceMinPerKm: String, recoveryMinutes: Int? = nil) {
        self.durationMinutes = durationMinutes; self.paceMinPerKm = paceMinPerKm
        self.recoveryMinutes = recoveryMinutes
    }
}

public enum CyclingType: String, Codable, CaseIterable {
    case road     = "Ruta"
    case mountain = "Montana"
    case indoor   = "Interior"
    case commute  = "Traslado"
}

public enum CyclingTerrain: String, Codable, CaseIterable {
    case flat    = "Plano"
    case rolling = "Ondulado"
    case hilly   = "Montanoso"
    case mixed   = "Mixto"
}

public enum SwimmingStroke: String, Codable, CaseIterable {
    case freestyle    = "Crol"
    case backstroke   = "Espalda"
    case breaststroke = "Pecho"
    case butterfly    = "Mariposa"
    case mixed        = "Mixto"
}

public struct SwimmingInterval: Codable, Hashable {
    public var laps: Int
    public var stroke: SwimmingStroke
    public var restSeconds: Int?
    public init(laps: Int, stroke: SwimmingStroke, restSeconds: Int? = nil) {
        self.laps = laps; self.stroke = stroke; self.restSeconds = restSeconds
    }
}

public enum WalkingTerrain: String, Codable, CaseIterable {
    case urban = "Urbano"
    case park  = "Parque"
    case trail = "Sendero"
    case beach = "Playa"
    case mixed = "Mixto"
}

// MARK: - Preview Helpers

#if DEBUG
extension RunningActivity {
    public static var example: RunningActivity {
        RunningActivity(name: "Carrera Matutina", runningType: .tempo,
                        targetDistanceKm: 5.0, targetDurationMinutes: 30,
                        targetPaceMinPerKm: "6:00", intensity: .high,
                        terrain: .road, estimatedCalories: 400, source: .global)
    }
}
extension CyclingActivity {
    public static var example: CyclingActivity {
        CyclingActivity(name: "Ruta Montana", cyclingType: .mountain,
                        targetDistanceKm: 25.0, targetDurationMinutes: 90,
                        intensity: .high, terrain: .hilly,
                        elevationGainMeters: 800, estimatedCalories: 650, source: .global)
    }
}
extension SwimmingActivity {
    public static var example: SwimmingActivity {
        SwimmingActivity(name: "Entrenamiento Piscina", strokeType: .freestyle,
                         poolLengthMeters: 25, targetLaps: 40,
                         targetDurationMinutes: 45, intensity: .moderate,
                         estimatedCalories: 350, source: .global)
    }
}
extension WalkingActivity {
    public static var example: WalkingActivity {
        WalkingActivity(name: "Caminata Parque", targetDistanceKm: 3.0,
                        targetDurationMinutes: 40, intensity: .low,
                        terrain: .park, estimatedCalories: 150, source: .global)
    }
}
#endif
