
import Foundation
import SwiftUI

struct LiveTrackerActivity : View {
    
    @StateObject private var vm = LiveTrackerActivityViewModel()
    let plan : Plan
    
    init(plan: Plan) {
        self.plan = plan
    }
    
    var body : some View {
        Group {
                if vm.isSettingUpView {
                    GymLiveTrackerSkeletonView()
                } else if let planElement = vm.planElement {
                    switch vm.activity {
                    case .gym:
                        GymLiveTrackerView(
                            planElement: planElement,
                            plan : plan
                        )
                    case .running:
                        RunningTrackerView()
                    case .cycling:
                        Text("Cycling tracker")
                    // ... resto de casos
                    default:
                        Text("Actividad no soportada")
                    }
                } else {
                    ContentUnavailableView(
                        "Sin actividades",
                        systemImage: "figure.run.circle",
                        description: Text("No hay actividades pendientes en este plan")
                    )
                }
            }
            .task {
                vm.initView(plan)
            }
    }
}
