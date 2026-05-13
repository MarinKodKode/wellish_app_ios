//
//  RoutineViewModel+Delete.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation

extension GymActivityViewModel {
    
    public func deleteFromFirebase() async -> Bool {
        isSaving = true
        errorMessage = nil
        
        do {
            try await firestoreService.deleteRoutine(id: gymActivity.id)
            isSaving = false
            return true
        }catch {
            errorMessage = "Error deleting routine - \(error.localizedDescription)"
            print("Erro : \(String(describing: errorMessage))")
            return false
        }
    }
}
