//
//  MetricsDataSet.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/11/25.
//

import Foundation

struct MetricsDataSet {
    
    static let performanceDay = GymActivityPerformance(
        id: "1",
        startedAt: Date(),
        completedAt: Date().addingTimeInterval(3600),
        actualDurationMinutes: 60,
        actualCalories: 350,
        rpe: 8,
        performedSets: [
            PerformedRoutineSet(
                name: "Press Banca",
                completedSeries: [
                    PerformedSeries(exerciseName: "Press Banca", weightKg: 80, reps: 10),
                    PerformedSeries(exerciseName: "Press Banca", weightKg: 80, reps: 8),
                    PerformedSeries(exerciseName: "Press Banca", weightKg: 75, reps: 10)
                ]
            )
        ]
    )
}
