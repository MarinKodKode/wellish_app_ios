////
////  RoutineModelFirestore.swift
////  Wellish
////
////  Created by Manuel Alejandro Hernandez Marín on 30/09/25.
////
//
//import Foundation
//import FirebaseFirestore
//
//public struct GymActivity : Identifiable, Codable, Hashable {
//    public let id: String
//    public var name: String
//    public var description: String?
//    public var createdAt: Date
//    public var updatedAt: Date
//    public var sets: [RoutineSet]
//    public var tags: [String]
//    public var category: String?
//    public var estimatedDurationMinutes: Int?
//    public var creator: String?
//    public var muscularGroupAffected: String?
//    public var musclesWorked: [String]?
//    public var estimatedCalories: Int?
//    public var shareable: Bool?
//    public var isPremiumRoutine: Bool?
//
//    public init(
//        id: String = UUID().uuidString,
//        name: String,
//        description: String? = nil,
//        createdAt: Date = Date(),
//        updatedAt: Date = Date(),
//        sets: [RoutineSet] = [],
//        tags: [String] = [],
//        category: String? = nil,
//        estimatedDurationMinutes: Int? = nil,
//        creator: String? = nil,
//        muscularGroupAffected: String? = nil,
//        musclesWorked: [String]? = [],
//        estimatedCalories: Int? = nil,
//        shareable: Bool? = nil,
//        isPremiumRoutine: Bool? = nil
//    ) {
//        self.id = id
//        self.name = name
//        self.description = description
//        self.createdAt = createdAt
//        self.updatedAt = updatedAt
//        self.sets = sets
//        self.tags = tags
//        self.category = category
//        self.estimatedDurationMinutes = estimatedDurationMinutes
//        self.creator = creator
//        self.muscularGroupAffected = muscularGroupAffected
//        self.musclesWorked = musclesWorked
//        self.estimatedCalories = estimatedCalories
//        self.shareable = shareable
//        self.isPremiumRoutine = isPremiumRoutine
//    }
//
//    // MARK: - CodingKeys para Firestore
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case description
//        case createdAta
//        case sets
//        case tags
//        case category
//        case estimatedDurationMinutes
//        case creator
//        case muscularGroupAffected
//        case musclesWorked
//        case estimatedCalories
//        case shareable
//        case isPremiumRoutine
//    }
//
//    // MARK: - Computed helpers
//    public var estimatedVolumeKg: Double {
//        sets.reduce(0) { $0 + $1.estimatedVolumeKg }
//    }
//
//    public var totalSeriesCount: Int {
//        sets.reduce(0) { $0 + $1.series.count }
//    }
//
//    public var totalReps: Int {
//        sets.reduce(0) { $0 + $1.totalReps }
//    }
//
//    public var formattedVolume: String {
//        NumberFormatter.localizedString(
//            from: NSNumber(value: estimatedVolumeKg),
//            number: .decimal
//        ) + " kg"
//    }
//
//    public var formattedDuration: String {
//        guard let minutes = estimatedDurationMinutes else { return "—" }
//        return "\(minutes) min"
//    }
//
//    public var formattedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.locale = Locale(identifier: "es_MX")
//        return formatter.string(from: createdAt)
//    }
//    
//    // MARK: - Helpers adicionales
//    
//    /// Indica si la rutina es del día actual
//    public var isToday: Bool {
//        Calendar.current.isDateInToday(createdAt)
//    }
//    
//    /// Calcula días desde la creación
//    public var daysOld: Int {
//        Calendar.current.dateComponents([.day], from: createdAt, to: Date()).day ?? 0
//    }
//    
//    /// Retorna un diccionario para Firestore (útil para updates parciales)
//    public func toDictionary() -> [String: Any] {
//        var dict: [String: Any] = [
//            "id": id,
//            "name": name,
//            "createdAt": Timestamp(date: createdAt),
//            "updatedAt": Timestamp(date: updatedAt),
//            "sets": sets.map { $0.toDictionary() },
//            "tags": tags
//        ]
//        
//        if let description = description {
//            dict["description"] = description
//        }
//        if let category = category {
//            dict["category"] = category
//        }
//        if let estimatedDurationMinutes = estimatedDurationMinutes {
//            dict["estimatedDurationMinutes"] = estimatedDurationMinutes
//        }
//        if let creator = creator {
//            dict["creator"] = creator
//        }
//        if let muscularGroupAffected = muscularGroupAffected {
//            dict["muscularGroupAffected"] = muscularGroupAffected
//        }
//        if let musclesWorked = musclesWorked {
//            dict["musclesWorked"] = musclesWorked
//        }
//        if let estimatedCalories = estimatedCalories {
//            dict["estimatedCalories"] = estimatedCalories
//        }
//        if let shareable = shareable {
//            dict["shareable"] = shareable
//        }
//        if let isPremiumRoutine = isPremiumRoutine {
//            dict["isPremiumRoutine"] = isPremiumRoutine
//        }
//        
//        return dict
//    }
//}
//
//// MARK: - Series Model
//
//public struct Series: Identifiable, Codable, Hashable {
//    public let id: String
//    public var reps: Int
//    public var weightKg: Double?
//    public var isCompleted: Bool
//    public var rpe: Int? // Rate of Perceived Exertion (1-10)
//    
//    public init(
//        id: String = UUID().uuidString,
//        reps: Int,
//        weightKg: Double? = nil,
//        isCompleted: Bool = false,
//        rpe: Int? = nil
//    ) {
//        self.id = id
//        self.reps = reps
//        self.weightKg = weightKg
//        self.isCompleted = isCompleted
//        self.rpe = rpe
//    }
//    
//    // MARK: - CodingKeys
//    enum CodingKeys: String, CodingKey {
//        case id
//        case reps
//        case weightKg
//        case isCompleted
//        case rpe
//    }
//    
//    // MARK: - Computed properties
//    public var volumeKg: Double {
//        Double(reps) * (weightKg ?? 0)
//    }
//    
//    public var formattedWeight: String {
//        guard let weight = weightKg else { return "Peso corporal" }
//        return String(format: "%.1f kg", weight)
//    }
//    
//    public var displayText: String {
//        if let weight = weightKg {
//            return "\(reps) reps × \(String(format: "%.1f", weight)) kg"
//        } else {
//            return "\(reps) reps"
//        }
//    }
//    
//    /// Retorna un diccionario para Firestore
//    public func toDictionary() -> [String: Any] {
//        var dict: [String: Any] = [
//            "id": id,
//            "reps": reps,
//            "isCompleted": isCompleted
//        ]
//        
//        if let weightKg = weightKg {
//            dict["weightKg"] = weightKg
//        }
//        if let rpe = rpe {
//            dict["rpe"] = rpe
//        }
//        
//        return dict
//    }
//}
//
////// MARK: - Extensiones útiles para la UI
////
////extension Routine {
////    /// Ejemplo de rutina para previews
////    public static var example: Routine {
////        Routine(
////            name: "Full Body Workout",
////            description: "Rutina completa de cuerpo entero para principiantes",
////            sets: [
////                RoutineSet(
////                    exerciseName: "Sentadillas",
////                    series: [
////                        Series(reps: 12, weightKg: 60),
////                        Series(reps: 10, weightKg: 70),
////                        Series(reps: 8, weightKg: 80)
////                    ],
////                    restTimeSeconds: 90
////                ),
////                RoutineSet(
////                    exerciseName: "Press de Banca",
////                    series: [
////                        Series(reps: 10, weightKg: 50),
////                        Series(reps: 8, weightKg: 55),
////                        Series(reps: 6, weightKg: 60)
////                    ],
////                    restTimeSeconds: 120
////                )
////            ],
////            tags: ["Fuerza", "Principiante"],
////            category: "Full Body",
////            estimatedDurationMinutes: 60,
////            creator: "user123",
////            muscularGroupAffected: "Todo el cuerpo",
////            musclesWorked: ["Cuádriceps", "Pectorales", "Tríceps"],
////            estimatedCalories: 350,
////            shareable: true,
////            isPremiumRoutine: false
////        )
////    }
////    
////    /// Rutina vacía para crear nueva
////    public static var empty: Routine {
////        Routine(name: "Nueva Rutina")
////    }
////}
////
////extension RoutineSet {
////    /// Ejemplo de set para previews
////    public static var example: RoutineSet {
////        RoutineSet(
////            exerciseName: "Press de Banca",
////            series: [
////                Series(reps: 10, weightKg: 50),
////                Series(reps: 8, weightKg: 55),
////                Series(reps: 6, weightKg: 60)
////            ],
////            restTimeSeconds: 120,
////            notes: "Mantener la espalda pegada al banco"
////        )
////    }
////}
