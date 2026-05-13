//
//  RoutineViewModel+Tags&Categories.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 14/10/25.
//

import Foundation

extension GymActivityViewModel {
        
    public func addTag(_ tag : String){
        let t = tag.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty, !gymActivity.tags.contains(t) else { return }
        gymActivity.tags.append(t)
        gymActivity.updatedAt = Date()
    }
    
    public func removeTag(_ tag : String ){
        gymActivity.tags.removeAll{ $0 == tag }
        gymActivity.updatedAt = Date()
    }
    
}
