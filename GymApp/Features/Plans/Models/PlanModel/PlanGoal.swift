//
//  PlanGoal.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/10/25.
//

import Foundation

public enum PlanGoal: String, Codable, CaseIterable {
    case hypertrophy = "hypertrophy"
    case strength = "strength"
    case endurance = "endurance"
    case weightLoss = "weight_loss"
    case athletic = "athletic"
    case general = "general"
    case flexibility = "flexibility"
    case rehabilitation = "rehabilitation"
    
    // Nuevos objetivos
    case run5k = "run_5k"
    case run10k = "run_10k"
    case run21k = "run_21k"
    case marathon = "marathon"
    case ironman = "ironman"
    case mountainClimb = "mountain_climb"
    case fatLoss = "fat_loss"
    case mobility = "mobility"
    case wellness = "wellness"
    
    public var displayName: String {
        switch self {
        case .hypertrophy: return "Hipertrofia"
        case .strength: return "Fuerza"
        case .endurance: return "Resistencia"
        case .weightLoss: return "Pérdida de peso"
        case .athletic: return "Rendimiento atlético"
        case .general: return "Fitness general"
        case .flexibility: return "Flexibilidad"
        case .rehabilitation: return "Rehabilitación"
        case .run5k: return "Correr 5K"
        case .run10k: return "Correr 10K"
        case .run21k: return "Correr 21K"
        case .marathon: return "Correr maratón"
        case .ironman: return "Completar Ironman"
        case .mountainClimb: return "Subir montaña"
        case .fatLoss: return "Pérdida de grasa"
        case .mobility: return "Movilidad"
        case .wellness: return "Bienestar general"
        }
    }
    
    public var icon: String {
        switch self {
        case .hypertrophy: return "figure.strengthtraining.traditional"
        case .strength: return "flame.fill"
        case .endurance: return "heart.fill"
        case .weightLoss: return "chart.line.downtrend.xyaxis"
        case .athletic: return "trophy.fill"
        case .general: return "figure.walk"
        case .flexibility: return "figure.yoga"
        case .rehabilitation: return "cross.case.fill"
        case .run5k, .run10k, .run21k, .marathon: return "figure.run"
        case .ironman: return "bicycle.circle.fill"
        case .mountainClimb: return "mountain.2.fill"
        case .fatLoss: return "scalemass.fill"
        case .mobility: return "figure.cooldown"
        case .wellness: return "leaf.fill"
        }
    }
    
    public var description: String {
        switch self {
        case .hypertrophy:
            return "Aumentar masa muscular y volumen"
        case .strength:
            return "Incrementar fuerza máxima"
        case .endurance:
            return "Mejorar resistencia cardiovascular"
        case .weightLoss:
            return "Reducir grasa corporal"
        case .athletic:
            return "Mejorar rendimiento deportivo"
        case .general:
            return "Mantener forma física general"
        case .flexibility:
            return "Mejorar rango de movimiento"
        case .rehabilitation:
            return "Recuperación de lesiones"
        case .run5k:
            return "Prepararse para correr 5 kilómetros"
        case .run10k:
            return "Prepararse para correr 10 kilómetros"
        case .run21k:
            return "Prepararse para correr una media maratón (21K)"
        case .marathon:
            return "Prepararse para completar una maratón (42K)"
        case .ironman:
            return "Preparación para un triatlón Ironman"
        case .mountainClimb:
            return "Entrenamiento para subir una montaña"
        case .fatLoss:
            return "Reducir porcentaje de grasa corporal"
        case .mobility:
            return "Mejorar movilidad y salud articular"
        case .wellness:
            return "Promover bienestar físico y mental"
        }
    }
    
    public var color: String {
        switch self {
        case .hypertrophy: return "blue"
        case .strength: return "red"
        case .endurance: return "green"
        case .weightLoss: return "orange"
        case .athletic: return "purple"
        case .general: return "gray"
        case .flexibility: return "pink"
        case .rehabilitation: return "mint"
        case .run5k: return "teal"
        case .run10k: return "teal"
        case .run21k: return "cyan"
        case .marathon: return "indigo"
        case .ironman: return "black"
        case .mountainClimb: return "brown"
        case .fatLoss: return "yellow"
        case .mobility: return "lightBlue"
        case .wellness: return "green"
        }
    }
}
