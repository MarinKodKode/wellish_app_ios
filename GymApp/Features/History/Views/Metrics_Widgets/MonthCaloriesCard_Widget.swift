
import SwiftUI

struct MonthCaloriesCard_Widget : View {
    
    @ObservedObject var vm = MetricsHistoryViewModel()
    let totalCalories: Int
    let monthName: String
  
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\(monthName.uppercased()) 2025")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white.opacity(0.6))
            
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(hex: "1E2836"))
                
                VStack(spacing: 0) {
                    // Grid lines and bars
                    GeometryReader { geometry in
                        ZStack(alignment: .bottom) {
                            // Grid lines
                            VStack(spacing: 0) {
                                ForEach(0..<3) { i in
                                    HStack {
                                        Text("\(220 - (i * 110))")
                                            .font(.system(size: 12, weight: .regular))
                                            .foregroundColor(.white.opacity(0.3))
                                            .frame(width: 60, alignment: .trailing)
                                        
                                        Rectangle()
                                            .fill(Color.white.opacity(0.1))
                                            .frame(height: 1)
                                    }
                                    
                                    if i < 2 {
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.leading, 5)
                            .padding(.bottom, 50)
                            
                            // Bars
                            HStack(alignment: .bottom, spacing: 2) {
                                ForEach(1..<10) { day in
                                    VStack(spacing: 4) {
                                        Spacer()
                                        
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(Color(hex: "A8B5E8"))
                                            .frame(
                                                height: barHeight(
                                                    for: 300,
                                                    maxHeight: geometry.size.height - 50
                                                )
                                            )
                                        
                                        if shouldShowLabel(day: "day") {
                                            Text("day")
                                                .font(.system(size: 11, weight: .medium))
                                                .foregroundColor(.white.opacity(0.5))
                                        } else {
                                            Text("")
                                                .font(.system(size: 11))
                                        }
                                    }
                                }
                            }
                            .padding(.leading, 70)
                            .padding(.trailing, 20)
                            .padding(.bottom, 10)
                        }
                    }
                    .frame(height: 100)
                }
                .padding(.vertical, 30)
            }
        }
        .padding(20)
        .background(Color(hex: "1A2332"))
    }
    
    private func barHeight(for calories: Int, maxHeight: CGFloat) -> CGFloat {
        let ratio = CGFloat(calories) / CGFloat(100)
        return max(ratio * maxHeight, 8)
    }
    
    private func shouldShowLabel(day: String) -> Bool {
        // Show labels for days 1, 8, 15, 22, 29
        let showDays = ["1", "8", "15", "22", "29"]
        return showDays.contains(day)
    }
}

#Preview {
    MonthCaloriesCard_Widget(
        totalCalories: 12000,
        monthName: "Diciembre"
    )
}

struct StatBadge: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "3A4D5C").opacity(0.6))
        )
    }
}
