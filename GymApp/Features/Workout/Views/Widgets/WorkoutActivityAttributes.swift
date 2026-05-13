//
//  WorkoutActivityAttributes.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//


import Foundation
import ActivityKit

struct WorkoutActivityAttributes : ActivityAttributes {
    public struct ContentState : Codable ,  Hashable {
        var restTimeRemaining : Int
        var currentExercise : String
        var currentSet : Int
        var totalSets : Int
        var nextExercise : String
    }
    
    var workoutName : String
}


