import Foundation

// MARK: - Exercise

public struct Exercise: Identifiable, Codable, Hashable {

    // MARK: - Core Properties

    public let id: String
    public var name: String
    public var description: String?
    public var instructions: [String]
    public var activityType: String
    public var category: ExerciseCategory
    public var difficulty: ExerciseDifficulty
    public var primaryMuscles: [ExerciseMuscle]
    public var secondaryMuscles: [ExerciseMuscle]
    public var equipment: ExerciseEquipment
    public var tags: [String]
    public var thumbnailURL: String?
    public var videoURL: String?

    // MARK: - Metadata

    public var source: String
    public var isGlobal: Bool
    public var createdAt: Date
    public var updatedAt: Date

    // MARK: - Init

    public init(
        id: String = UUID().uuidString,
        name: String,
        description: String? = nil,
        instructions: [String] = [],
        activityType: String,
        category: ExerciseCategory,
        difficulty: ExerciseDifficulty = .principiante,
        primaryMuscles: [ExerciseMuscle] = [],
        secondaryMuscles: [ExerciseMuscle] = [],
        equipment: ExerciseEquipment = .ninguno,
        tags: [String] = [],
        thumbnailURL: String? = nil,
        videoURL: String? = nil,
        source: String = "created",
        isGlobal: Bool = false,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.instructions = instructions
        self.activityType = activityType
        self.category = category
        self.difficulty = difficulty
        self.primaryMuscles = primaryMuscles
        self.secondaryMuscles = secondaryMuscles
        self.equipment = equipment
        self.tags = tags
        self.thumbnailURL = thumbnailURL
        self.videoURL = videoURL
        self.source = source
        self.isGlobal = isGlobal
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    // MARK: - CodingKeys

    enum CodingKeys: String, CodingKey {
        case id, name, description, instructions
        case activityType, category, difficulty
        case primaryMuscles, secondaryMuscles
        case equipment, tags
        case thumbnailURL, videoURL
        case source, isGlobal
        case createdAt, updatedAt
    }

    // MARK: - Computed Properties

    /// Muscles primarios en formato legible
    public var primaryMusclesDisplay: String {
        primaryMuscles.isEmpty ? "—" : primaryMuscles.map(\.rawValue).joined(separator: ", ")
    }

    /// Muscles secundarios en formato legible
    public var secondaryMusclesDisplay: String {
        secondaryMuscles.isEmpty ? "—" : secondaryMuscles.map(\.rawValue).joined(separator: ", ")
    }

    /// Todos los muscles combinados para display
    public var allMusclesDisplay: String {
        let all = primaryMuscles + secondaryMuscles
        return all.isEmpty ? "—" : all.map(\.rawValue).joined(separator: ", ")
    }

    /// Verifica si tiene imagen
    public var hasImage: Bool { thumbnailURL != nil }

    /// Verifica si tiene video
    public var hasVideo: Bool { videoURL != nil }

    /// Verifica si es base data global
    public var isBaseData: Bool { isGlobal && source == "global" }

    /// Numero de pasos de instrucciones
    public var instructionStepsCount: Int { instructions.count }

    // MARK: - Firestore Serialization

    public func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "name": name,
            "instructions": instructions,
            "activityType": activityType,
            "category": category.rawValue,
            "difficulty": difficulty.rawValue,
            "primaryMuscles": primaryMuscles.map(\.rawValue),
            "secondaryMuscles": secondaryMuscles.map(\.rawValue),
            "equipment": equipment.rawValue,
            "tags": tags,
            "source": source,
            "isGlobal": isGlobal
        ]

        if let description = description { dict["description"] = description }
        if let thumbnailURL = thumbnailURL { dict["thumbnailURL"] = thumbnailURL }
        if let videoURL = videoURL { dict["videoURL"] = videoURL }

        return dict
    }

    // MARK: - Firestore Deserialization

    public static func fromDictionary(_ dict: [String: Any]) throws -> Exercise {
        guard
            let id = dict["id"] as? String,
            let name = dict["name"] as? String,
            let activityType = dict["activityType"] as? String,
            let categoryRaw = dict["category"] as? String,
            let category = ExerciseCategory(rawValue: categoryRaw),
            let difficultyRaw = dict["difficulty"] as? String,
            let difficulty = ExerciseDifficulty(rawValue: difficultyRaw),
            let equipmentRaw = dict["equipment"] as? String,
            let equipment = ExerciseEquipment(rawValue: equipmentRaw)
        else {
            throw ExerciseError.invalidData
        }

        let instructions = dict["instructions"] as? [String] ?? []
        let tags = dict["tags"] as? [String] ?? []
        let source = dict["source"] as? String ?? "global"
        let isGlobal = dict["isGlobal"] as? Bool ?? false

        let primaryMuscles = (dict["primaryMuscles"] as? [String] ?? [])
            .compactMap { ExerciseMuscle(rawValue: $0) }

        let secondaryMuscles = (dict["secondaryMuscles"] as? [String] ?? [])
            .compactMap { ExerciseMuscle(rawValue: $0) }

        return Exercise(
            id: id,
            name: name,
            description: dict["description"] as? String,
            instructions: instructions,
            activityType: activityType,
            category: category,
            difficulty: difficulty,
            primaryMuscles: primaryMuscles,
            secondaryMuscles: secondaryMuscles,
            equipment: equipment,
            tags: tags,
            thumbnailURL: dict["thumbnailURL"] as? String,
            videoURL: dict["videoURL"] as? String,
            source: source,
            isGlobal: isGlobal
        )
    }
}

