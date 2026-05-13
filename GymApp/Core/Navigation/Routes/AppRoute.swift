//
//  AppRoute.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/07/25.
//

import Foundation

enum AppRoute:  Hashable {
    case signup
    case signin
    case metrics
    case maintab
    case workoutDetail
    case profileSettings
    case nutritionPlan
    case createRoutine
    case createPlan
    case workoutTimer
    case todayWorkout(plan : Plan)
    case adminConsole
    case gymActivityDetail(_ activity : GymActivity)
    case runningActivityDetail
    case exerciseDetail(_ exercise : Exercise)
    case planDetail(_ plan : Plan)
    case summaryDay
}
