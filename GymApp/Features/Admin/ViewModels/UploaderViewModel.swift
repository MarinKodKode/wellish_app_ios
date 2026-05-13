//
//  UploaderViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 27/10/25.
//

import Foundation

final class UploaderViewModel : ObservableObject {
    
    
    let exerciseService = ExerciseFirebaseService()
    let exercise_ds : [Exercise] = []
    
    func uploadExercise(_ exercise : Exercise ) async {
        do {
            try await exerciseService.updateExercise(exercise)
            print("Succeded saving exercise")
        }catch{
            print("Failed saving exercise")
        }
    }
    
    
    func uploadGymExercises() async {
        
//        let plyometricExercises = ExerciseDataset.plyometricExercises
//        do {
//            for exercise in plyometricExercises {
//                try await exerciseService.updateExercise(exercise)
//            }
//            print("Succeded saving exercise")
//        }catch{
//            print("Failed saving exercise")
//        }
        
        
        
    }
}

