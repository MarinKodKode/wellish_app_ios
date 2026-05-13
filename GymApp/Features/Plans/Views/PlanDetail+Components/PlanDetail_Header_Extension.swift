
import SwiftUI

extension PlanDetailView {
    
    var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let description = plan.description {
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(Color(.fitnessTextSecondary))
                    .multilineTextAlignment(.leading)
            }
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.fitnessInfo)
                    Text(plan.formattedDuration)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.fitnessTextSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.fitnessBackgroundSecondary)
                .cornerRadius(8)
                
                HStack(spacing: 6) {
                    Image(systemName: "figure.run")
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                    Text("\(plan.totalActivities) activities")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.fitnessTextSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.fitnessBackgroundSecondary)
                .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
