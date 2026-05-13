//
//  ActivitiesSet.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/10/25.
//

import Foundation

// MARK: - Cardio Activities
public let cardioActivities: [PlanActivity] = [
    // Running
    .cardio(PlanActivity.CardioActivity(
        type: .running,
        targetDistanceKm: 5.0,
        targetDurationMinutes: 30,
        targetPace: "6:00/km",
        intensity: .moderate,
        estimatedCalories: 350,
        notes: "Carrera continua a ritmo cómodo"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .running,
        targetDistanceKm: 3.0,
        targetDurationMinutes: 15,
        targetPace: "5:00/km",
        intensity: .high,
        estimatedCalories: 250,
        notes: "Carrera rápida - tempo run"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .running,
        targetDistanceKm: 10.0,
        targetDurationMinutes: 65,
        targetPace: "6:30/km",
        intensity: .moderate,
        estimatedCalories: 650,
        notes: "Long run - carrera larga de fin de semana"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .running,
        targetDistanceKm: 4.0,
        targetDurationMinutes: 25,
        targetPace: "Variable",
        intensity: .interval,
        estimatedCalories: 400,
        notes: "Intervalos: 400m rápido + 200m recuperación x8"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .running,
        targetDistanceKm: 7.5,
        targetDurationMinutes: 45,
        targetPace: "6:00/km",
        intensity: .moderate,
        estimatedCalories: 500,
        notes: "Carrera de media distancia"
    )),
    
    // Cycling
    .cardio(PlanActivity.CardioActivity(
        type: .cycling,
        targetDistanceKm: 20.0,
        targetDurationMinutes: 60,
        targetPace: "20 km/h",
        intensity: .moderate,
        estimatedCalories: 450,
        notes: "Rodada en ruta plana"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .cycling,
        targetDistanceKm: 15.0,
        targetDurationMinutes: 40,
        targetPace: "22.5 km/h",
        intensity: .high,
        estimatedCalories: 500,
        notes: "Ciclismo con subidas incluidas"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .cycling,
        targetDistanceKm: 30.0,
        targetDurationMinutes: 90,
        targetPace: "20 km/h",
        intensity: .moderate,
        estimatedCalories: 700,
        notes: "Rodada larga dominical"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .cycling,
        targetDistanceKm: nil,
        targetDurationMinutes: 30,
        targetPace: "Variable",
        intensity: .interval,
        estimatedCalories: 400,
        notes: "HIIT en bicicleta estática: 30s sprint + 30s suave x20"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .cycling,
        targetDistanceKm: 40.0,
        targetDurationMinutes: 120,
        targetPace: "20 km/h",
        intensity: .moderate,
        estimatedCalories: 850,
        notes: "Rodada de resistencia"
    )),
    
    // Swimming
    .cardio(PlanActivity.CardioActivity(
        type: .swimming,
        targetDistanceKm: 1.0,
        targetDurationMinutes: 30,
        targetPace: "2:00/100m",
        intensity: .moderate,
        estimatedCalories: 300,
        notes: "Nado continuo estilo libre"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .swimming,
        targetDistanceKm: 1.5,
        targetDurationMinutes: 45,
        targetPace: "2:00/100m",
        intensity: .moderate,
        estimatedCalories: 450,
        notes: "Técnica mixta: libre, espalda, pecho"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .swimming,
        targetDistanceKm: 0.5,
        targetDurationMinutes: 15,
        targetPace: "1:30/100m",
        intensity: .high,
        estimatedCalories: 200,
        notes: "Series cortas a alta intensidad"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .swimming,
        targetDistanceKm: 2.0,
        targetDurationMinutes: 60,
        targetPace: "2:00/100m",
        intensity: .low,
        estimatedCalories: 400,
        notes: "Nado técnico - enfoque en forma"
    )),
    
    // Walking
    .cardio(PlanActivity.CardioActivity(
        type: .walking,
        targetDistanceKm: 5.0,
        targetDurationMinutes: 60,
        targetPace: "12:00/km",
        intensity: .low,
        estimatedCalories: 200,
        notes: "Caminata relajada en parque"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .walking,
        targetDistanceKm: 8.0,
        targetDurationMinutes: 90,
        targetPace: "11:15/km",
        intensity: .moderate,
        estimatedCalories: 350,
        notes: "Caminata larga de fin de semana"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .walking,
        targetDistanceKm: 3.0,
        targetDurationMinutes: 30,
        targetPace: "10:00/km",
        intensity: .moderate,
        estimatedCalories: 150,
        notes: "Power walking - caminata rápida"
    )),
    
    // Hiking
    .cardio(PlanActivity.CardioActivity(
        type: .hiking,
        targetDistanceKm: 10.0,
        targetDurationMinutes: 180,
        targetPace: "Variable",
        intensity: .moderate,
        estimatedCalories: 800,
        notes: "Senderismo con elevación moderada"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .hiking,
        targetDistanceKm: 6.0,
        targetDurationMinutes: 120,
        targetPace: "Variable",
        intensity: .high,
        estimatedCalories: 600,
        notes: "Hiking en terreno montañoso"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .hiking,
        targetDistanceKm: 15.0,
        targetDurationMinutes: 240,
        targetPace: "Variable",
        intensity: .moderate,
        estimatedCalories: 1000,
        notes: "Caminata larga de día completo"
    )),
    
    // Rowing
    .cardio(PlanActivity.CardioActivity(
        type: .rowing,
        targetDistanceKm: 5.0,
        targetDurationMinutes: 25,
        targetPace: "2:30/500m",
        intensity: .moderate,
        estimatedCalories: 350,
        notes: "Remo continuo a ritmo constante"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .rowing,
        targetDistanceKm: 2.0,
        targetDurationMinutes: 10,
        targetPace: "2:00/500m",
        intensity: .high,
        estimatedCalories: 200,
        notes: "Remo de alta intensidad"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .rowing,
        targetDistanceKm: nil,
        targetDurationMinutes: 20,
        targetPace: "Variable",
        intensity: .interval,
        estimatedCalories: 300,
        notes: "HIIT en remo: 500m fuerte + 1min descanso x6"
    )),
    
    // Elliptical
    .cardio(PlanActivity.CardioActivity(
        type: .elliptical,
        targetDistanceKm: nil,
        targetDurationMinutes: 30,
        targetPace: nil,
        intensity: .moderate,
        estimatedCalories: 300,
        notes: "Elíptica con resistencia media"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .elliptical,
        targetDistanceKm: nil,
        targetDurationMinutes: 45,
        targetPace: nil,
        intensity: .low,
        estimatedCalories: 350,
        notes: "Cardio de baja intensidad"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .elliptical,
        targetDistanceKm: nil,
        targetDurationMinutes: 20,
        targetPace: nil,
        intensity: .high,
        estimatedCalories: 280,
        notes: "HIIT en elíptica"
    )),
    
    // Stair Climber
    .cardio(PlanActivity.CardioActivity(
        type: .stairClimber,
        targetDistanceKm: nil,
        targetDurationMinutes: 20,
        targetPace: nil,
        intensity: .high,
        estimatedCalories: 250,
        notes: "Escaladora a ritmo intenso"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .stairClimber,
        targetDistanceKm: nil,
        targetDurationMinutes: 30,
        targetPace: nil,
        intensity: .moderate,
        estimatedCalories: 300,
        notes: "Escaladora con intervalos de resistencia"
    )),
    
    // Jump Rope
    .cardio(PlanActivity.CardioActivity(
        type: .jumpRope,
        targetDistanceKm: nil,
        targetDurationMinutes: 15,
        targetPace: nil,
        intensity: .high,
        estimatedCalories: 200,
        notes: "Saltos continuos con descansos cortos"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .jumpRope,
        targetDistanceKm: nil,
        targetDurationMinutes: 20,
        targetPace: nil,
        intensity: .interval,
        estimatedCalories: 250,
        notes: "HIIT: 1min saltos + 30s descanso x10"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .jumpRope,
        targetDistanceKm: nil,
        targetDurationMinutes: 10,
        targetPace: nil,
        intensity: .moderate,
        estimatedCalories: 150,
        notes: "Calentamiento con cuerda"
    )),
    
    // Other
    .cardio(PlanActivity.CardioActivity(
        type: .other,
        targetDistanceKm: nil,
        targetDurationMinutes: 30,
        targetPace: nil,
        intensity: .moderate,
        estimatedCalories: 300,
        notes: "Clase de spinning indoor"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .other,
        targetDistanceKm: nil,
        targetDurationMinutes: 45,
        targetPace: nil,
        intensity: .high,
        estimatedCalories: 400,
        notes: "Clase de CrossFit - WOD cardio-intensivo"
    )),
    .cardio(PlanActivity.CardioActivity(
        type: .other,
        targetDistanceKm: nil,
        targetDurationMinutes: 60,
        targetPace: nil,
        intensity: .moderate,
        estimatedCalories: 350,
        notes: "Clase de Zumba o baile aeróbico"
    )),
]

