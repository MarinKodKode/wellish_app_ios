import SwiftUI

struct CreatePlanView: View {
    
    @StateObject var vm = PlanCreatorViewModel()
   
    @Environment(\.dismiss) var dismiss
    
    @State var showGoalPicker = false
    @State var showSpinner = false
    @State var showActivityTypeSheet = false
    @State var newTagText : String = ""
    @State var category : String = ""
    @State var tagsArray : [String] = []
    
    public var body: some View {
        ZStack {
            Color.fitnessBackgroundPrimary
                .ignoresSafeArea()
            ScrollView {
            VStack(spacing: 24) {
                
                PlanCreator_Header
                
                PlanCreator_DetailsSection
                
                PlanCreator_GoalSection
                
                PlanCreator_ConfigurationSection
                
                PlanCreator_ActivitiesSection
                
                PlanCreator_TagsSection
                
                PlanCreatorButtonsSection
                
            }
            .padding(.vertical)
        }
            .scrollIndicators(.hidden)
            if vm.savedPlanSuccess {
                LiveAnimationView(animationName: "saved_animation"){
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showGoalPicker) {
            GoalPickerSheet(selectedGoal: $vm.plan.goal)
        }
        .sheet(isPresented: $showActivityTypeSheet) {
            if let day = vm.selectedDay {
                ActivityTypePickerSheet(isPresented: $showActivityTypeSheet, day: day, viewModel: vm)
            }
        }
        .sheet(isPresented: $vm.showRoutinePickerSheet) {
            ExercisePickerView { exercise in
                vm.showRoutinePickerSheet = false
            }
        }
        .navigationTitle("Crear plan")
        .navigationBarTitleDisplayMode(.large)
        .hideKeyboardOnTap()
        .showLoadingView(when: vm.isLoading)
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Menu("", systemImage: "ellipsis"){
                    Button("Pausar", systemImage: "pause.circle"){
                    }
                    Button("Compartir", systemImage: "square.and.arrow.up"){
                    }
                }
            }
        }
    }
}
