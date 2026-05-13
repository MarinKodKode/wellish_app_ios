//
//  SampleData.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI
import Foundation

//MARK: - ONBOARDINGVIEW

let slides : [OnboardingSlide] = [
    OnboardingSlide(
        title: "No Excuses",
        subtitle: "Just Do The Workout",
        quote: "Fitness is not about being better than someone else. It's about being better than you used to be.",
        imageURL: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=800&fit=crop&crop=faces",
        accentColor: Color(red: 0.8, green: 0.95, blue: 0.3)
    ),
    OnboardingSlide(
        title: "Push Your Limits",
        subtitle: "Transform Your Body",
        quote: "The only bad workout is the one that didn't happen.",
        imageURL: "https://images.unsplash.com/photo-1549476464-37392f717541?w=400&h=800&fit=crop&crop=faces",
        accentColor: Color(red: 0.8, green: 0.95, blue: 0.3)
    ),
    OnboardingSlide(
        title: "Start Today",
        subtitle: "Build Your Future",
        quote: "Your body can do it. It's time to convince your mind.",
        imageURL: "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=400&h=800&fit=crop&crop=faces",
        accentColor: Color(red: 0.8, green: 0.95, blue: 0.3)
    )
]


// MARK: - MAIN HOME VIEW ROUTINES

let bodyParts = ["Full Body", "Legs", "Hands", "Upper"]

let workouts = [
    WorkoutItem(name: "Bridge", imageURL: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300&h=200&fit=crop", tutorials: 8, duration: 30),
    WorkoutItem(name: "Push up", imageURL: "https://images.unsplash.com/photo-1549476464-37392f717541?w=300&h=200&fit=crop", tutorials: 12, duration: 60),
    WorkoutItem(name: "Hip Thrust", imageURL: "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=300&h=200&fit=crop", tutorials: 10, duration: 45)
]


//MARK: - Workout Live Tracker Data

let workoutSession = WorkoutSession(
    name: "Dumbbell Curl",
    currentTime: 25.10,
    totalTime: 45.0,
    calories: 251,
    duration: 25,
    reps: "12 × 4 Reps"
)

let activityHistory = [
    ActivityHistoryItem(
        name: "Dumbbell Curl",
        date: "Tue, June 11",
        time: "09:50 PM",
        calories: 452,
        duration: "1 h 13 min",
        sets: 10
    ),
    ActivityHistoryItem(
        name: "Dumbbell Curl",
        date: "Mon, June 10",
        time: "07:30 PM",
        calories: 678,
        duration: "1 h 42 min",
        sets: 14
    )
]

// MARK: - Routines and plans view

// Pre-made templates
let templates: [RoutineTemplate] = [
    RoutineTemplate(
        name: "Full Body Gym",
        category: "Strength",
        description: "3-day split for full-body strength",
        imageName: "dumbbell.fill",
        estimatedDuration: 60,
        difficulty: .intermediate,
        imageURL: "https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    RoutineTemplate(
        name: "Running for Beginners",
        category: "Cardio",
        description: "Couch to 5K starter plan",
        imageName: "figure.run",
        estimatedDuration: 30,
        difficulty: .beginner,
        imageURL: "https://images.unsplash.com/photo-1513593771513-7b58b6c4af38?q=80&w=3732&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    RoutineTemplate(
        name: "Isometric Flow",
        category: "Mobility",
        description: "Static holds for strength & control",
        imageName: "figure.yoga",
        estimatedDuration: 20,
        difficulty: .beginner,
        imageURL: "https://images.unsplash.com/photo-1545205597-3d9d02c29597?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    RoutineTemplate(
        name: "Cycling HIIT",
        category: "Cardio",
        description: "High-intensity interval training",
        imageName: "bicycle",
        estimatedDuration: 45,
        difficulty: .advanced,
        imageURL: "https://plus.unsplash.com/premium_photo-1753282083852-af82471d5da7?q=80&w=2942&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    ),
    RoutineTemplate(
        name: "Upper Body Blast",
        category: "Strength",
        description: "Chest, back & arms focus",
        imageName: "figure.mixed-cardio",
        estimatedDuration: 50,
        difficulty: .intermediate,
        imageURL: "https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?q=80&w=2940&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"
    )
]
