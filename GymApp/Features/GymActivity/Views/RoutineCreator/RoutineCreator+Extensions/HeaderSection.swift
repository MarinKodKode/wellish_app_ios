
import SwiftUI

extension RoutineCreatorView {
    var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text(StringConstants.buildYourOwnRoutine)
                    .font(.system(size : 20))
                    .foregroundColor(.fitnessTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, -5)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.primaryFitnessBlue)
                }
                .padding(.top, -4)
            }
        }
    }
}


#Preview {
    RoutineCreatorView(viewModel: GymActivityViewModel())
        .preferredColorScheme(.light)
}

#Preview {
    RoutineCreatorView(viewModel: GymActivityViewModel())
        .preferredColorScheme(.dark)
}
