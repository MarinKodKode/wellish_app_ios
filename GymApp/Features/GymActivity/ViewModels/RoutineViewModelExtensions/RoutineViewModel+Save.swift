//
//  RoutineViewModel+Save.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 08/10/25.
//

import Foundation

extension GymActivityViewModel {
    
    public func saveRoutine() async -> Bool {
        
        //Turn on loading spinner
        
        guard canSave else {
            //Throw alert
            return false
        }
        
        let validation = validateGymActivity()
        
        if !validation.isValid {
            //Throw alert
            return false
        }
        
        isSaving = true
        
        prepareGymActivityForSave()
        
        let saveActivity = await activityService.saveActivity(.gym(gymActivity))
        
        
        isSaving = false
        
        if saveActivity {
            //Display success animation
            if saveActivity {
                //Display success animation
            }else{
                //Report to Analitycs
                // Display toast for untrusted connection
            }
            //turn off loading spinner
            //Dismiss view
            return true
        } else{
            //Display alert
            //Report to Analitycs
            //turn off loading spinner
            //Dismiss view
            return false
        }
    }
}
