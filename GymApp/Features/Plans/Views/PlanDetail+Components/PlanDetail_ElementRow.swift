
import SwiftUI

struct PlanElementRow: View {
    
    let element: PlanElement
    let onToggleComplete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            if let imageURL = element.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    activityIcon
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                activityIcon
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(element.displayName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.fitnessTextPrimary)
                        .lineLimit(1)
                    Spacer()
                }
                HStack{
                    Text("Day \(element.day)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(6)
                    Text(element.activityCategoryString.capitalized)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(hex: element.colorHex))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(hex: element.colorHex).opacity(0.2))
                        .cornerRadius(6)
                }
                
                HStack(spacing: 12) {
                    if let duration = element.expectedDuration {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.system(size: 12))
                                .foregroundColor(Color(white: 0.6))
                            Text("\(duration) min")
                                .font(.system(size: 13))
                                .foregroundColor(Color(white: 0.6))
                        }
                    }
                    if let calories = element.expectedCalories {
                        HStack(spacing: 4) {
                            Image(systemName: "flame")
                                .font(.system(size: 12))
                                .foregroundColor(Color(white: 0.6))
                            Text("\(calories) kcal")
                                .font(.system(size: 13))
                                .foregroundColor(Color(white: 0.6))
                        }
                    }
                }
                
                if element.completed {
                    HStack(spacing: 8) {
                        if let performance = element.performanceSummary {
                            Text(performance)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.green)
                                .lineLimit(1)
                        }
                        if let badge = element.performanceBadge {
                            Text(badge)
                                .font(.system(size: 10))
                        }
                    }
                } else {
                    if let time = element.formattedTime {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.badge")
                                .font(.system(size: 12))
                                .foregroundColor(.orange)
                            Text(time)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            
            Button(action: onToggleComplete) {
                ZStack {
                    Circle()
                        .fill(element.completed ? Color.green.opacity(0.2) : Color.blue)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: element.completed ? "checkmark" : "play.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(element.completed ? .green : .white)
                }
            }
        }
        .padding(12)
        .background(Color.backgroundSecondary)
        .cornerRadius(16)
        .clipped()
        .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 0)
    }
    
    private var activityIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [iconColor.opacity(0.3), iconColor.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Image(systemName: element.icon)
                .font(.system(size: 32))
                .foregroundColor(iconColor)
        }
    }

    private var iconColor: Color {
        Color(hex: element.colorHex)
    }
}