// MARK: - Rest Activities
public let restActivities: [PlanActivity] = [
    // Complete Rest
    .rest(PlanActivity.RestDay(
        type: .complete,
        description: "Día de descanso total para recuperación muscular",
        suggestedActivities: ["Dormir 8+ horas", "Hidratación abundante", "Alimentación balanceada"]
    )),
    .rest(PlanActivity.RestDay(
        type: .complete,
        description: "Recuperación profunda después de semana intensa",
        suggestedActivities: ["Masaje de recuperación", "Sauna o baño caliente", "Meditación"]
    )),
    .rest(PlanActivity.RestDay(
        type: .complete,
        description: "Descanso mental y físico",
        suggestedActivities: ["Lectura", "Respiración consciente", "Dormir temprano"]
    )),
    
    // Active Rest
    .rest(PlanActivity.RestDay(
        type: .active,
        description: "Movimiento ligero para promover circulación",
        suggestedActivities: ["Caminar 20-30 min", "Bicicleta suave 15 min", "Natación ligera"]
    )),
    .rest(PlanActivity.RestDay(
        type: .active,
        description: "Actividad cardiovascular de baja intensidad",
        suggestedActivities: ["Caminar en parque", "Yoga flow suave", "Jugar con mascotas"]
    )),
    .rest(PlanActivity.RestDay(
        type: .active,
        description: "Recuperación activa cardiovascular",
        suggestedActivities: ["Caminata 30 min", "Bicicleta estática 20 min", "Elíptica suave"]
    )),
    .rest(PlanActivity.RestDay(
        type: .active,
        description: "Día de movimiento recreativo",
        suggestedActivities: ["Deportes ligeros", "Paddle board", "Kayak tranquilo"]
    )),
    
    // Mobility
    .rest(PlanActivity.RestDay(
        type: .mobility,
        description: "Trabajo de movilidad articular completo",
        suggestedActivities: [
            "Círculos de hombros 2x10",
            "Rotaciones de cadera 2x10",
            "Movilidad de tobillo 2x10",
            "Cat-cow stretches"
        ]
    )),
    .rest(PlanActivity.RestDay(
        type: .mobility,
        description: "Movilidad enfocada en tren superior",
        suggestedActivities: [
            "Dislocaciones con banda",
            "Rotaciones torácicas",
            "Movilidad de muñecas",
            "Neck mobility"
        ]
    )),
    .rest(PlanActivity.RestDay(
        type: .mobility,
        description: "Movilidad de tren inferior y core",
        suggestedActivities: [
            "90/90 hip stretches",
            "Cossack squats",
            "Frog stretch",
            "Dead bugs"
        ]
    )),
    .rest(PlanActivity.RestDay(
        type: .mobility,
        description: "Sesión de movilidad dinámica",
        suggestedActivities: [
            "Leg swings",
            "Arm circles",
            "Spinal rotations",
            "Ankle rocks"
        ]
    )),
    
    // Stretching
    .rest(PlanActivity.RestDay(
        type: .stretching,
        description: "Rutina de estiramientos de cuerpo completo",
        suggestedActivities: [
            "Estiramiento de isquiotibiales 30s x2",
            "Estiramiento de cuádriceps 30s x2",
            "Estiramiento de pecho 30s x2",
            "Child's pose 1 min"
        ]
    )),
    .rest(PlanActivity.RestDay(
        type: .stretching,
        description: "Estiramientos post-entrenamiento de piernas",
        suggestedActivities: [
            "Pigeon pose 1 min cada lado",
            "Mariposa sentado 2 min",
            "Estiramiento de psoas",
            "Forward fold"
        ]
    )),
    .rest(PlanActivity.RestDay(
        type: .stretching,
        description: "Sesión de yoga restaurativa",
        suggestedActivities: [
            "Yin yoga 30 min",
            "Respiración diafragmática",
            "Savasana 5-10 min"
        ]
    )),
    .rest(PlanActivity.RestDay(
        type: .stretching,
        description: "Estiramientos dinámicos y foam rolling",
        suggestedActivities: [
            "Foam rolling espalda 3 min",
            "Foam rolling cuádriceps 2 min",
            "Foam rolling IT band 2 min",
            "Estiramientos dinámicos"
        ]
    )),
    .rest(PlanActivity.RestDay(
        type: .stretching,
        description: "Estiramiento profundo de caderas",
        suggestedActivities: [
            "Figure-4 stretch",
            "Happy baby pose",
            "Frog stretch",
            "Lizard pose"
        ]
    )),
    .rest(PlanActivity.RestDay(
        type: .stretching,
        description: "Estiramientos de tren superior",
        suggestedActivities: [
            "Doorway chest stretch",
            "Triceps stretch",
            "Shoulder stretches",
            "Neck stretches"
        ]
    )),
]

