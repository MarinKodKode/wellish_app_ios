//
//  RoutineViewModel+Load.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 08/10/25.
//

import Foundation

extension GymActivityViewModel {
    
    public func loadRoutines() async {
        isLoading = true
        errorMessage = nil
        
        print("Loading routines")
        
        do {
            let firebaseRoutines = try await firestoreService.fetchRoutines()
            self.savedRoutines = firebaseRoutines
            isOnline = true
            lastSyncDate = Date()
            
            print("Loaded \(firebaseRoutines.count) routines, ready to use.")
            
            Task {
                do {
                    try await localStorageService.saveRoutines(firebaseRoutines)
                    print("LocalStorage sync")
                }catch {
                    print("Error syncing local storage \(error)")
                }
            }
        }catch {
            print("Error fetching from firebase, getting routines from local storage")
            isOnline = false
            
            do {
                let localRoutines = try await localStorageService.fetchRoutines()
                self.savedRoutines = localRoutines
                print("Loaded \(localRoutines.count) routines from LS")
                
                if !localRoutines.isEmpty {
                    errorMessage = "Showing routines stored locally (without connection)"
                }
            }catch {
                self.savedRoutines = []
                errorMessage = "Could not load routines \(error.localizedDescription)"
            }
        }
        
        isLoading = false
    }
    
    
    public func loadRoutine(id : String) async -> Bool {
        isLoading = true
        errorMessage = nil
        
        //Tries firebase first
        do {
            let loadedRoutine = try await firestoreService.fetchRoutine(id: id)
            self.gymActivity = loadedRoutine
            isOnline = true
            
//            try await localStorageService.saveRoutine(loadedRoutine)
            
            isLoading = false
            return true
        }catch {
            print("Error fetching from Firebase, trying locally...")
            isOnline = false
        }
        
        //Fallback to LocalStorage
        
        do {
            let loadedRoutine = try await localStorageService
                .fetchRoutine(id: id)
            self.gymActivity = loadedRoutine
            isLoading = false
            return true
        }catch {
            print("Error - \(error.localizedDescription)")
            return false
        }
    }
}
