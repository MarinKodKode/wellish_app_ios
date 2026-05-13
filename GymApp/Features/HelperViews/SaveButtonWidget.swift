
import SwiftUI

struct SaveButtonWidget: View {
    
    let text : String
    let action: () async -> Void
    @Binding var isLoading: Bool
    
    init(text: String, action: @escaping () async -> Void, isLoading: Binding<Bool>) {
        self.text = text
        self._isLoading = isLoading
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            isLoading = true
            Task {
                await action()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                    isLoading = false
                }
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                Text(text)
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