// MARK: - All Activities Combined
public let allPlanActivities: [PlanActivity] = cardioActivities + restActivities

// MARK: - Filtered Helpers
public extension Array where Element == PlanActivity {
    /// Filtrar por tipo de cardio
    func cardio(ofType type: PlanActivity.CardioType) -> [PlanActivity] {
        self.compactMap { activity in
            if case .cardio(let cardio) = activity, cardio.type == type {
                return activity
            }
            return nil
        }
    }
    
    /// Filtrar por tipo de descanso
    func rest(ofType type: PlanActivity.RestType) -> [PlanActivity] {
        self.compactMap { activity in
            if case .rest(let rest) = activity, rest.type == type {
                return activity
            }
            return nil
        }
    }
    
    /// Filtrar por intensidad de cardio
    func cardio(withIntensity intensity: PlanActivity.CardioIntensity) -> [PlanActivity] {
        self.compactMap { activity in
            if case .cardio(let cardio) = activity, cardio.intensity == intensity {
                return activity
            }
            return nil
        }
    }
    
    /// Solo actividades de cardio
    var cardioOnly: [PlanActivity] {
        self.filter {
            if case .cardio = $0 { return true }
            return false
        }
    }
    
    /// Solo actividades de descanso
    var restOnly: [PlanActivity] {
        self.filter {
            if case .rest = $0 { return true }
            return false
        }
    }
    
    /// Solo rutinas
    var routinesOnly: [PlanActivity] {
        self.filter {
            if case .routine = $0 { return true }
            return false
        }
    }
    
    /// Solo ejercicios
    var exercisesOnly: [PlanActivity] {
        self.filter {
            if case .exercise = $0 { return true }
            return false
        }
    }
}

// MARK: - Usage Examples
/*
 // Usar todas las actividades
 ForEach(allPlanActivities) { activity in
     ActivityRow(activity: activity)
 }
 
 // Solo cardio
 ForEach(cardioActivities) { activity in
     ActivityRow(activity: activity)
 }
 
 // Solo descanso
 ForEach(restActivities) { activity in
     ActivityRow(activity: activity)
 }
 
 // Filtrar running
 let runningActivities = allPlanActivities.cardio(ofType: .running)
 
 // Filtrar alta intensidad
 let hiitActivities = allPlanActivities.cardio(withIntensity: .interval)
 
 // Solo descanso activo
 let activeRests = allPlanActivities.rest(ofType: .active)
 */
