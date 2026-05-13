//
//  RoutineServiceProtocol.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import Foundation

protocol RoutineServiceProtocol {
    
    func fetchRoutines() async throws -> [GymActivity]
    
    func fetchRoutine(by id: String) async throws -> GymActivity?
    
    func saveRoutineLocally(_ routine : GymActivity) async -> Bool
    
    func saveRoutineFirebase(_ routine : GymActivity) async -> Bool
    
    
    
}
