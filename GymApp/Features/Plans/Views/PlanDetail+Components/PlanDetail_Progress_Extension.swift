import SwiftUI

extension PlanDetailView {
    var progressSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.energyFitnessOrange)
                Text("Progress Overview")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                Spacer()
            }
            VStack(spacing: 12) {
                HStack {
                    Text(plan.progressText)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.fitnessTextPrimary)
                    Spacer()
                    Text("\(Int(plan.completionPercentage))%")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.energyFitnessOrange)
                }
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.fitnessInfo)
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    colors: [.energyFitnessOrange, .yellow],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * (plan.completionPercentage / 100), height: 12)
                    }
                }
                .frame(height: 12)
            }
            .padding(16)
            .background(Color.fitnessBackgroundSecondary)
            .cornerRadius(16)
            .clipped()
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 0)
        }
    }
}
