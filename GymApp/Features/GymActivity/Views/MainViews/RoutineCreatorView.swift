import SwiftUI

public struct RoutineCreatorView: View {
   
    @ObservedObject var vm: GymActivityViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State var showingExercisePicker = false
    @State var selectedSetIndex: Int? = nil
    @State var newTagText: String = ""
    @State var showRoutineCreator: Bool = false
    
    let widget = WidgetHelpers()

    public init(viewModel: GymActivityViewModel) {
        _vm = ObservedObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            Color.fitnessBackgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    
                    headerSection
                    
                    routineInfoSection
                    
                    exercisesAndSetsSection
                    
                    tagsSection
                    
                    metricsSection
                    
                    saveButton
                    
                    shareButton
                    
                   
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            
            if vm.savedSuccess {
                LiveAnimationView(animationName: "saved_animation"){
                    dismiss()
                }
            }
        }
        .sheet(isPresented: $showingExercisePicker) {
            ExercisePickerView { exercise in
                showingExercisePicker = false
                vm.addSet(with: exercise)
            }
        }
        .sheet(isPresented: $showRoutineCreator) {
            RoutineCreatorSheet(isPresented: $showRoutineCreator)
        }
        .navigationBarTitle(StringConstants.createRoutine, displayMode: .large)
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
