//
//  WorkoutViewModel+LiveActivity.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation
import ActivityKit

extension GymLiveTrackerViewModel {

//    public func startLiveActivity() {
//        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
//            print("Lives Activities are not enabled")
//            return
//        }
//        
//        let nextExerciseName = currentExerciseIndex < exercises.count - 1
//        ? exercises[currentExerciseIndex + 1].name
//        : "Routine Ended"
//        
//        let attributes = WorkoutActivityAttributes(workoutName: "Upper Body workout")
//        let contentState = WorkoutActivityAttributes.ContentState(
//            restTimeRemaining: restTimer,
//            currentExercise: currentExercise.name,
//            currentSet: currentSet,
//            totalSets: currentExercise.sets,
//            nextExercise: nextExerciseName
//        )
//        
//        do {
//            currentActivity = try Activity<WorkoutActivityAttributes>.request(
//                attributes: attributes,
//                contentState: contentState,
//                pushType: nil
//            )
//            print("Live Activity iniciada")
//        } catch {
//            print("Error al iniciar Live Activity: \(error)")
//        }
//    }
//    
//    public func endLiveActivity() {
//        guard let activity = currentActivity else { return }
//        
//        Task {
//            await activity.end(dismissalPolicy: .immediate)
//            currentActivity = nil
//        }
//    }
//    
//    public func updateLiveActivity() {
//        guard let activity = currentActivity else { return }
//        
//        let nextExerciseName = currentExerciseIndex < exercises.count - 1
//        ? exercises[currentExerciseIndex + 1].name
//        : "Fin de rutina"
//        
//        let updatedState = WorkoutActivityAttributes.ContentState(
//            restTimeRemaining: restTimer,
//            currentExercise: currentExercise.name,
//            currentSet: currentSet,
//            totalSets: currentExercise.sets,
//            nextExercise: nextExerciseName
//        )
//        
//        Task {
//            await activity.update(using: updatedState)
//        }
//    }
}
