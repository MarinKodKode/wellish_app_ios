//
//  RestDataSet.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/10/25.
//

import Foundation

struct RestDayDataset {
    static let activities: [PlanActivity.RestDay] = [
        // MARK: - Descanso Completo
        PlanActivity.RestDay(
            type: .complete,
            description: "Día de descanso total para recuperación muscular",
            suggestedActivities: ["Dormir 8+ horas", "Hidratación abundante", "Alimentación balanceada"]
        ),
        
        PlanActivity.RestDay(
            type: .complete,
            description: "Recuperación profunda después de semana intensa",
            suggestedActivities: ["Masaje de recuperación", "Sauna o baño caliente", "Meditación"]
        ),
        
        // MARK: - Descanso Activo
        PlanActivity.RestDay(
            type: .active,
            description: "Movimiento ligero para promover circulación",
            suggestedActivities: ["Caminar 20-30 min", "Bicicleta suave 15 min", "Natación ligera"]
        ),
        
        PlanActivity.RestDay(
            type: .active,
            description: "Actividad cardiovascular de baja intensidad",
            suggestedActivities: ["Caminar en parque", "Yoga flow suave", "Jugar con mascotas"]
        ),
        
        PlanActivity.RestDay(
            type: .active,
            description: "Recuperación activa cardiovascular",
            suggestedActivities: ["Caminata 30 min", "Bicicleta estática 20 min", "Elíptica suave"]
        ),
        
        // MARK: - Movilidad
        PlanActivity.RestDay(
            type: .mobility,
            description: "Trabajo de movilidad articular completo",
            suggestedActivities: [
                "Círculos de hombros 2x10",
                "Rotaciones de cadera 2x10",
                "Movilidad de tobillo 2x10",
                "Cat-cow stretches"
            ]
        ),
        
        PlanActivity.RestDay(
            type: .mobility,
            description: "Movilidad enfocada en tren superior",
            suggestedActivities: [
                "Dislocaciones con banda",
                "Rotaciones torácicas",
                "Movilidad de muñecas",
                "Neck mobility"
            ]
        ),
        
        PlanActivity.RestDay(
            type: .mobility,
            description: "Movilidad de tren inferior y core",
            suggestedActivities: [
                "90/90 hip stretches",
                "Cossack squats",
                "Frog stretch",
                "Dead bugs"
            ]
        ),
        
        // MARK: - Estiramientos
        PlanActivity.RestDay(
            type: .stretching,
            description: "Rutina de estiramientos de cuerpo completo",
            suggestedActivities: [
                "Estiramiento de isquiotibiales 30s x2",
                "Estiramiento de cuádriceps 30s x2",
                "Estiramiento de pecho 30s x2",
                "Child's pose 1 min"
            ]
        ),
        
        PlanActivity.RestDay(
            type: .stretching,
            description: "Estiramientos post-entrenamiento de piernas",
            suggestedActivities: [
                "Pigeon pose 1 min cada lado",
                "Mariposa sentado 2 min",
                "Estiramiento de psoas",
                "Forward fold"
            ]
        ),
        
        PlanActivity.RestDay(
            type: .stretching,
            description: "Sesión de yoga restaurativa",
            suggestedActivities: [
                "Yin yoga 30 min",
                "Respiración diafragmática",
                "Savasana 5-10 min"
            ]
        ),
        
        PlanActivity.RestDay(
            type: .stretching,
            description: "Estiramientos dinámicos y foam rolling",
            suggestedActivities: [
                "Foam rolling espalda 3 min",
                "Foam rolling cuádriceps 2 min",
                "Foam rolling IT band 2 min",
                "Estiramientos dinámicos"
            ]
        )
    ]
}

extension RestDayDataset {
    /// Obtener actividad aleatoria
    static func random() -> PlanActivity.RestDay {
        activities.randomElement()!
    }
    
    /// Filtrar por tipo
    static func activities(ofType type: PlanActivity.RestType) -> [PlanActivity.RestDay] {
        activities.filter { $0.type == type }
    }
}


// MARK: - Ejemplo de uso

/*
 // Para agregar una actividad de descanso aleatoria
 let restDay = RestDayDataset.random()
 viewModel.addActivityToPlan(.rest(restDay), forDay: 2)
 
 // Para agregar descanso activo específico
 let activeRest = RestDayDataset.activities(ofType: .active).first!
 viewModel.addActivityToPlan(.rest(activeRest), forDay: 4)
 
 // Para agregar cardio aleatorio
 let cardio = CardioDataset.random()
 viewModel.addActivityToPlan(.cardio(cardio), forDay: 3)
 
 // Para agregar running específico
 let running = CardioDataset.activities(ofType: .running).first!
 viewModel.addActivityToPlan(.cardio(running), forDay: 5)
 
 // Para agregar actividad de alta intensidad
 let hiit = CardioDataset.activities(withIntensity: .high).first!
 viewModel.addActivityToPlan(.cardio(hiit), forDay: 6)
 */
