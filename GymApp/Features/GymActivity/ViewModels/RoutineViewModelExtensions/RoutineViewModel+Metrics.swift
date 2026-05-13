//
//  gymActivityViewModel+Metrics.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation

extension GymActivityViewModel {
    
    public var estimatedVolumeKg : Double {
        gymActivity.estimatedVolumeKg
    }
    
    public var totalReps : Int {
        gymActivity.totalReps
    }
    
    public func calculateEstimatedDuration() -> Int {
        let totalSeries = gymActivity.sets.reduce(0) { $0 + $1.series.count}
        let avgTimePerSerie = 45
        
        let totalRestTime = gymActivity.sets.reduce(0) { total, set in
            let restTime = set.restBetweenSeriesSeconds ?? 90
            let seriesCount = max(0, set.series.count - 1)
            return total + (restTime * seriesCount)
        }
        
        let totalSeconds = (totalSeries * avgTimePerSerie) + totalRestTime
        return max(1, (totalSeconds + 59) / 60)
    }
    
    // Determine main muscular group
    
    public  func determinePrimaryMuscularGroup() -> String {
//        let muscles = gymActivity.sets.flatMap{ $0..primaryMuscles}
//        guard !muscles.isEmpty else { return "General" }
//        
//        var muscleCount : [String : Int] = [:]
//        muscles.forEach { muscle in
//            muscleCount[muscle.displayName, default: 0] += 1
//        }
//        
        return "General"
    }
}
