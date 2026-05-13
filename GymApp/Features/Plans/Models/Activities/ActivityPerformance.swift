//
//  ActivityPerformance.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 22/10/25.
//

import Foundation

public enum PerformanceStatus: String, Codable {
    case underPerformed = "Bajo expectativa"
    case onTarget = "En objetivo"
    case overPerformed = "Sobre expectativa"
    
    public var icon: String {
        switch self {
        case .underPerformed: return "arrow.down.circle.fill"
        case .onTarget: return "checkmark.circle.fill"
        case .overPerformed: return "arrow.up.circle.fill"
        }
    }
    
    public var color: String {
        switch self {
        case .underPerformed: return "orange"
        case .onTarget: return "green"
        case .overPerformed: return "blue"
        }
    }
}

