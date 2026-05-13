//
//  RoutineRepositoryProtocol.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import Foundation

public protocol RoutineRepositoryProtocol {
    
    func saveRoutine(_ routine: GymActivity) async throws -> GymActivity
    
    func fetchRoutines() async throws -> [GymActivity]
    
    func fetchRoutine(id: String) async throws -> GymActivity?
    
}

