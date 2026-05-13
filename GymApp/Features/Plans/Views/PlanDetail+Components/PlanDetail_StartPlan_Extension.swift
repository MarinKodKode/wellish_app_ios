import SwiftUI

extension PlanDetailView {
    var startPlanButton: some View {
        Button(action: {
            Task {
                await vm.startTrackingPlan(plan)
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "play.fill")
                    .font(.system(size: 20, weight: .bold))
                
                Text("Start Plan")
                    .font(.system(size: 18, weight: .bold))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: Color.blue.opacity(0.4), radius: 12, x: 0, y: 6)
        }
    }
}
