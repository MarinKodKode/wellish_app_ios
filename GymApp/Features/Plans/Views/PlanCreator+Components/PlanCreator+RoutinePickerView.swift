
import SwiftUI

struct RoutinePickerView: View {

    @ObservedObject var vm : PlanCreatorViewModel
    
    let day: Int
    
    @Binding var dismissSheet: Bool
    
    let routineService = RoutineService()
    
    @State var routiness : [GymActivity] = []
    
    var body: some View {
        List {
            ForEach(routiness) { routine in
                Button {
                    handleRoutineSelection(routine)
                } label: {
                    RoutineRow(routine: routine)
                }
            }
        }
        .navigationTitle("Elige una rutina")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            Task {
                routiness = try await routineService.fetchRoutines()
            }
        }
    }
    
    private func handleRoutineSelection(_ routine: GymActivity) {
//        vm.addActivityToPlan(.routine(routine))
//        dismissSheet = false
    }
}
