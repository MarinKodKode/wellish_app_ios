//
//  LiveTrackerActivityViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 20/11/25.
//

import Foundation

class LiveTrackerActivityViewModel : ObservableObject {
    
    @Published var activity : ActivityType?
    @Published var planElement : PlanElement? 
    @Published var isSettingUpView : Bool = true
    
    
    func initView(_ plan : Plan){
        
        planElement = plan.upcomingActivity()
        guard planElement != nil else {
            return
        }
        activity = planElement?.activity
        guard let upcomingActivity = activity  else {
            return
        }
        asingTracker(upcomingActivity)
        isSettingUpView = false
    }
    
    func startUpcomingActivity() {
        
    }
    
    func markPlanElementAsCompleted() {
        
    }
    
    func asingTracker(_ activity : ActivityType){
        
        switch activity {
        case .gym(let gymActivity) :
            GymLiveTrackerViewModel.shared.currentGymActivity = gymActivity
        default :
            return
        }
        
        
    }
}
