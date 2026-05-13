import SwiftUI

struct CompletedActivityCard : View {
    
    let activity : PlanElement
    
    init(activity: PlanElement) {
        self.activity = activity
    }
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: activity.imageURL ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.fitnessTextSecondary.opacity(0.2))
                    .overlay(
                        Image(systemName: "dumbbell.fill")
                            .foregroundColor(.fitnessTextSecondary)
                            .font(.title2)
                    )
            }
            .frame(width: 60, height: 60)
            .cornerRadius(12)
            .clipped()            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(activity.displayName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.fitnessTextPrimary)
                    Spacer()
                    Text(activity.activityCategoryString)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color.energyOrange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.fitnessSuccess.opacity(0.2))
                        .cornerRadius(8)
                }
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(.fitnessTextSecondary)
                        let durationText: String = {
                            if let minutes = activity.expectedDuration {
                                return "\(minutes) min"
                            } else {
                                return "—"
                            }
                        }()
                        Text(durationText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.fitnessTextSecondary)
                        let caloriesText: String = {
                            if let kcal = activity.expectedCalories {
                                return "\(kcal) kcal"
                            } else {
                                return "—"
                            }
                        }()
                        Text(caloriesText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                            .foregroundColor(.fitnessTextSecondary)
                        let completedAtText: String = {
                            guard let completed = activity.completedAt else {
                                return "—"
                            }
                            let formatter = DateFormatter()
                            formatter.locale = Locale(identifier: "es_MX")
                            formatter.dateFormat = "yy-MM-dd"
                            return formatter.string(from: completed)
                        }()
                        Text(completedAtText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                    }
                }
                .padding(.top, 8)
            }
            
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    .backgroundPrimary.opacity(0.4),
                    .fitnessInfo.opacity(0.3),
                    .fitnessProgress.opacity(0.4),
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.fitnessTextSecondary.opacity(0.1), lineWidth: 1)
        )
    }
}
