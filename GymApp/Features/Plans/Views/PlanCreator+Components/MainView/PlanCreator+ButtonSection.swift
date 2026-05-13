import SwiftUI

extension CreatePlanView {

    var PlanCreatorButtonsSection : some View {
        Button(action: {
            self.vm.isLoading = true
            Task {
                let ok = await vm.savePlan()
             
                if ok {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                        self.vm.isLoading = false
                        self.vm.savedPlanSuccess = true
                    }
                }
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                Text(StringConstants.savePlan)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(20)
            .background(
                LinearGradient(
                    colors: [.fitnessSuccess, .fitnessSuccess.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .buttonStyle(ScaleButtonStyle())
            .padding(.horizontal, 16)
        }
    }
}
