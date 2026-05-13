import Foundation

public final class PlanCreatorViewModel : ObservableObject {
    
    //UI Variables
    @Published var showRoutinePickerSheet : Bool = false
    
    @Published var plan: Plan
    @Published var isLoading : Bool = false
    @Published var showToast : Bool = false
    @Published var savedPlanSuccess : Bool = false
    
    @Published var selectedDay : Int?
    
    
    
    let service = PlanService()
    
    init() {
        self.plan = Plan(name: "", goal: .general, durationWeeks: 4, activitiesPerWeek: 3)
    }
    
    public func initView(){
        
    }
    
    public func savePlan() async -> Bool {
        let remoteSave = await service.savePlanRemote(plan)
        let localSave = await service.savePlanRemote(plan)
        
        return localSave
    }
    

    public func addActivityToPlan(_ activity: ActivityType) {
        guard let day = self.selectedDay else {
            return
        }
        
        let planElement = PlanElement(
            activity: activity,
            day: day
        )
        self.plan.elements.append(planElement)
    }
}
