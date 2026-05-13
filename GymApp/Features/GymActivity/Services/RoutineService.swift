//
//  RoutineService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import Foundation

final class RoutineService : RoutineServiceProtocol {
    
    
    public var errorMessage : String?
    
    public var isOnline : Bool = true
    public var lastSyncDate : Date?
    
    let firestoreService = RoutineFirestoreService()
    let localStorageService = RoutineLocalStorageService()
    let activityLocalStorageService = ActivityLocalStorageService()
    
    
    
    // MARK: - Public Methods (GET and SET)
    
    /// Fetches all available routines, including those stored locally or remotely.
    ///
    /// This asynchronous method attempts to retrieve all routines using the internal `fetchRoutines()`
    /// function. In case of failure, it returns an empty array.
    ///
    /// - Returns: An array of `Routine` objects. Returns an empty array if the fetch operation fails.
    public func getRoutines() async -> [GymActivity] {
        do {
            let routines = try await self.activityLocalStorageService.fetchActivities(
                byCategory: .gym
            )
            let gymActivities: [GymActivity] = routines.compactMap { activityType in
                if case .gym(let gymActivity) = activityType {
                    return gymActivity
                }
                return nil
            }
            return gymActivities
            
        } catch {
            return []
        }
    }
    
    /// Fetches a specific routine given its unique identifier.
    ///
    /// This asynchronous method attempts to retrieve a routine by its ID using the internal
    /// `fetchRoutine(by:)` function. If the routine does not exist or an error occurs, it returns `nil`.
    ///
    /// - Parameter id: The unique identifier of the routine to fetch.
    /// - Returns: A `Routine` object if found; otherwise, `nil`.
    public func getRoutine(by id: String) async -> GymActivity? {
        do {
            let routine = try await fetchRoutine(by: id)
            return routine
        } catch {
            return nil
        }
    }
    
    public func saveRoutineLocally(_ routine : GymActivity) async  -> Bool {
        return await saveRoutineInLocalStorage(routine)
    }
    
    public func saveRoutineFirebase(_ routine : GymActivity) async  -> Bool {
        return await saveRoutineInFirebaseStorage(routine)
    }

    //MARK: - Private methods
    
    internal func fetchRoutines() async throws -> [GymActivity] {
        errorMessage = nil
        
        do {
            let firebaseRoutines = try await firestoreService.fetchRoutines()
            
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
            return firebaseRoutines
        }catch {
            
            do {
                let localRoutines = try await localStorageService.fetchRoutines()
                print("Loaded \(localRoutines.count) routines from LS")
                
                if !localRoutines.isEmpty {
                    errorMessage = "Showing routines stored locally (without connection)"
                }
                return localRoutines
            }catch {
                errorMessage = "Could not load routines \(error.localizedDescription)"
                return []
            }
        }
    }

    internal func fetchRoutine(by id: String) async throws -> GymActivity? {
        errorMessage = nil
        do {
            let loadedRoutine = try await firestoreService.fetchRoutine(id: id)
            isOnline = true
            
//            try await localStorageService.saveRoutine(loadedRoutine)
            
            return loadedRoutine
        }catch {
            print("Error fetching from Firebase, trying locally...")
            isOnline = false
        }
        
        do {
            let loadedRoutine = try await localStorageService
                .fetchRoutine(id: id)
            return loadedRoutine
        }catch {
            print("Error - \(error.localizedDescription)")
            return nil
        }
    }

    internal func saveRoutineInLocalStorage(_ routine : GymActivity) async -> Bool {
        do {
//            try await localStorageService.saveRoutine(routine)
            return true
        }catch {
            print("Could not save routine to local storage")
            return false
        }
    }
    
    internal func saveRoutineInFirebaseStorage(_ routine : GymActivity) async -> Bool {
        do {
            _ = try await firestoreService.uploadRoutinesWithID(routine)
            return true
        }catch {
            print("Could not save routine to firebase storage")
            return false
        }
    }
}
