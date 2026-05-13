//
//  RoutineTemplate.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import Foundation

struct RoutineTemplate: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let description: String
    let imageName: String
    let estimatedDuration: Int
    let difficulty: Difficulty
    let imageURL : String?
}
