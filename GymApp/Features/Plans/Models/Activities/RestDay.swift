//
//  RestDay.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/10/25.
//

import Foundation

extension PlanActivity{
    public struct RestDay: Codable, Hashable {
        public let id: String
        public var type: RestType
        public var description: String?
        public var suggestedActivities: [String]?
        
        public init(
            id: String = UUID().uuidString,
            type: RestType,
            description: String? = nil,
            suggestedActivities: [String]? = nil
        ) {
            self.id = id
            self.type = type
            self.description = description
            self.suggestedActivities = suggestedActivities
        }
    }

    public enum RestType: String, Codable {
        case complete = "Descanso completo"
        case active = "Descanso activo"
        case mobility = "Movilidad"
        case stretching = "Estiramientos"
    }
}

