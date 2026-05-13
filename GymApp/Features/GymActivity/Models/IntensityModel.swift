//
//  RoutineModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import Foundation


// MARK: - Intensity Techniques
public enum IntensityTechnique: String, Codable, CaseIterable {
    case none
    case dropSet = "Drop set"
    case superset = "Superset"
    case restPause = "Rest-pause"
    case pausedReps = "Paused reps"
    case pyramid = "Pyramid"
    case cluster = "Cluster"
    case mechanical = "Mechanical drop set"
    case giant = "Giant set"
    case twentyOneReps = "21 reps"
    
    // MARK: - Display Properties
    
    /// Nombre para mostrar en la UI
    public var displayName: String {
        switch self {
        case .none:
            return "Normal"
        case .dropSet:
            return "Drop Set"
        case .superset:
            return "Superserie"
        case .restPause:
            return "Rest-Pause"
        case .pausedReps:
            return "Repeticiones Pausadas"
        case .pyramid:
            return "Pirámide"
        case .cluster:
            return "Cluster"
        case .mechanical:
            return "Drop Set Mecánico"
        case .giant:
            return "Serie Gigante"
        case .twentyOneReps:
            return "21 Repeticiones"
        }
    }
    
    /// Descripción detallada de la técnica
    public var description: String {
        switch self {
        case .none:
            return "Ejecución normal del ejercicio sin técnicas especiales"
        case .dropSet:
            return "Reduce el peso inmediatamente después de llegar al fallo para continuar con más repeticiones"
        case .superset:
            return "Realiza dos ejercicios consecutivos sin descanso entre ellos, típicamente músculos antagonistas"
        case .restPause:
            return "Descansa brevemente (10-15 segundos) durante la serie para completar más repeticiones con el mismo peso"
        case .pausedReps:
            return "Mantén una pausa de 1-3 segundos en algún punto del movimiento para aumentar tiempo bajo tensión"
        case .pyramid:
            return "Aumenta o disminuye el peso progresivamente en cada serie, variando también las repeticiones"
        case .cluster:
            return "Divide una serie en mini-series con descansos muy cortos (5-20 segundos) entre ellas"
        case .mechanical:
            return "Cambia la variación del ejercicio cuando alcanzas el fallo para continuar trabajando el mismo músculo"
        case .giant:
            return "Realiza 4 o más ejercicios consecutivos sin descanso, generalmente para el mismo grupo muscular"
        case .twentyOneReps:
            return "Divide el rango de movimiento en 3 secciones de 7 repeticiones cada una (7+7+7=21)"
        }
    }
    
    /// Emoji o símbolo representativo
    public var icon: String {
        switch self {
        case .none:
            return "●"
        case .dropSet:
            return "⬇️"
        case .superset:
            return "⚡️"
        case .restPause:
            return "⏸️"
        case .pausedReps:
            return "⏱️"
        case .pyramid:
            return "🔺"
        case .cluster:
            return "💥"
        case .mechanical:
            return "🔄"
        case .giant:
            return "🏋️"
        case .twentyOneReps:
            return "2️⃣1️⃣"
        }
    }
    
    /// Intensidad de la técnica (1-10, siendo 10 la más intensa)
    public var intensityLevel: Int {
        switch self {
        case .none:
            return 1
        case .pausedReps:
            return 3
        case .pyramid:
            return 4
        case .cluster:
            return 5
        case .twentyOneReps:
            return 6
        case .restPause:
            return 7
        case .dropSet:
            return 8
        case .mechanical:
            return 8
        case .superset:
            return 9
        case .giant:
            return 10
        }
    }
    
    /// Nivel de dificultad técnica (1-5)
    public var difficultyLevel: Int {
        switch self {
        case .none:
            return 1
        case .pausedReps, .pyramid:
            return 2
        case .restPause, .dropSet, .twentyOneReps:
            return 3
        case .cluster, .mechanical:
            return 4
        case .superset, .giant:
            return 5
        }
    }
    
    /// Indica si es una técnica avanzada
    public var isAdvanced: Bool {
        intensityLevel >= 7
    }
    
    /// Indica si requiere un compañero/spotter
    public var requiresSpotter: Bool {
        switch self {
        case .dropSet, .restPause, .mechanical:
            return true
        default:
            return false
        }
    }
    
    /// Tiempo estimado adicional en segundos que añade esta técnica
    public var estimatedExtraTimeSeconds: Int {
        switch self {
        case .none:
            return 0
        case .pausedReps:
            return 15
        case .pyramid, .cluster:
            return 30
        case .twentyOneReps:
            return 20
        case .restPause:
            return 40
        case .dropSet:
            return 45
        case .mechanical:
            return 50
        case .superset:
            return 60
        case .giant:
            return 90
        }
    }
    
