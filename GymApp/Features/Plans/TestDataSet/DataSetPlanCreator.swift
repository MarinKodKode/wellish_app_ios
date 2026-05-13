//
//  DataSetPlanCreator.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 24/10/25.
//

import Foundation

//
//struct ActivityDataset {
//    
//    static let runningActivities: [RunningActivity] = [
//        
//        RunningActivity(
//            id: "run_001",
//            name: "Easy Run Matutino",
//            description: "Carrera suave de recuperación a ritmo conversacional. Ideal para días después de entrenamientos intensos.",
//            tags: ["Recuperación", "Matutino", "Fácil"],
//            runningType: .recovery,
//            targetDistanceKm: 5.0,
//            targetDurationMinutes: 35,
//            targetPaceMinPerKm: "7:00",
//            intensity: .low,
//            terrain: .road,
//            estimatedCalories: 350,
//            source: .created,
//            shareable: true
//        ),
//        
//        // 2. Tempo Run - Carrera a ritmo tempo
//        RunningActivity(
//            id: "run_002",
//            name: "5K Tempo",
//            description: "Carrera a ritmo tempo para mejorar umbral de lactato. Mantén un esfuerzo sostenido pero controlado.",
//            tags: ["Tempo", "Velocidad", "Avanzado"],
//            runningType: .tempo,
//            targetDistanceKm: 5.0,
//            targetDurationMinutes: 30,
//            targetPaceMinPerKm: "6:00",
//            intensity: .high,
//            terrain: .road,
//            estimatedCalories: 450,
//            source: .created,
//            shareable: true
//        ),
//        
//        // 3. Long Run - Carrera larga de fin de semana
//        RunningActivity(
//            id: "run_003",
//            name: "Long Run Dominical",
//            description: "Carrera larga a ritmo cómodo para construir resistencia aeróbica. Hidrátate bien antes, durante y después.",
//            tags: ["Resistencia", "Domingo", "Fondista"],
//            runningType: .longRun,
//            targetDistanceKm: 15.0,
//            targetDurationMinutes: 105,
//            targetPaceMinPerKm: "7:00",
//            intensity: .moderate,
//            terrain: .mixed,
//            elevationGainMeters: 150,
//            estimatedCalories: 1050,
//            source: .created,
//            shareable: true
//        ),
//        
//        // 4. Interval Training - Intervalos en pista
//        RunningActivity(
//            id: "run_004",
//            name: "Intervalos 400m",
//            description: "Sesión de intervalos de 400m para mejorar velocidad y VO2 max. 8 repeticiones con recuperación activa.",
//            tags: ["Intervalos", "Pista", "VO2max", "Avanzado"],
//            runningType: .intervals,
//            targetDistanceKm: 6.0,
//            targetDurationMinutes: 40,
//            targetPaceMinPerKm: "5:00",
//            intensity: .interval,
//            terrain: .track,
//            intervals: [
//                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
//                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
//                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
//                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
//                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
//                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
//                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2),
//                RunningInterval(durationMinutes: 2, paceMinPerKm: "4:30", recoveryMinutes: 2)
//            ],
//            estimatedCalories: 550,
//            source: .template,
//            globalActivityId: "template_run_004",
//            shareable: true
//        )
//    ]
//    
//    // MARK: - Rest Activities
//    
//    static let restActivities: [RestActivity] = [
//        
//        // 1. Complete Rest - Descanso total
//        RestActivity(
//            id: "rest_001",
//            name: "Descanso Total",
//            description: "Día completo de descanso. Tu cuerpo necesita tiempo para recuperarse y adaptarse al entrenamiento.",
//            tags: ["Recuperación", "Sueño", "Hidratación"],
//            restType: .complete,
//            suggestedActivities: [
//                "Dormir 8-9 horas",
//                "Mantener buena hidratación",
//                "Nutrición adecuada",
//                "Caminata muy ligera si es necesario"
//            ],
//            recoveryNotes: "Enfócate en dormir bien, comer saludable y mantenerte hidratado. Evita cualquier actividad física intensa.",
//            source: .created,
//            shareable: true
//        ),
//        
//        // 2. Active Recovery - Descanso activo
//        RestActivity(
//            id: "rest_002",
//            name: "Recuperación Activa",
//            description: "Movimiento ligero para promover la circulación sanguínea y acelerar la recuperación muscular.",
//            tags: ["Activo", "Circulación", "Ligero"],
//            restType: .active,
//            suggestedActivities: [
//                "Caminata de 20-30 minutos",
//                "Natación suave",
//                "Yoga restaurativo",
//                "Bicicleta a ritmo muy suave"
//            ],
//            suggestedDurationMinutes: 30,
//            targetAreas: [.fullBody, .legs, .back],
//            recoveryNotes: "Mantén la intensidad muy baja. El objetivo es moverse, no entrenar. RPE debe ser 3-4/10.",
//            source: .template,
//            globalActivityId: "template_rest_002",
//            shareable: true
//        ),
//        
//        // 3. Mobility Session - Movilidad completa
//        RestActivity(
//            id: "rest_003",
//            name: "Sesión de Movilidad",
//            description: "Trabajo completo de movilidad articular para mejorar rango de movimiento y prevenir lesiones.",
//            tags: ["Movilidad", "Prevención", "Articulaciones"],
//            restType: .mobility,
//            suggestedActivities: [
//                "Círculos de cadera (10 cada lado)",
//                "Rotaciones de hombros (15 repeticiones)",
//                "Movilidad de tobillo (2 min por lado)",
//                "Cat-cow stretches (15 repeticiones)",
//                "90/90 hip switches (10 cada lado)",
//                "Thoracic rotations (10 cada lado)"
//            ],
//            suggestedDurationMinutes: 20,
//            targetAreas: [.hips, .shoulders, .back, .core],
//            recoveryNotes: "Realiza cada movimiento de forma controlada y consciente. No fuerces, busca amplitud natural.",
//            source: .template,
//            globalActivityId: "template_rest_003",
//            shareable: true
//        ),
//        
//        // 4. Foam Rolling - Liberación miofascial
//        RestActivity(
//            id: "rest_004",
//            name: "Foam Rolling Tren Inferior",
//            description: "Liberación miofascial enfocada en piernas para reducir tensión y mejorar recuperación post-carrera.",
//            tags: ["Foam Roller", "Miofascial", "Piernas", "Post-Run"],
//            restType: .foam,
//            suggestedActivities: [
//                "Rodillo en cuádriceps (2 min por pierna)",
//                "Rodillo en isquiotibiales (2 min por pierna)",
//                "Rodillo en banda iliotibial (IT band) (1.5 min por lado)",
//                "Rodillo en glúteos (2 min por lado)",
//                "Rodillo en pantorrillas (2 min por pierna)",
//                "Bola de lacrosse en planta del pie (1 min por pie)"
//            ],
//            suggestedDurationMinutes: 15,
//            targetAreas: [.quads, .hamstrings, .glutes, .calves],
//            recoveryNotes: "Respira profundo durante el rodillo. Si encuentras puntos de tensión, mantén presión 20-30 segundos.",
//            source: .created,
//            shareable: true
//        )
//    ]
//    
//    static let gymActivities: [GymActivity] = [
//    
//    // --- 1. Espalda y Bíceps: Fuerza ---
//    GymActivity(
//        name: "Espalda y Bíceps: Fuerza Bruta",
//        description: "Foco en peso muerto, remos y poleas con énfasis en la fuerza y técnicas de Rest-Pause.",
//        sets: [
//            RoutineSet(
//                exercise: Exercise(id: "ex101", name: "Peso Muerto", category: .strength, equipment: "Barra y discos", muscles: ["Espalda baja", "Glúteos", "Isquiotibiales"]),
//                series: [
//                    Serie(repetitions: 5, idealWeightKg: 100.0, restSeconds: 180, rpe: 8),
//                    Serie(repetitions: 5, idealWeightKg: 110.0, restSeconds: 180, rpe: 9),
//                    Serie(repetitions: 5, idealWeightKg: 110.0, restSeconds: 180, rpe: 9)
//                ],
//                restBetweenSeriesSeconds: 180
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex102", name: "Remo con Barra (Pendlay)", category: .back, equipment: "Barra y discos", muscles: ["Dorsales", "Trapecio"], instructions: "Mantener el torso paralelo al suelo."),
//                series: [
//                    Serie(repetitions: 8, idealWeightKg: 60.0, restSeconds: 120),
//                    Serie(repetitions: 8, idealWeightKg: 65.0, restSeconds: 120),
//                    Serie(repetitions: 8, idealWeightKg: 65.0, restSeconds: 120)
//                ],
//                restBetweenSeriesSeconds: 120
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex103", name: "Jalón al Pecho Agarre Neutro", category: .back, equipment: "Máquina de polea", muscles: ["Dorsales", "Bíceps"]),
//                series: [
//                    Serie(repetitions: 10, idealWeightKg: 50.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 55.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 55.0, restSeconds: 90)
//                ],
//                restBetweenSeriesSeconds: 90,
//                notes: "Aplicar Rest-Pause en la última serie.",
//                intensityTechnique: .restPause
//                
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex104", name: "Curl de Bíceps con Mancuernas", category: .arms, equipment: "Mancuernas", muscles: ["Bíceps"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 15.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 15.0, restSeconds: 60),
//                    Serie(repetitions: 10, idealWeightKg: 17.5, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex105", name: "Face Pulls", category: .back, equipment: "Máquina de polea", muscles: ["Deltoides posterior", "Trapecio"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 15.0, restSeconds: 45),
//                    Serie(repetitions: 15, idealWeightKg: 15.0, restSeconds: 45)
//                ],
//                restBetweenSeriesSeconds: 45
//            )
//        ],
//        tags: ["espalda", "biceps", "fuerza"],
//        category: "Fuerza",
//        estimatedDurationMinutes: 70,
//        muscularGroupAffected: "Espalda y Brazos",
//        musclesWorked: ["Dorsales", "Trapecio", "Bíceps"],
//        estimatedCalories: 550,
//        source: .template,
//        globalActivityId: "GLOBAL-BACK-STRENGTH",
//        isPremiumRoutine: true,
//        imageURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEsuWVgaBxxnq70mlSyn8Pj7hn5Fxlv67Q6BTnQb384g6HiyF80hSK5lZn7wPvUUox2js&usqp=CAU"
//    ),
//    
//    // --- 2. Pierna: Máxima Hipertrofia ---
//    GymActivity(
//        name: "Pierna: Día de Cuádriceps (Énfasis Excéntrico)",
//        description: "Rutina brutal para el tren inferior enfocada en el tiempo bajo tensión y la hipertrofia.",
//        sets: [
//            RoutineSet(
//                exercise: Exercise(id: "ex201", name: "Sentadilla Libre (Barra)", category: .legs, equipment: "Barra y rack", muscles: ["Cuádriceps", "Glúteos"]),
//                series: [
//                    Serie(repetitions: 8, idealWeightKg: 80.0, tempo: "4-0-1-0", restSeconds: 150),
//                    Serie(repetitions: 8, idealWeightKg: 90.0, tempo: "4-0-1-0", restSeconds: 150),
//                    Serie(repetitions: 6, idealWeightKg: 100.0, tempo: "4-0-1-0", restSeconds: 180)
//                ],
//                restBetweenSeriesSeconds: 180,
//                notes: "Pausa de 2 segundos en la parte baja (paralelo).",
//                intensityTechnique: .pausedReps,
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex202", name: "Prensa Inclinada", category: .legs, equipment: "Máquina de Prensa", muscles: ["Cuádriceps", "Glúteos"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 140.0, restSeconds: 90),
//                    Serie(repetitions: 12, idealWeightKg: 180.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 200.0, restSeconds: 90)
//                ],
//                restBetweenSeriesSeconds: 90
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex203", name: "Extensión de Cuádriceps", category: .legs, equipment: "Máquina de extensión", muscles: ["Cuádriceps"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 40.0, restSeconds: 60),
//                    Serie(repetitions: 15, idealWeightKg: 45.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 50.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60,
//                notes: "Aplicar la técnica de 21 repeticiones en la última serie.",
//                intensityTechnique: .twentyOneReps
//                
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex204", name: "Sentadilla Goblet", category: .legs, equipment: "Mancuerna", muscles: ["Cuádriceps", "Glúteos"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 25.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 30.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//                RoutineSet(
//                exercise: Exercise(id: "ex205", name: "Elevación de Gemelo de Pie", category: .legs, equipment: "Máquina de gemelo", muscles: ["Gemelos"]),
//                series: [
//                    Serie(repetitions: 20, idealWeightKg: 50.0, restSeconds: 45),
//                    Serie(repetitions: 20, idealWeightKg: 60.0, restSeconds: 45),
//                    Serie(repetitions: 20, idealWeightKg: 60.0, restSeconds: 45)
//                ],
//                restBetweenSeriesSeconds: 45
//            )
//        ],
//        tags: ["pierna", "cuadriceps", "hipertrofia"],
//        category: "Legs",
//        estimatedDurationMinutes: 90,
//        muscularGroupAffected: "Piernas",
//        musclesWorked: ["Cuádriceps", "Glúteos"],
//        estimatedCalories: 700,
//        source: .template,
//        imageURL: "https://images.unsplash.com/photo-1554284126-aa88f22d8b74?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=3694"
//        
//    ),
//    
//    // --- 3. Pecho y Hombro: Congestión (Superseries) ---
//    GymActivity(
//        name: "Pecho y Hombro: Día de Congestión (Superset)",
//        description: "Rutina rápida de empuje utilizando superseries para maximizar la congestión muscular y el tiempo bajo tensión.",
//        sets: [
//            RoutineSet(
//                exercise: Exercise(id: "ex301", name: "Press de Banca Inclinado con Mancuernas", category: .chest, equipment: "Mancuernas y banco", muscles: ["Pectoral superior", "Deltoides anterior"]),
//                series: [
//                    Serie(repetitions: 10, idealWeightKg: 25.0, restSeconds: 0, rpe: 8),
//                    Serie(repetitions: 8, idealWeightKg: 30.0, restSeconds: 0, rpe: 9),
//                    Serie(repetitions: 8, idealWeightKg: 30.0, restSeconds: 0, rpe: 9)
//                ],
//                restBetweenSeriesSeconds: 150,
//                notes: "Superserie con Elevaciones Laterales (ex302).",
//                intensityTechnique: .superset
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex302", name: "Elevaciones Laterales (Sentado)", category: .shoulders, equipment: "Mancuernas", muscles: ["Deltoides medio"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 6.0, restSeconds: 150, rpe: 7),
//                    Serie(repetitions: 15, idealWeightKg: 6.0, restSeconds: 150, rpe: 8),
//                    Serie(repetitions: 12, idealWeightKg: 8.0, restSeconds: 150, rpe: 8)
//                ],
//                restBetweenSeriesSeconds: 150,
//                notes: "Parte de la superserie (con ex301)."
//            ),
//                RoutineSet(
//                exercise: Exercise(id: "ex303", name: "Press Militar con Mancuernas (Sentado)", category: .shoulders, equipment: "Mancuernas y banco", muscles: ["Deltoides", "Tríceps"]),
//                series: [
//                    Serie(repetitions: 10, idealWeightKg: 20.0, restSeconds: 90),
//                    Serie(repetitions: 8, idealWeightKg: 25.0, restSeconds: 90),
//                    Serie(repetitions: 8, idealWeightKg: 25.0, restSeconds: 90)
//                ],
//                restBetweenSeriesSeconds: 90
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex304", name: "Cruces de Cable (Crossover)", category: .chest, equipment: "Máquina de cable", muscles: ["Pectoral inferior"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60),
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 12.5, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex305", name: "Fondos en Paralelas (Tríceps)", category: .arms, equipment: "Paralelas", muscles: ["Tríceps", "Pecho inferior"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 0.0, restSeconds: 60),
//                    Serie(repetitions: 10, idealWeightKg: 0.0, restSeconds: 60),
//                    Serie(repetitions: 10, idealWeightKg: 0.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60,
//                notes: "Hacer con peso corporal, enfocándose en la bajada."
//            )
//        ],
//        tags: ["pecho", "hombro", "congestión", "superset"],
//        category: "Chest",
//        estimatedDurationMinutes: 60,
//        muscularGroupAffected: "Empuje",
//        musclesWorked: ["Pectoral mayor", "Deltoides", "Tríceps"],
//        estimatedCalories: 480,
//        source: .template,
//        
//    ),
//    
//    // --- 4. Brazos: Día de Drop Set y Giant Set ---
//    GymActivity(
//        name: "Brazos: Martillo y Cuerda (Técnicas Avanzadas)",
//        description: "Rutina intensiva para bíceps y tríceps utilizando Giant Sets y Drop Sets para maximizar el flujo sanguíneo.",
//        sets: [
//                RoutineSet(
//                exercise: Exercise(id: "ex401", name: "Curl Martillo con Cuerda", category: .arms, equipment: "Máquina de polea", muscles: ["Bíceps", "Braquial"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 20.0, restSeconds: 0),
//                    Serie(repetitions: 12, idealWeightKg: 25.0, restSeconds: 0),
//                    Serie(repetitions: 10, idealWeightKg: 30.0, restSeconds: 0)
//                ],
//                restBetweenSeriesSeconds: 120,
//                notes: "Aplicar Drop Set en las 3 series.",
//                intensityTechnique: .dropSet
//                
//            ),
//                RoutineSet(
//                exercise: Exercise(id: "ex402", name: "Extensión Francesa con Barra Z", category: .arms, equipment: "Barra Z", muscles: ["Tríceps"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 15.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 17.5, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 17.5, restSeconds: 90)
//                ],
//                restBetweenSeriesSeconds: 90
//            ),
//                RoutineSet(
//                exercise: Exercise(id: "ex403", name: "Giant Set de Brazos", category: .arms, equipment: "Mancuernas/Polea", muscles: ["Bíceps", "Tríceps"]),
//                series: [
//                    Serie(repetitions: 10, idealWeightKg: 10.0, restSeconds: 0), // Curl concentrado
//                    Serie(repetitions: 10, idealWeightKg: 10.0, restSeconds: 0), // Press francés con mancuerna
//                    Serie(repetitions: 10, idealWeightKg: 10.0, restSeconds: 0), // Curl martillo
//                    Serie(repetitions: 10, idealWeightKg: 10.0, restSeconds: 150) // Extensión de tríceps
//                ],
//                restBetweenSeriesSeconds: 150,
//                notes: "Realizar 3 rondas del Giant Set.",
//                intensityTechnique: .giant,
//            ),
//                RoutineSet(
//                exercise: Exercise(id: "ex404", name: "Curl Inverso con Barra", category: .arms, equipment: "Barra", muscles: ["Antebrazos", "Bíceps"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60),
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex405", name: "Plancha (Core)", category: .core, equipment: "Ninguno", muscles: ["Abdominales", "Core"]),
//                series: [
//                    Serie(repetitions: 0, restSeconds: 60, notes: "Mantener 60s"),
//                    Serie(repetitions: 0, restSeconds: 60, notes: "Mantener 60s")
//                ],
//                restBetweenSeriesSeconds: 60
//            )
//        ],
//        tags: ["brazos", "biceps", "triceps", "avanzado"],
//        category: "Arms",
//        estimatedDurationMinutes: 55,
//        muscularGroupAffected: "Brazos",
//        musclesWorked: ["Bíceps", "Tríceps", "Antebrazos"],
//        estimatedCalories: 400,
//        source: .template,
//        globalActivityId: "GLOBAL-ARM-PUMP",
//        
//    ),
//    
//    // --- 5. Cuerpo Completo: Principiante ---
//    GymActivity(
//        name: "Full Body: Introducción al Gimnasio",
//        description: "Rutina ideal para principiantes que buscan una base de fuerza general y técnica.",
//        sets: [
//            RoutineSet(
//                exercise: Exercise(id: "ex501", name: "Press de Pecho en Máquina", category: .chest, equipment: "Máquina de Placas", muscles: ["Pectoral"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 30.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 35.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 35.0, restSeconds: 90)
//                ],
//                restBetweenSeriesSeconds: 90
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex502", name: "Jalón al Pecho en Máquina (Agarre Ancho)", category: .back, equipment: "Máquina de polea", muscles: ["Dorsales"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 40.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 45.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 45.0, restSeconds: 90)
//                ],
//                restBetweenSeriesSeconds: 90
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex503", name: "Sentadilla con Peso Corporal", category: .legs, equipment: "Ninguno", muscles: ["Cuádriceps", "Glúteos"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 0.0, restSeconds: 60),
//                    Serie(repetitions: 15, idealWeightKg: 0.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex504", name: "Press de Hombro con Mancuernas", category: .shoulders, equipment: "Mancuernas", muscles: ["Deltoides"]),
//                series: [
//                    Serie(repetitions: 10, idealWeightKg: 10.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 10.0, restSeconds: 90)
//                ],
//                restBetweenSeriesSeconds: 90
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex505", name: "Curl de Bíceps en Máquina", category: .arms, equipment: "Máquina de polea", muscles: ["Bíceps"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 20.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 20.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            )
//        ],
//        tags: ["fullbody", "principiante", "fuerza"],
//        category: "strength",
//        estimatedDurationMinutes: 60,
//        muscularGroupAffected: "Cuerpo Completo",
//        musclesWorked: ["Múltiples"],
//        estimatedCalories: 350,
//        source: .template,
//        isPremiumRoutine: false,
//        
//    ),
//    
//    // --- 6. Hombro Completo: Pirámide ---
//    GymActivity(
//        name: "Hombro 3D: Técnica Pirámide",
//        description: "Día de hombro enfocado en las tres cabezas del deltoides utilizando la técnica de Pirámide.",
//        sets: [
//            RoutineSet(
//                exercise: Exercise(id: "ex601", name: "Press Militar de Pie (Barra)", category: .shoulders, equipment: "Barra y rack", muscles: ["Deltoides", "Tríceps"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 30.0, restSeconds: 120),
//                    Serie(repetitions: 8, idealWeightKg: 40.0, restSeconds: 120),
//                    Serie(repetitions: 5, idealWeightKg: 50.0, restSeconds: 150),
//                    Serie(repetitions: 10, idealWeightKg: 35.0, restSeconds: 120)
//                ],
//                restBetweenSeriesSeconds: 120,
//                notes: "Usar pirámide ascendente y descendente.",
//                intensityTechnique: .pyramid,
//            ),
//                RoutineSet(
//                exercise: Exercise(id: "ex602", name: "Pájaros (Reverse Fly) en Máquina", category: .shoulders, equipment: "Máquina", muscles: ["Deltoides posterior"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 25.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 30.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 30.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//                RoutineSet(
//                exercise: Exercise(id: "ex603", name: "Elevaciones Frontales con Disco", category: .shoulders, equipment: "Disco/Plato", muscles: ["Deltoides anterior"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60),
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex604", name: "Encogimiento de Hombros con Mancuernas", category: .back, equipment: "Mancuernas", muscles: ["Trapecio"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 30.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 35.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 35.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex605", name: "Plancha Lateral", category: .core, equipment: "Ninguno", muscles: ["Oblicuos", "Core"]),
//                series: [
//                    Serie(repetitions: 0, restSeconds: 45, notes: "Mantener 45s por lado"),
//                    Serie(repetitions: 0, restSeconds: 45, notes: "Mantener 45s por lado")
//                ],
//                restBetweenSeriesSeconds: 45
//            )
//        ],
//        tags: ["hombro", "deltoides", "pirámide"],
//        category: "Shoulders",
//        estimatedDurationMinutes: 50,
//        muscularGroupAffected: "Hombros",
//        musclesWorked: ["Deltoides", "Trapecio"],
//        estimatedCalories: 390,
//        source: .template,
//        
//    ),
//    
//    // --- 7. Cardio y Core: HIIT ---
//    GymActivity(
//        name: "HIIT: 30 Minutos Quema-Grasa",
//        description: "Sesión de alta intensidad para maximizar la quema de calorías en poco tiempo.",
//        sets: [
//            RoutineSet(
//                exercise: Exercise(id: "ex701", name: "Burpees", category: .hiit, equipment: "Ninguno", muscles: ["Cuerpo Completo"]),
//                series: [
//                    Serie(repetitions: 10, restSeconds: 30),
//                    Serie(repetitions: 10, restSeconds: 30),
//                    Serie(repetitions: 10, restSeconds: 30),
//                    Serie(repetitions: 10, restSeconds: 30)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex702", name: "Sentadilla con Salto (Plyo)", category: .plyometric, equipment: "Ninguno", muscles: ["Cuádriceps", "Glúteos"]),
//                series: [
//                    Serie(repetitions: 15, restSeconds: 30),
//                    Serie(repetitions: 15, restSeconds: 30),
//                    Serie(repetitions: 15, restSeconds: 30),
//                    Serie(repetitions: 15, restSeconds: 30)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex703", name: "Mountain Climbers", category: .core, equipment: "Ninguno", muscles: ["Core", "Cardio"]),
//                series: [
//                    Serie(repetitions: 0, restSeconds: 30, notes: "30 segundos de ejecución"),
//                    Serie(repetitions: 0, restSeconds: 30, notes: "30 segundos de ejecución"),
//                    Serie(repetitions: 0, restSeconds: 30, notes: "30 segundos de ejecución"),
//                    Serie(repetitions: 0, restSeconds: 30, notes: "30 segundos de ejecución")
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex704", name: "Zancadas Caminando", category: .legs, equipment: "Ninguno", muscles: ["Cuádriceps", "Glúteos"]),
//                series: [
//                    Serie(repetitions: 20, restSeconds: 30, notes: "10 por pierna"),
//                    Serie(repetitions: 20, restSeconds: 30, notes: "10 por pierna"),
//                    Serie(repetitions: 20, restSeconds: 30, notes: "10 por pierna")
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex705", name: "Skipping (Rodillas altas)", category: .hiit, equipment: "Ninguno", muscles: ["Cardio", "Piernas"]),
//                series: [
//                    Serie(repetitions: 0, restSeconds: 60, notes: "60 segundos de ejecución"),
//                    Serie(repetitions: 0, restSeconds: 60, notes: "60 segundos de ejecución")
//                ],
//                restBetweenSeriesSeconds: 60
//            )
//        ],
//        tags: ["cardio", "hiit", "core", "quema-grasa"],
//        category: "exercise",
//        estimatedDurationMinutes: 30,
//        muscularGroupAffected: "Cuerpo Completo",
//        musclesWorked: ["Múltiples", "Cardio"],
//        estimatedCalories: 300,
//        source: .template,
//        
//    ),
//    
//    // --- 8. Core: Máxima Resistencia ---
//    GymActivity(
//        name: "Core: Máxima Resistencia y Estabilidad",
//        description: "Enfoque en la estabilidad del core, ideal para finalizar una rutina o un día de descanso activo.",
//        sets: [
//            RoutineSet(
//                exercise: Exercise(id: "ex801", name: "Plancha Estándar", category: .core, equipment: "Colchoneta", muscles: ["Recto Abdominal", "Core"], ),
//                series: [
//                    Serie(repetitions: 0, restSeconds: 60, notes: "Mantener 60s"),
//                    Serie(repetitions: 0, restSeconds: 60, notes: "Mantener 60s"),
//                    Serie(repetitions: 0, restSeconds: 60, notes: "Mantener 60s")
//                ],
//                restBetweenSeriesSeconds: 45,
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex802", name: "Crunch en Máquina", category: .core, equipment: "Máquina de Crunch", muscles: ["Recto Abdominal"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 40.0, restSeconds: 60),
//                    Serie(repetitions: 15, idealWeightKg: 45.0, restSeconds: 60),
//                    Serie(repetitions: 15, idealWeightKg: 45.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex803", name: "Elevación de Piernas Colgado", category: .core, equipment: "Barra de dominadas", muscles: ["Abdominales bajos", "Flexores de cadera"]),
//                series: [
//                    Serie(repetitions: 10, idealWeightKg: 0.0, restSeconds: 60),
//                    Serie(repetitions: 10, idealWeightKg: 0.0, restSeconds: 60),
//                    Serie(repetitions: 10, idealWeightKg: 0.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex804", name: "Rotación Rusa con Disco", category: .core, equipment: "Disco/Plato", muscles: ["Oblicuos"]),
//                series: [
//                    Serie(repetitions: 20, idealWeightKg: 10.0, restSeconds: 45, notes: "20 por lado"),
//                    Serie(repetitions: 20, idealWeightKg: 10.0, restSeconds: 45, notes: "20 por lado")
//                ],
//                restBetweenSeriesSeconds: 45
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex805", name: "Superman (Hiperextensiones lumbares)", category: .core, equipment: "Colchoneta", muscles: ["Lumbares"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 0.0, restSeconds: 30),
//                    Serie(repetitions: 15, idealWeightKg: 0.0, restSeconds: 30)
//                ],
//                restBetweenSeriesSeconds: 30
//            )
//        ],
//        tags: ["core", "abs", "resistencia"],
//        category: "Core",
//        estimatedDurationMinutes: 20,
//        muscularGroupAffected: "Core",
//        musclesWorked: ["Recto Abdominal", "Oblicuos", "Lumbares"],
//        estimatedCalories: 150,
//        source: .template,
//    ),
//
//    // --- 9. Empuje Avanzado: Cluster Set ---
//    GymActivity(
//        name: "Empuje (Pecho/Hombro/Tríceps): Cluster Set",
//        description: "Rutina avanzada de empuje enfocada en el desarrollo de fuerza y potencia utilizando Cluster Sets.",
//        sets: [
//            RoutineSet(
//                exercise: Exercise(id: "ex901", name: "Press de Banca (Barra)", category: .chest, equipment: "Barra y rack", muscles: ["Pectoral", "Tríceps"]),
//                series: [
//                    Serie(repetitions: 5, idealWeightKg: 100.0, restSeconds: 150, rpe: 9)
//                ],
//                restBetweenSeriesSeconds: 180,
//                notes: "Realizar 4 mini-series de 2-3 repeticiones con 15s de descanso dentro de cada 'serie principal'.",
//                intensityTechnique: .cluster,
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex902", name: "Press de Hombro con Barra (Máquina Smith)", category: .shoulders, equipment: "Máquina Smith", muscles: ["Deltoides", "Tríceps"]),
//                series: [
//                    Serie(repetitions: 8, idealWeightKg: 60.0, restSeconds: 120),
//                    Serie(repetitions: 6, idealWeightKg: 70.0, restSeconds: 120),
//                    Serie(repetitions: 6, idealWeightKg: 70.0, restSeconds: 120)
//                ],
//                restBetweenSeriesSeconds: 120
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex903", name: "Aperturas con Cable (Bajo-Alto)", category: .chest, equipment: "Máquina de cable", muscles: ["Pectoral superior"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60),
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 12.5, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex904", name: "Patada de Tríceps con Mancuerna", category: .arms, equipment: "Mancuerna", muscles: ["Tríceps"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 8.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 8.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 8.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex905", name: "Elevaciones Laterales (Polea Baja)", category: .shoulders, equipment: "Máquina de polea", muscles: ["Deltoides medio"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 5.0, restSeconds: 45),
//                    Serie(repetitions: 15, idealWeightKg: 5.0, restSeconds: 45),
//                    Serie(repetitions: 15, idealWeightKg: 5.0, restSeconds: 45)
//                ],
//                restBetweenSeriesSeconds: 45
//            )
//        ],
//        tags: ["pecho", "fuerza", "cluster", "avanzado"],
//        category: "Chest",
//        estimatedDurationMinutes: 75,
//        muscularGroupAffected: "Pecho/Hombro/Tríceps",
//        musclesWorked: ["Pectoral", "Deltoides", "Tríceps"],
//        estimatedCalories: 580,
//        source: .template,
//        globalActivityId: "GLOBAL-PUSH-CLUSTER",
//        isPremiumRoutine: true,
//        
//    ),
//
//    // --- 10. Pierna: Isquiotibiales y Glúteos ---
//    GymActivity(
//        name: "Pierna Posterior: Isquios y Glúteos",
//        description: "Día de pierna centrado en la cadena posterior con enfoque en el desarrollo de glúteos e isquiotibiales.",
//        sets: [
//            RoutineSet(
//                exercise: Exercise(id: "ex1001", name: "Peso Muerto Rumano con Mancuernas", category: .legs, equipment: "Mancuernas", muscles: ["Isquiotibiales", "Glúteos"]),
//                series: [
//                    Serie(repetitions: 10, idealWeightKg: 20.0, tempo: "3-1-1-0", restSeconds: 120),
//                    Serie(repetitions: 10, idealWeightKg: 25.0, tempo: "3-1-1-0", restSeconds: 120),
//                    Serie(repetitions: 8, idealWeightKg: 30.0, tempo: "3-1-1-0", restSeconds: 120 )
//                ],
//                restBetweenSeriesSeconds: 120
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex1002", name: "Hip Thrust con Barra", category: .legs, equipment: "Barra y banco", muscles: ["Glúteos"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 70.0, restSeconds: 90),
//                    Serie(repetitions: 12, idealWeightKg: 90.0, restSeconds: 90),
//                    Serie(repetitions: 10, idealWeightKg: 100.0, restSeconds: 90)
//                ],
//                restBetweenSeriesSeconds: 90,
//                notes: "Pausa de 2 segundos en la cima de cada repetición.",
//                intensityTechnique: .pausedReps,
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex1003", name: "Curl de Pierna Acostado", category: .legs, equipment: "Máquina de curl", muscles: ["Isquiotibiales"]),
//                series: [
//                    Serie(repetitions: 12, idealWeightKg: 30.0, restSeconds: 60),
//                    Serie(repetitions: 12, idealWeightKg: 35.0, restSeconds: 60),
//                    Serie(repetitions: 10, idealWeightKg: 40.0, restSeconds: 60)
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex1004", name: "Patada de Glúteo en Polea Baja", category: .legs, equipment: "Máquina de polea", muscles: ["Glúteos"]),
//                series: [
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60, notes: "15 por pierna"),
//                    Serie(repetitions: 15, idealWeightKg: 10.0, restSeconds: 60, notes: "15 por pierna")
//                ],
//                restBetweenSeriesSeconds: 60
//            ),
//            RoutineSet(
//                exercise: Exercise(id: "ex1005", name: "Abducción de Cadera en Máquina", category: .legs, equipment: "Máquina de abducción", muscles: ["Glúteos medios"]),
//                series: [
//                    Serie(repetitions: 20, idealWeightKg: 40.0, restSeconds: 45),
//                    Serie(repetitions: 20, idealWeightKg: 45.0, restSeconds: 45),
//                    Serie(repetitions: 20, idealWeightKg: 45.0, restSeconds: 45)
//                ],
//                restBetweenSeriesSeconds: 45
//            )
//        ],
//        tags: ["pierna", "gluteos", "isquiotibiales"],
//        category: "Legs",
//        estimatedDurationMinutes: 65,
//        muscularGroupAffected: "Piernas Posteriores",
//        musclesWorked: ["Isquiotibiales", "Glúteos"],
//        estimatedCalories: 420,
//        source: .template,
//        
//    )
//]
//    
//    // MARK: - Helper Methods
//    
//    /// Retorna todas las actividades como ActivityType
//    static var allActivitiesAsTypes: [ActivityType] {
//        let running = runningActivities.map { ActivityType.running($0) }
//        let rest = restActivities.map { ActivityType.rest($0) }
//        return running + rest
//    }
//    
//    /// Retorna actividades filtradas por categoría
//    static func activities(for category: ActivityCategory) -> [ActivityType] {
//        switch category {
//        case .gym:
//            return gymActivities.map { .gym($0) }
//        case .running:
//            return runningActivities.map { .running($0) }
//        case .rest:
//            return restActivities.map { .rest($0) }
//        default:
//            return []
//        }
//    }
//    
//    /// Retorna una actividad aleatoria del tipo especificado
//    static func randomActivity(for category: ActivityCategory) -> ActivityType? {
//        activities(for: category).randomElement()
//    }
//}
