import Foundation


public enum PlanActivity: Codable, Hashable, Identifiable {
    
    case routine(GymActivity)
    case exercise(Exercise)
    case cardio(CardioActivity)
    case rest(RestDay)
    
    // MARK: - Identifiable
    public var id: String {
        switch self {
        case .routine(let routine):
            return "routine-\(routine.id)"
        case .exercise(let exercise):
            return "exercise-\(exercise.id)"
        case .cardio(let cardio):
            return "cardio-\(cardio.id)"
        case .rest(let rest):
            return "rest-\(rest.id)"
        }
    }
    
    /// Nombre para mostrar en UI
    public var displayName: String {
        switch self {
        case .routine(let routine):
            return routine.name
        case .exercise(let exercise):
            return exercise.name
        case .cardio(let cardio):
            return cardio.type.rawValue
        case .rest(let rest):
            return rest.type.rawValue
        }
    }
    
    /// Categoría o tipo de actividad
    public var category: String {
        switch self {
        case .routine(let routine):
            return routine.category?.rawValue ?? "Rutina"
        case .exercise(let exercise):
            return "Ejercicio"
        case .cardio:
            return "Cardio"
        case .rest:
            return "Descanso"
        }
    }
    
    /// Duración estimada en minutos
    public var estimatedDuration: Int? {
        switch self {
        case .routine(let routine):
            return routine.estimatedDurationMinutes
        case .exercise:
            return nil // Ejercicios individuales no tienen duración estimada
        case .cardio(let cardio):
            return cardio.targetDurationMinutes
        case .rest:
            return nil
        }
    }
    
    /// Calorías estimadas
    public var estimatedCalories: Int? {
        switch self {
        case .routine(let routine):
            return routine.estimatedCalories
        case .exercise:
            return nil
        case .cardio(let cardio):
            return cardio.estimatedCalories
        case .rest:
            return nil
        }
    }
    
    /// Músculos trabajados
    public var musclesWorked: [String] {
        switch self {
        case .routine(let routine):
            return  []
        case .exercise(let exercise):
            return []
        case .cardio:
            return [] // Cardio es más sistémico
        case .rest:
            return []
        }
    }
    
    /// Descripción de la actividad
    public var description: String? {
        switch self {
        case .routine(let routine):
            return routine.description
        case .exercise:
            return nil
        case .cardio(let cardio):
            return cardio.notes
        case .rest(let rest):
            return rest.description
        }
    }
    
    public var icon: String {
        switch self {
        case .routine:
            return "dumbbell.fill"
        case .exercise(let exercise):
            return exercise.name
        case .cardio(let cardio):
            switch cardio.type {
            case .running: return "figure.run"
            case .cycling: return "bicycle"
            case .swimming: return "figure.pool.swim"
            case .walking: return "figure.walk"
            case .hiking: return "figure.hiking"
            case .rowing: return "figure.rowing"
            case .elliptical: return "figure.elliptical"
            case .stairClimber: return "figure.stairs"
            case .jumpRope: return "figure.jumprope"
            case .other: return "figure.mixed.cardio"
            }
        case .rest(let rest):
            switch rest.type {
            case .complete: return "bed.double.fill"
            case .active: return "figure.walk"
            case .mobility: return "figure.flexibility"
            case .stretching: return "figure.mind.and.body"
            }
        }
    }
    
    /// Color en formato hexadecimal para UI
    public var colorHex: String {
        switch self {
        case .routine:
            return "3B82F6" // Azul - Rutinas de gym
        case .exercise:
            return "6366F1" // Índigo - Ejercicios individuales
        case .cardio(let cardio):
            // Colores diferentes según tipo de cardio
            switch cardio.type {
            case .running:
                return "EF4444" // Rojo - Running
            case .cycling:
                return "F59E0B" // Naranja - Ciclismo
            case .swimming:
                return "06B6D4" // Cyan - Natación
            case .walking:
                return "10B981" // Verde - Caminar
            case .hiking:
                return "84CC16" // Verde lima - Senderismo
            case .rowing:
                return "8B5CF6" // Violeta - Remo
            case .elliptical:
                return "EC4899" // Rosa - Elíptica
            case .stairClimber:
                return "F97316" // Naranja oscuro - Escaladora
            case .jumpRope:
                return "14B8A6" // Teal - Saltar cuerda
            case .other:
                return "6B7280" // Gris - Otro
            }
        case .rest(let rest):
            // Colores según tipo de descanso
            switch rest.type {
            case .complete:
                return "64748B" // Gris slate - Descanso completo
            case .active:
                return "22D3EE" // Cyan claro - Descanso activo
            case .mobility:
                return "A78BFA" // Púrpura claro - Movilidad
            case .stretching:
                return "C084FC" // Púrpura - Estiramientos
            }
        }
    }
    
    /// Color sugerido para UI (nombre legacy - usa colorHex)
    @available(*, deprecated, message: "Usa colorHex en su lugar")
    public var suggestedColor: String {
        switch self {
        case .routine: return "blue"
        case .exercise: return "indigo"
        case .cardio: return "green"
        case .rest: return "gray"
        }
    }
}