    /// Color sugerido para UI (nombre de color SF Symbols o hex)
    public var colorName: String {
        switch self {
        case .none:
            return "gray"
        case .pausedReps:
            return "blue"
        case .pyramid:
            return "purple"
        case .cluster:
            return "indigo"
        case .twentyOneReps:
            return "teal"
        case .restPause:
            return "cyan"
        case .dropSet:
            return "orange"
        case .mechanical:
            return "yellow"
        case .superset:
            return "red"
        case .giant:
            return "pink"
        }
    }
    
    /// Objetivo principal de la técnica
    public var mainGoal: String {
        switch self {
        case .none:
            return "Entrenamiento estándar"
        case .dropSet, .mechanical:
            return "Hipertrofia / Agotamiento muscular"
        case .superset, .giant:
            return "Eficiencia / Congestión"
        case .restPause:
            return "Volumen con cargas pesadas"
        case .pausedReps:
            return "Tiempo bajo tensión"
        case .pyramid:
            return "Fuerza y resistencia"
        case .cluster:
            return "Fuerza con volumen"
        case .twentyOneReps:
            return "Congestión / Pump"
        }
    }
    
    /// Nivel de experiencia recomendado
    public var recommendedLevel: String {
        switch difficultyLevel {
        case 1:
            return "Principiante"
        case 2:
            return "Principiante-Intermedio"
        case 3:
            return "Intermedio"
        case 4:
            return "Intermedio-Avanzado"
        case 5:
            return "Avanzado"
        default:
            return "Todos los niveles"
        }
    }
    
    /// Incremento de fatiga estimado (multiplicador, 1.0 = normal)
    public var fatigueMultiplier: Double {
        switch self {
        case .none:
            return 1.0
        case .pausedReps:
            return 1.2
        case .pyramid:
            return 1.3
        case .cluster:
            return 1.4
        case .twentyOneReps:
            return 1.5
        case .restPause:
            return 1.6
        case .dropSet:
            return 1.7
        case .mechanical:
            return 1.8
        case .superset:
            return 1.9
        case .giant:
            return 2.2
        }
    }
    
    // MARK: - Firestore Helper
    
    /// Convierte el enum a un formato para Firestore (ya usa rawValue automáticamente con Codable)
    public func toFirestoreValue() -> String {
        self.rawValue
    }
    
    /// Crea un enum desde un valor de Firestore
    public static func fromFirestoreValue(_ value: String) -> IntensityTechnique? {
        IntensityTechnique(rawValue: value)
    }
    
    /// Información completa para guardar en Firestore (opcional, para referencia)
    public func toDetailedDictionary() -> [String: Any] {
        [
            "rawValue": rawValue,
            "displayName": displayName,
            "intensityLevel": intensityLevel,
            "difficultyLevel": difficultyLevel,
            "estimatedExtraTimeSeconds": estimatedExtraTimeSeconds,
            "mainGoal": mainGoal,
            "requiresSpotter": requiresSpotter
        ]
    }
}

// MARK: - Extensions

extension IntensityTechnique {
    /// Técnicas recomendadas para principiantes
    public static var beginnerFriendly: [IntensityTechnique] {
        allCases.filter { $0.difficultyLevel <= 2 }
    }
    
    /// Técnicas intermedias
    public static var intermediate: [IntensityTechnique] {
        allCases.filter { $0.difficultyLevel == 3 }
    }
    
    /// Técnicas avanzadas
    public static var advanced: [IntensityTechnique] {
        allCases.filter { $0.difficultyLevel >= 4 }
    }
    
    /// Todas las técnicas excepto "none"
    public static var activeTechniques: [IntensityTechnique] {
        allCases.filter { $0 != .none }
    }
    
    /// Técnicas por objetivo (hipertrofia)
    public static var forHypertrophy: [IntensityTechnique] {
        [.dropSet, .mechanical, .restPause, .twentyOneReps]
    }
    
    /// Técnicas por objetivo (fuerza)
    public static var forStrength: [IntensityTechnique] {
        [.cluster, .restPause, .pyramid]
    }
    
    /// Técnicas por objetivo (resistencia)
    public static var forEndurance: [IntensityTechnique] {
        [.superset, .giant, .twentyOneReps]
    }
    
    /// Obtiene técnicas filtradas por nivel de intensidad máximo
    public static func techniques(maxIntensity level: Int) -> [IntensityTechnique] {
        allCases.filter { $0.intensityLevel <= level }
    }
    
    /// Obtiene técnicas filtradas por nivel de dificultad
    public static func techniques(forDifficulty level: Int) -> [IntensityTechnique] {
        allCases.filter { $0.difficultyLevel <= level }
    }
    
    /// Técnicas que no requieren compañero
    public static var soloFriendly: [IntensityTechnique] {
        allCases.filter { !$0.requiresSpotter }
    }
}

// MARK: - Identifiable conformance (útil para ForEach en SwiftUI)

extension IntensityTechnique: Identifiable {
    public var id: String { rawValue }
}

// MARK: - Comparable (para ordenar por intensidad)

extension IntensityTechnique: Comparable {
    public static func < (lhs: IntensityTechnique, rhs: IntensityTechnique) -> Bool {
        lhs.intensityLevel < rhs.intensityLevel
    }
}



