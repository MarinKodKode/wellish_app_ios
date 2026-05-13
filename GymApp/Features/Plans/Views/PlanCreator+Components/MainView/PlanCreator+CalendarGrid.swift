
import SwiftUI

extension CreatePlanView {
    var PlanCreator_CalendarGrid : some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
            ForEach(1...vm.plan.totalDays, id: \.self) { day in
                
                let activityElement = vm.plan.elements.first { $0.day == day }
                
                let hasActivity = activityElement != nil
                
                Button {
                    vm.selectedDay = day
                    showActivityTypeSheet = true
                } label: {
                    VStack(spacing: 4) {
                        Text("\(day)")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(width: 36, height: 36)
                    .aspectRatio(1, contentMode: .fit)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(hasActivity ? Color.blue : Color(hex: "1E293B").opacity(0.5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        hasActivity
                                        ? Color(
                                            hex: activityElement!.activity.colorHex
                                        )
                                        : Color(hex: "1E293B").opacity(0.5)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.white.opacity(hasActivity ? 0 : 0.1), lineWidth: 1)
                                    )
                            )
                    )
                    .foregroundColor(hasActivity ? .white : .secondary)
                }
            }
        }
        .padding(.horizontal)
    }
}
