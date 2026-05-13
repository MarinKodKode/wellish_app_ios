
import Foundation

class PlanDataset {
//    let gymTemplates = ActivityDataset.gymActivities
//    let runningTemplates = ActivityDataset.runningActivities
//    let restTemplates = ActivityDataset.restActivities
//    
    
//    func getPlans() -> [Plan] {
//        return [
//            Plan(
//                name: "Rutina PPL - 4 Días",
//                description: "Programa de 4 semanas para crecimiento muscular usando la división Push, Pull, Legs con un día de Full Body.",
//                category: "Gimnasio",
//                creator: "Wellish Pro",
//                tags: ["Hipertrofia", "Volumen", "PPL"],
//                thumbnailURL: "https://example.com/images/ppl.jpg",
//                notes: "Énfasis en la sobrecarga progresiva en los ejercicios compuestos.",
//                elements: [
//                    createPlanElement(day: 1, activity: gymTemplates[5]),
//                    createPlanElement(day: 2, activity: gymTemplates[6]),
//                    createPlanElement(day: 3, activity: restTemplates[0]),
//                    createPlanElement(day: 4, activity: gymTemplates[7]),
//                    createPlanElement(day: 5, activity: gymTemplates[3]),
//                    createPlanElement(day: 6, activity: restTemplates[1]),
//                    createPlanElement(day: 7, activity: restTemplates[0]),
//                ],
//                goal: .hypertrophy,
//                durationWeeks: 4,
//                activitiesPerWeek: 5,
//                shareable: true,
//                isPremiumPlan: true
//            ),
//
//            // MARK: - 2. Plan de Pérdida de Peso (6 Semanas)
//            Plan(
//                name: "Quema Grasa y Tono",
//                description: "Combinación de fuerza y cardio de alta intensidad (HIIT) para maximizar el déficit calórico.",
//                category: "Fitness",
//                creator: "User345",
//                tags: ["Pérdida de peso", "HIIT", "Cardio"],
//                thumbnailURL: "https://example.com/images/fatloss.jpg",
//                elements: [
//                    createPlanElement(day: 1, activity: gymTemplates[3]),
//                    createPlanElement(day: 2, activity: runningTemplates[1]),
//                    createPlanElement(day: 3, activity: restTemplates[0]), // Descanso Total
//                    createPlanElement(day: 4, activity: gymTemplates[2]), // Resistencia E/B (Alta rep)
//                    createPlanElement(day: 5, activity: runningTemplates[0], isCompleted: true), // Carrera 5K Lenta
//                    createPlanElement(day: 6, activity: gymTemplates[9]), // Estiramiento Total
//                    createPlanElement(day: 7, activity: restTemplates[0]), // Descanso Total
//                ],
//                goal: .fatLoss,
//                durationWeeks: 6,
//                activitiesPerWeek: 5,
//                shareable: true,
//                isPremiumPlan: false
//            ),
//            
//            // MARK: - 3. Plan de Running 21K (12 Semanas)
//            Plan(
//                name: "Media Maratón (21K) - Intermedio",
//                description: "Programa de 12 semanas enfocado en la distancia, aumentando el volumen de fondo semanalmente.",
//                category: "Cardio",
//                creator: "Endurance Masters",
//                tags: ["Endurance", "Running", "21K"],
//                thumbnailURL: "https://example.com/images/marathon.jpg",
//                elements: [
//                    createPlanElement(day: 1, activity: restTemplates[0]),
//                    createPlanElement(day: 2, activity: runningTemplates[0]), // Carrera 5K Lenta
//                    createPlanElement(day: 3, activity: gymTemplates[8]), // Calentamiento Articular (Movilidad)
//                    createPlanElement(day: 4, activity: runningTemplates[1]), // Intervalos Cortos
//                    createPlanElement(day: 5, activity: restTemplates[0]),
//                    createPlanElement(day: 6, activity: runningTemplates[2]), // Fondo 15K
//                    createPlanElement(day: 7, activity: restTemplates[0]),
//                ],
//                goal: .run21k,
//                durationWeeks: 12,
//                activitiesPerWeek: 3,
//                isPremiumPlan: true
//            ),
//
//            // MARK: - 4. Plan de Fuerza Pura (8 Semanas)
//            Plan(
//                name: "Strongman \n5x5",
//                description: "Aumento de la fuerza máxima en los tres levantamientos principales. Mínimo de cardio.",
//                category: "Powerlifting",
//                tags: ["Fuerza", "Powerlifting", "Básico"],
//                thumbnailURL: "https://images.unsplash.com/photo-1599058917212-d750089bc07e?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=2938",
//                elements: [
//                    createPlanElement(day: 1, activity: gymTemplates[1]), // Fuerza Pierna/Hombro (Pesado)
//                    createPlanElement(day: 2, activity: restTemplates[0]),
//                    createPlanElement(day: 3, activity: gymTemplates[0]), // Hipertrofia P/T (Auxiliar)
//                    createPlanElement(day: 4, activity: restTemplates[0]),
//                    createPlanElement(day: 5, activity: gymTemplates[3]), // Full Body Express
//                    createPlanElement(day: 6, activity: restTemplates[1]), // Rec. Activa: Yoga
//                    createPlanElement(day: 7, activity: restTemplates[0]),
//                ],
//                goal: .strength,
//                durationWeeks: 8,
//                activitiesPerWeek: 3,
//                shareable: true,
//                isBeingTracked: true,
//            ),
//            
//            // MARK: - 5. Plan de Movilidad y Flexibilidad (4 Semanas)
//            Plan(
//                name: "Movilidad Completa y Postura",
//                description: "Un plan de 4 semanas para mejorar el rango de movimiento articular y la postura.",
//                category: "Wellness",
//                tags: ["Movilidad", "Flexibilidad", "Rehabilitación"],
//                elements: [
//                    createPlanElement(day: 1, activity: gymTemplates[8]), // Calentamiento Articular
//                    createPlanElement(day: 2, activity: restTemplates[1]), // Rec. Activa: Yoga
//                    createPlanElement(day: 3, activity: restTemplates[0]),
//                    createPlanElement(day: 4, activity: gymTemplates[9]), // Estiramiento Total
//                    createPlanElement(day: 5, activity: restTemplates[1]), // Rec. Activa: Yoga
//                    createPlanElement(day: 6, activity: restTemplates[0]),
//                    createPlanElement(day: 7, activity: restTemplates[0]),
//                ],
//                goal: .mobility,
//                durationWeeks: 4,
//                activitiesPerWeek: 4,
//                isPremiumPlan: false
//            ),
//            
//            // MARK: - 6. Plan Full Body para Principiantes (4 Semanas)
//            Plan(
//                name: "Iniciación al Gimnasio",
//                description: "Programa de iniciación para familiarizarse con los equipos y la técnica básica, 3 veces por semana.",
//                category: "Gimnasio",
//                creator: "Dr. Fitness",
//                tags: ["Principiante", "General", "FullBody"],
//                elements: [
//                    createPlanElement(day: 1, activity: gymTemplates[3]), // Full Body Express
//                    createPlanElement(day: 2, activity: restTemplates[0]),
//                    createPlanElement(day: 3, activity: gymTemplates[1]), // Fuerza Pierna/Hombro (Adaptado)
//                    createPlanElement(day: 4, activity: restTemplates[0]),
//                    createPlanElement(day: 5, activity: gymTemplates[0]), // Hipertrofia P/T (Adaptado)
//                    createPlanElement(day: 6, activity: restTemplates[1]),
//                    createPlanElement(day: 7, activity: restTemplates[0]),
//                ],
//                goal: .general,
//                durationWeeks: 4,
//                activitiesPerWeek: 3,
//                shareable: true
//            ),
//
//            // MARK: - 7. Plan de Resistencia (6 Semanas)
//            Plan(
//                name: "Endurance Circuit",
//                description: "Mejora la capacidad cardiovascular y la resistencia muscular a través de circuitos.",
//                category: "Fitness",
//                tags: ["Resistencia", "Endurance", "Circuito"],
//                elements: [
//                    createPlanElement(day: 1, activity: gymTemplates[2]), // Resistencia E/B
//                    createPlanElement(day: 2, activity: runningTemplates[0]), // Carrera 5K Lenta
//                    createPlanElement(day: 3, activity: restTemplates[0]),
//                    createPlanElement(day: 4, activity: gymTemplates[4]), // Glúteo & Abdomen
//                    createPlanElement(day: 5, activity: runningTemplates[1]), // Intervalos Cortos
//                    createPlanElement(day: 6, activity: restTemplates[1]),
//                    createPlanElement(day: 7, activity: restTemplates[0]),
//                ],
//                goal: .endurance,
//                durationWeeks: 6,
//                activitiesPerWeek: 4,
//                isPremiumPlan: true
//            ),
//
//            // MARK: - 8. Plan de Rehabilitación (2 Semanas)
//            Plan(
//                name: "Recuperación Post-Lesión",
//                description: "Foco en la estabilidad y fortalecimiento de zona media, baja intensidad. Consultar con especialista.",
//                category: "Rehabilitación",
//                creator: "PhysioPro",
//                tags: ["Rehabilitación", "Movilidad", "Baja Intensidad"],
//                elements: [
//                    createPlanElement(day: 1, activity: gymTemplates[8]), // Calentamiento Articular (Rehab)
//                    createPlanElement(day: 2, activity: restTemplates[0]),
//                    createPlanElement(day: 3, activity: gymTemplates[9]), // Estiramiento Total (Rehab)
//                    createPlanElement(day: 4, activity: restTemplates[1]), // Rec. Activa: Yoga
//                    createPlanElement(day: 5, activity: restTemplates[0]),
//                    createPlanElement(day: 6, activity: gymTemplates[4]), // Glúteo & Abdomen (Fortalecimiento)
//                    createPlanElement(day: 7, activity: restTemplates[0]),
//                ],
//                goal: .rehabilitation,
//                durationWeeks: 2,
//                activitiesPerWeek: 4,
//                isPremiumPlan: true
//            ),
//            
//            // MARK: - 9. Plan de Maratón (20 Semanas)
//            Plan(
//                name: "Entrenamiento para Maratón (42K)",
//                description: "Programa de alta dedicación, 20 semanas para alcanzar la distancia de maratón. Alto volumen de running.",
//                category: "Cardio",
//                tags: ["Marathon", "Running", "Atlético"],
//                elements: [
//                    createPlanElement(day: 1, activity: runningTemplates[0]),
//                    createPlanElement(day: 2, activity: restTemplates[1]),
//                    createPlanElement(day: 3, activity: runningTemplates[1]),
//                    createPlanElement(day: 4, activity: restTemplates[0]),
//                    createPlanElement(day: 5, activity: runningTemplates[0]),
//                    createPlanElement(day: 6, activity: runningTemplates[2]), // Fondo 15K (semanas iniciales)
//                    createPlanElement(day: 7, activity: restTemplates[0]),
//                ],
//                goal: .marathon,
//                durationWeeks: 20,
//                activitiesPerWeek: 5,
//                shareable: true
//            ),
//            
//            // MARK: - 10. Plan de Fitness General Rápido (4 Semanas)
//            Plan(
//                name: "Mantenimiento Fitness - 30 Minutos",
//                description: "Rutinas rápidas y eficientes de 30 minutos para mantener el estado físico general.",
//                category: "General",
//                tags: ["General", "Express", "Mantenimiento"],
//                elements: [
//                    createPlanElement(day: 1, activity: gymTemplates[3]), // Full Body Express
//                    createPlanElement(day: 2, activity: restTemplates[0]),
//                    createPlanElement(day: 3, activity: runningTemplates[1]), // Intervalos Cortos
//                    createPlanElement(day: 4, activity: restTemplates[0]),
//                    createPlanElement(day: 5, activity: gymTemplates[8]), // Calentamiento Articular
//                    createPlanElement(day: 6, activity: restTemplates[1]), // Rec. Activa: Yoga
//                    createPlanElement(day: 7, activity: restTemplates[0]),
//                ],
//                goal: .general,
//                durationWeeks: 4,
//                activitiesPerWeek: 4
//            ),
//        ]
//    }
//    
    
    func getPlans() -> [Plan] {
        return []
    }
    func createPlanElement(day: Int, activity: any Activity, isCompleted: Bool = false) -> PlanElement {
        let activityType: ActivityType
        switch activity.activityType {
        case .gym:
            activityType = .gym(activity as! GymActivity)
        case .running:
            activityType = .running(activity as! RunningActivity)
        case .rest:
            activityType = .rest(activity as! RestActivity)
        default:
            activityType = .rest(RestActivity(name: "Error", restType: .complete))
        }
        
        return PlanElement(
            activity: activityType,
            day: day,
            scheduledTime: nil, // Simplificado, puedes agregar hora si lo deseas
            completed: isCompleted
        )
    }
}


