
import Foundation
import SwiftUI

// MARK: - Activity Protocol

/// Protocol base que define el contrato común para todas las actividades
public protocol Activity: Identifiable, Codable, Hashable {
    
    // MARK: - Core Properties
    
    /// Identificador único de la actividad
    var id: String { get }
    
    /// Nombre de la actividad
    var name: String { get set }
    
    /// Tipo de actividad (gym, running, cycling, etc.)
    var activityType: ActivityCategory { get }
    
    /// Descripción opcional de la actividad
    var description: String? { get set }
    
    // MARK: - Metrics
    
    /// Duración estimada en minutos
    var estimatedDuration: Int? { get }
    
    /// Calorías estimadas
    var estimatedCalories: Int? { get }
    
    // MARK: - UI Properties
    
    /// Icono SF Symbol para mostrar en UI
    var icon: String { get }
    
    /// Color en formato hexadecimal (sin #)
    var colorHex: String { get }
    
    // MARK: - Metadata
    
    /// Fecha de creación
    var createdAt: Date { get }
    
    /// Fecha de última actualización
    var updatedAt: Date { get set }
    
    /// Tags asociados a la actividad
    var tags: [String] { get set }
    
    // MARK: - Storage & Sharing
    
    /// Fuente de la actividad (creada, template, comunidad)
    var source: ActivitySource { get set }
    
    /// ID del template global si fue copiado de globalActivities
    var globalActivityId: String? { get set }
    
    /// Indica si la actividad puede ser compartida (feature premium)
    var shareable: Bool { get set }
    
    /// ID del club si es contenido exclusivo de club
    var clubId: String? { get set }
    
    /// Creador de la actividad (userId)
    var creator: String? { get set }
    
    var imageURL  : String? { get set }
    
    // MARK: - Firestore Serialization
    
    /// Convierte la actividad a diccionario para Firestore
    func toDictionary() -> [String: Any]
}

// MARK: - Activity Category Enum

/// Categorías principales de actividades
public enum ActivityCategory: String, Codable, CaseIterable {
    case gym = "Workout"
    case exercise = "Ejercicio"
    case running = "Running"
    case cycling = "Cycling"
    case swimming = "Natación"
    case walking = "Caminar"
    case hiking = "Senderismo"
    case rowing = "Remo"
    case elliptical = "Elíptica"
    case stairClimber = "Escaladora"
    case jumpRope = "Saltar cuerda"
    case yoga = "Yoga"
    case pilates = "Pilates"
    case rest = "Descanso"
    case other = "Otro"
    
    /// Icono por defecto según categoría
    public var defaultIcon: String {
        switch self {
        case .gym: return "dumbbell.fill"
        case .exercise: return "figure.strengthtraining.traditional"
        case .running: return "figure.run"
        case .cycling: return "bicycle"
        case .swimming: return "figure.pool.swim"
        case .walking: return "figure.walk"
        case .hiking: return "figure.hiking"
        case .rowing: return "figure.rowing"
        case .elliptical: return "figure.elliptical"
        case .stairClimber: return "figure.stairs"
        case .jumpRope: return "figure.jumprope"
        case .yoga: return "figure.yoga"
        case .pilates: return "figure.pilates"
        case .rest: return "bed.double.fill"
        case .other: return "figure.mixed.cardio"
        }
    }
    
    /// Color por defecto según categoría (hex sin #)
    public var defaultColorHex: String {
        switch self {
        case .gym: return "3B82F6" // Azul
        case .exercise: return "6366F1" // Índigo
        case .running: return "EF4444" // Rojo
        case .cycling: return "F59E0B" // Naranja
        case .swimming: return "06B6D4" // Cyan
        case .walking: return "10B981" // Verde
        case .hiking: return "84CC16" // Verde lima
        case .rowing: return "8B5CF6" // Violeta
        case .elliptical: return "EC4899" // Rosa
        case .stairClimber: return "F97316" // Naranja oscuro
        case .jumpRope: return "14B8A6" // Teal
        case .yoga: return "A78BFA" // Púrpura claro
        case .pilates: return "C084FC" // Púrpura
        case .rest: return "64748B" // Gris slate
        case .other: return "6B7280" // Gris
        }
    }
    
    /// Indica si es una actividad de cardio
    public var isCardio: Bool {
        switch self {
        case .running, .cycling, .swimming, .walking, .hiking,
             .rowing, .elliptical, .stairClimber, .jumpRope:
            return true
        default:
            return false
        }
    }
    
    public var defaultColor: Color {
        return Color(hex: self.defaultColorHex) ?? .primaryFitnessBlue
    }
    
    /// Indica si es una actividad de fuerza
    public var isStrength: Bool {
        switch self {
        case .gym, .exercise:
            return true
        default:
            return false
        }
    }
    
    /// Indica si es una actividad de flexibilidad/movilidad
    public var isFlexibility: Bool {
        switch self {
        case .yoga, .pilates:
            return true
        default:
            return false
        }
    }
}

// MARK: - Activity Source Enum

/// Fuente de origen de la actividad
public enum ActivitySource: String, Codable, CaseIterable {
 
    /// Creada manualmente por el usuario desde la app
    case created   = "created"
 
    /// Parte del catálogo global de base data — semilla de Wellish
    case global    = "global"
 
    /// Plantilla pública disponible para todos los usuarios
    case template  = "template"
 
    /// Importada desde la comunidad mediante código de compartir
    case community = "community"
 
    /// Contenido exclusivo de un club o gimnasio
    case club      = "club"
 
    public var displayName: String {
        switch self {
        case .created:   return "Creada por ti"
        case .global:    return "Wellish"
        case .template:  return "Plantilla"
        case .community: return "Comunidad"
        case .club:      return "Club"
        }
    }
 
    public var icon: String {
        switch self {
        case .created:   return "pencil.circle.fill"
        case .global:    return "globe.americas.fill"
        case .template:  return "doc.fill"
        case .community: return "person.2.fill"
        case .club:      return "building.2.fill"
        }
    }
 
    /// Indica si el contenido es de solo lectura para el usuario
    public var isReadOnly: Bool {
        switch self {
        case .global, .template:
            return true
        case .created, .community, .club:
            return false
        }
    }
}

// MARK: - Default Implementation Helpers

extension Activity {
    
    /// Formatea la duración estimada
    public var formattedDuration: String {
        guard let minutes = estimatedDuration else { return "—" }
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let hours = minutes / 60
            let remainingMinutes = minutes % 60
            if remainingMinutes == 0 {
                return "\(hours) h"
            } else {
                return "\(hours) h \(remainingMinutes) min"
            }
        }
    }
    
    /// Formatea las calorías estimadas
    public var formattedCalories: String {
        guard let calories = estimatedCalories else { return "—" }
        return "\(calories) kcal"
    }
    
    /// Indica si es una actividad compartible (feature de pago)
    public var isShareable: Bool {
        shareable
    }
    
    /// Indica si es contenido de club
    public var isClubContent: Bool {
        clubId != nil
    }
    
    /// Indica si es un template global
    public var isTemplate: Bool {
        source == .template
    }
    
    /// Indica si fue creada por el usuario
    public var isUserCreated: Bool {
        source == .created
    }
}