// MARK: - ExerciseError

public enum ExerciseError: LocalizedError {
    case invalidData
    case missingRequiredField(String)

    public var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Los datos del ejercicio son invalidos"
        case .missingRequiredField(let field):
            return "Falta el campo requerido: \(field)"
        }
    }
}

// MARK: - ExerciseCategory

public enum ExerciseCategory: String, Codable, CaseIterable {
    case fuerza       = "Fuerza"
    case hipertrofia  = "Hipertrofia"
    case hiit         = "HIIT"
    case plimetrico   = "Pliometrico"
    case cardio       = "Cardio"
    case movilidad    = "Movilidad"
    case calistenia   = "Calistenia"
    case recuperacion = "Recuperacion"

    public var displayName: String {
        switch self {
        case .fuerza:       return "Fuerza"
        case .hipertrofia:  return "Hipertrofia"
        case .hiit:         return "HIIT"
        case .plimetrico:   return "Pliometrico"
        case .cardio:       return "Cardio"
        case .movilidad:    return "Movilidad"
        case .calistenia:   return "Calistenia"
        case .recuperacion: return "Recuperacion"
        }
    }

    public var icon: String {
        switch self {
        case .fuerza:       return "dumbbell.fill"
        case .hipertrofia:  return "figure.strengthtraining.traditional"
        case .hiit:         return "bolt.fill"
        case .plimetrico:   return "figure.jumprope"
        case .cardio:       return "heart.fill"
        case .movilidad:    return "figure.flexibility"
        case .calistenia:   return "figure.gymnastics"
        case .recuperacion: return "moon.zzz.fill"
        }
    }
}

// MARK: - ExerciseDifficulty

public enum ExerciseDifficulty: String, Codable, CaseIterable {
    case principiante = "Principiante"
    case intermedio   = "Intermedio"
    case avanzado     = "Avanzado"

    public var displayName: String { rawValue }

    public var colorHex: String {
        switch self {
        case .principiante: return "34D399"
        case .intermedio:   return "FBBF24"
        case .avanzado:     return "F87171"
        }
    }

    public var order: Int {
        switch self {
        case .principiante: return 0
        case .intermedio:   return 1
        case .avanzado:     return 2
        }
    }
}

// MARK: - ExerciseEquipment

public enum ExerciseEquipment: String, Codable, CaseIterable {
    case ninguno         = "Ninguno"
    case barra           = "Barra"
    case mancuernas      = "Mancuernas"
    case kettlebell      = "Kettlebell"
    case maquina         = "Maquina"
    case polea           = "Polea"
    case banco           = "Banco"
    case barraFija       = "Barra fija"
    case paralelas       = "Paralelas"
    case cajaPliometrica = "Caja pliometrica"
    case balonMedicinal  = "Balon medicinal"
    case cuerdaSaltar    = "Cuerda para saltar"
    case bandasElasticas = "Bandas elasticas"
    case trx             = "TRX"
    case bicicleta       = "Bicicleta"
    case alberca         = "Alberca"
    case caminadora      = "Caminadora"

    public var displayName: String {
        switch self {
        case .ninguno:         return "Ninguno"
        case .barra:           return "Barra"
        case .mancuernas:      return "Mancuernas"
        case .kettlebell:      return "Kettlebell"
        case .maquina:         return "Maquina"
        case .polea:           return "Polea"
        case .banco:           return "Banco"
        case .barraFija:       return "Barra fija"
        case .paralelas:       return "Paralelas"
        case .cajaPliometrica: return "Caja pliometrica"
        case .balonMedicinal:  return "Balon medicinal"
        case .cuerdaSaltar:    return "Cuerda para saltar"
        case .bandasElasticas: return "Bandas elasticas"
        case .trx:             return "TRX"
        case .bicicleta:       return "Bicicleta"
        case .alberca:         return "Alberca"
        case .caminadora:      return "Caminadora"
        }
    }

