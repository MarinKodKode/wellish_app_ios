//
//  RoutineVIewModel+Update.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation

extension GymActivityViewModel {
    
    public func updateInFirebase() async -> Bool {
        guard canSave else {
            errorMessage = "Please provide a name and an exercise"
            return false
        }
        
        let validation = validateGymActivity()
        
        if !validation.isValid {
            errorMessage = validation.errors.joined(separator: "\n")
            return false
        }
        
        isSaving = true
        errorMessage = nil
        
        prepareGymActivityForSave()
        
        do {
            try await firestoreService.updateRoutine(gymActivity)
            isSaving = false
            print("Routine updated successfully.")
            return true
        }catch{
            errorMessage = "Error updating routine: \(error.localizedDescription)"
            isSaving = false
            return false
        }
    }
    
}
