//
//  File.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/10/25.
//

import Foundation

struct CardioDataset {
    static let activities: [PlanActivity.CardioActivity] = [
        // MARK: - Running
        PlanActivity.CardioActivity(
            type: .running,
            targetDistanceKm: 5.0,
            targetDurationMinutes: 30,
            targetPace: "6:00/km",
            intensity: .moderate,
            estimatedCalories: 350,
            notes: "Carrera continua a ritmo cómodo"
        ),
        
        PlanActivity.CardioActivity(
            type: .running,
            targetDistanceKm: 3.0,
            targetDurationMinutes: 15,
            targetPace: "5:00/km",
            intensity: .high,
            estimatedCalories: 250,
            notes: "Carrera rápida - tempo run"
        ),
        
        PlanActivity.CardioActivity(
            type: .running,
            targetDistanceKm: 10.0,
            targetDurationMinutes: 65,
            targetPace: "6:30/km",
            intensity: .moderate,
            estimatedCalories: 650,
            notes: "Long run - carrera larga de fin de semana"
        ),
        
        PlanActivity.CardioActivity(
            type: .running,
            targetDistanceKm: 4.0,
            targetDurationMinutes: 25,
            targetPace: "Variable",
            intensity: .interval,
            estimatedCalories: 400,
            notes: "Intervalos: 400m rápido + 200m recuperación x8"
        ),
        
        // MARK: - Cycling
        PlanActivity.CardioActivity(
            type: .cycling,
            targetDistanceKm: 20.0,
            targetDurationMinutes: 60,
            targetPace: "20 km/h",
            intensity: .moderate,
            estimatedCalories: 450,
            notes: "Rodada en ruta plana"
        ),
        
        PlanActivity.CardioActivity(
            type: .cycling,
            targetDistanceKm: 15.0,
            targetDurationMinutes: 40,
            targetPace: "22.5 km/h",
            intensity: .high,
            estimatedCalories: 500,
            notes: "Ciclismo con subidas incluidas"
        ),
        
        PlanActivity.CardioActivity(
            type: .cycling,
            targetDistanceKm: 30.0,
            targetDurationMinutes: 90,
            targetPace: "20 km/h",
            intensity: .moderate,
            estimatedCalories: 700,
            notes: "Rodada larga dominical"
        ),
        
        PlanActivity.CardioActivity(
            type: .cycling,
            targetDistanceKm: nil,
            targetDurationMinutes: 30,
            targetPace: "Variable",
            intensity: .interval,
            estimatedCalories: 400,
            notes: "HIIT en bicicleta estática: 30s sprint + 30s suave x20"
        ),
        
        // MARK: - Swimming
        PlanActivity.CardioActivity(
            type: .swimming,
            targetDistanceKm: 1.0,
            targetDurationMinutes: 30,
            targetPace: "2:00/100m",
            intensity: .moderate,
            estimatedCalories: 300,
            notes: "Nado continuo estilo libre"
        ),
        
        PlanActivity.CardioActivity(
            type: .swimming,
            targetDistanceKm: 1.5,
            targetDurationMinutes: 45,
            targetPace: "2:00/100m",
            intensity: .moderate,
            estimatedCalories: 450,
            notes: "Técnica mixta: libre, espalda, pecho"
        ),
        
        PlanActivity.CardioActivity(
            type: .swimming,
            targetDistanceKm: 0.5,
            targetDurationMinutes: 15,
            targetPace: "1:30/100m",
            intensity: .high,
            estimatedCalories: 200,
            notes: "Series cortas a alta intensidad"
        ),
        
        PlanActivity.CardioActivity(
            type: .swimming,
            targetDistanceKm: 2.0,
            targetDurationMinutes: 60,
            targetPace: "2:00/100m",
            intensity: .low,
            estimatedCalories: 400,
            notes: "Nado técnico - enfoque en forma"
        ),
        
        // MARK: - Walking
        PlanActivity.CardioActivity(
            type: .walking,
            targetDistanceKm: 5.0,
            targetDurationMinutes: 60,
            targetPace: "12:00/km",
            intensity: .low,
            estimatedCalories: 200,
            notes: "Caminata relajada en parque"
        ),
        
        PlanActivity.CardioActivity(
            type: .walking,
            targetDistanceKm: 8.0,
            targetDurationMinutes: 90,
            targetPace: "11:15/km",
            intensity: .moderate,
            estimatedCalories: 350,
            notes: "Caminata larga de fin de semana"
        ),
        
        PlanActivity.CardioActivity(
            type: .walking,
            targetDistanceKm: 3.0,
            targetDurationMinutes: 30,
            targetPace: "10:00/km",
            intensity: .moderate,
            estimatedCalories: 150,
            notes: "Power walking - caminata rápida"
        ),
        
        // MARK: - Hiking
        PlanActivity.CardioActivity(
            type: .hiking,
            targetDistanceKm: 10.0,
            targetDurationMinutes: 180,
            targetPace: "Variable",
            intensity: .moderate,
            estimatedCalories: 800,
            notes: "Senderismo con elevación moderada"
        ),
        
        PlanActivity.CardioActivity(
            type: .hiking,
            targetDistanceKm: 6.0,
            targetDurationMinutes: 120,
            targetPace: "Variable",
            intensity: .high,
            estimatedCalories: 600,
            notes: "Hiking en terreno montañoso"
        ),
        
        // MARK: - Rowing
        PlanActivity.CardioActivity(
            type: .rowing,
            targetDistanceKm: 5.0,
            targetDurationMinutes: 25,
            targetPace: "2:30/500m",
            intensity: .moderate,
            estimatedCalories: 350,
            notes: "Remo continuo a ritmo constante"
        ),
        
        PlanActivity.CardioActivity(
            type: .rowing,
            targetDistanceKm: 2.0,
            targetDurationMinutes: 10,
            targetPace: "2:00/500m",
            intensity: .high,
            estimatedCalories: 200,
            notes: "Remo de alta intensidad"
        ),
        
        PlanActivity.CardioActivity(
            type: .rowing,
            targetDistanceKm: nil,
            targetDurationMinutes: 20,
            targetPace: "Variable",
            intensity: .interval,
            estimatedCalories: 300,
            notes: "HIIT en remo: 500m fuerte + 1min descanso x6"
        ),
        
        // MARK: - Elliptical
        PlanActivity.CardioActivity(
            type: .elliptical,
            targetDistanceKm: nil,
            targetDurationMinutes: 30,
            targetPace: nil,
            intensity: .moderate,
            estimatedCalories: 300,
            notes: "Elíptica con resistencia media"
        ),
        
        PlanActivity.CardioActivity(
            type: .elliptical,
            targetDistanceKm: nil,
            targetDurationMinutes: 45,
            targetPace: nil,
            intensity: .low,
            estimatedCalories: 350,
            notes: "Cardio de baja intensidad"
        ),
        
        // MARK: - Stair Climber
        PlanActivity.CardioActivity(
            type: .stairClimber,
            targetDistanceKm: nil,
            targetDurationMinutes: 20,
            targetPace: nil,
            intensity: .high,
            estimatedCalories: 250,
            notes: "Escaladora a ritmo intenso"
        ),
        
        PlanActivity.CardioActivity(
            type: .stairClimber,
            targetDistanceKm: nil,
            targetDurationMinutes: 30,
            targetPace: nil,
            intensity: .moderate,
            estimatedCalories: 300,
            notes: "Escaladora con intervalos de resistencia"
        ),
        
        // MARK: - Jump Rope
        PlanActivity.CardioActivity(
            type: .jumpRope,
            targetDistanceKm: nil,
            targetDurationMinutes: 15,
            targetPace: nil,
            intensity: .high,
            estimatedCalories: 200,
            notes: "Saltos continuos con descansos cortos"
        ),
        
        PlanActivity.CardioActivity(
            type: .jumpRope,
            targetDistanceKm: nil,
            targetDurationMinutes: 20,
            targetPace: nil,
            intensity: .interval,
            estimatedCalories: 250,
            notes: "HIIT: 1min saltos + 30s descanso x10"
        ),
        
        // MARK: - Other/Mixed
        PlanActivity.CardioActivity(
            type: .other,
            targetDistanceKm: nil,
            targetDurationMinutes: 30,
            targetPace: nil,
            intensity: .moderate,
            estimatedCalories: 300,
            notes: "Clase de spinning indoor"
        ),
        
        PlanActivity.CardioActivity(
            type: .other,
            targetDistanceKm: nil,
            targetDurationMinutes: 45,
            targetPace: nil,
            intensity: .high,
            estimatedCalories: 400,
            notes: "Clase de CrossFit - WOD cardio-intensivo"
        ),
        
        PlanActivity.CardioActivity(
            type: .other,
            targetDistanceKm: nil,
            targetDurationMinutes: 60,
            targetPace: nil,
            intensity: .moderate,
            estimatedCalories: 350,
            notes: "Clase de Zumba o baile aeróbico"
        )
    ]
}


extension CardioDataset {
    /// Obtener actividad aleatoria
    static func random() -> PlanActivity.CardioActivity {
        activities.randomElement()!
    }
    
    /// Filtrar por tipo de cardio
    static func activities(ofType type: PlanActivity.CardioType) -> [PlanActivity.CardioActivity] {
        activities.filter { $0.type == type }
    }
    
    /// Filtrar por intensidad
    static func activities(withIntensity intensity: PlanActivity.CardioIntensity) -> [PlanActivity.CardioActivity] {
        activities.filter { $0.intensity == intensity }
    }
    
    /// Actividades cortas (< 30 min)
    static var shortActivities: [PlanActivity.CardioActivity] {
        activities.filter { ($0.targetDurationMinutes ?? 0) < 30 }
    }
    
    /// Actividades largas (> 60 min)
    static var longActivities: [PlanActivity.CardioActivity] {
        activities.filter { ($0.targetDurationMinutes ?? 0) > 60 }
    }
}