    public var requiresGym: Bool {
        switch self {
        case .ninguno, .kettlebell, .mancuernas,
             .bandasElasticas, .trx, .cuerdaSaltar,
             .balonMedicinal, .bicicleta, .alberca,
             .caminadora:
            return false
        default:
            return true
        }
    }
}

// MARK: - ExerciseMuscle

public enum ExerciseMuscle: String, Codable, CaseIterable {

    // Tren superior
    case pectorales           = "Pectorales"
    case deltoidesAnteriores  = "Deltoides anteriores"
    case deltoidesLaterales   = "Deltoides laterales"
    case deltoidesPosteriores = "Deltoides posteriores"
    case trapecios            = "Trapecios"
    case dorsales             = "Dorsales"
    case romboides            = "Romboides"
    case biceps               = "Biceps"
    case triceps              = "Triceps"
    case antebrazos           = "Antebrazos"

    // Core
    case abdomenSuperior      = "Abdomen superior"
    case abdomenInferior      = "Abdomen inferior"
    case oblicuos             = "Oblicuos"
    case transversoAbdominal  = "Transverso abdominal"
    case lumbar               = "Lumbar"

    // Tren inferior
    case cuadriceps           = "Cuadriceps"
    case femorales            = "Femorales"
    case gluteoMayor          = "Gluteos mayor"
    case gluteoMedio          = "Gluteos medio"
    case aductores            = "Aductores"
    case abductores           = "Abductores"
    case gemelos              = "Gemelos"
    case soleo                = "Soleo"
    case flexoresDeCadera     = "Flexores de cadera"
    case tibialAnterior       = "Tibial anterior"

    // General
    case cuerpoCompleto       = "Cuerpo completo"

    public var displayName: String { rawValue }

    public var region: MuscleRegion {
        switch self {
        case .pectorales, .deltoidesAnteriores, .deltoidesLaterales,
             .deltoidesPosteriores, .trapecios, .dorsales, .romboides,
             .biceps, .triceps, .antebrazos:
            return .trenSuperior
        case .abdomenSuperior, .abdomenInferior, .oblicuos,
             .transversoAbdominal, .lumbar:
            return .core
        case .cuadriceps, .femorales, .gluteoMayor, .gluteoMedio,
             .aductores, .abductores, .gemelos, .soleo,
             .flexoresDeCadera, .tibialAnterior:
            return .trenInferior
        case .cuerpoCompleto:
            return .general
        }
    }
}

// MARK: - MuscleRegion

public enum MuscleRegion: String, CaseIterable {
    case trenSuperior = "Tren superior"
    case core         = "Core"
    case trenInferior = "Tren inferior"
    case general      = "General"
}

// MARK: - Preview Helpers

#if DEBUG
extension Exercise {
    public static var example: Exercise {
        Exercise(
            id: "8B747E73-EF22-4B53-8FBA-279B217C9D9F",
            name: "Press de banca con barra",
            description: "Ejercicio compuesto de empuje para el desarrollo del pecho.",
            instructions: [
                "Acuéstate en el banco plano con los pies apoyados en el suelo.",
                "Agarra la barra con agarre ligeramente mas ancho que los hombros.",
                "Desciende la barra de forma controlada hasta rozar el pecho.",
                "Empuja la barra hacia arriba hasta extender los brazos.",
                "Mantén los omoplatos retraidos durante todo el movimiento."
            ],
            activityType: "gym",
            category: .hipertrofia,
            difficulty: .intermedio,
            primaryMuscles: [.pectorales],
            secondaryMuscles: [.triceps, .deltoidesAnteriores],
            equipment: .barra,
            tags: ["pecho", "empuje", "compuesto"],
            thumbnailURL: "https://upload.wikimedia.org/wikipedia/commons/e/e0/Bench_Press_on_Decline_Bench_at_the_Gym.jpg",
            source: "global",
            isGlobal: true
        )
    }

    public static var examples: [Exercise] {
        [
            example,
            Exercise(
                name: "Dominadas",
                description: "Ejercicio de jale con peso corporal para dorsales y biceps.",
                instructions: [
                    "Agarra la barra fija con agarre prono, mas ancho que los hombros.",
                    "Cuelga con los brazos completamente extendidos.",
                    "Jala el cuerpo hacia arriba hasta que la barbilla supere la barra.",
                    "Baja de forma controlada a la posicion inicial.",
                    "Mantén los hombros alejados de las orejas."
                ],
                activityType: "gym",
                category: .calistenia,
                difficulty: .intermedio,
                primaryMuscles: [.dorsales],
                secondaryMuscles: [.biceps, .trapecios],
                equipment: .barraFija,
                tags: ["espalda", "jale", "calistenia"],
                source: "global",
                isGlobal: true
            )
        ]
    }
}
#endif
