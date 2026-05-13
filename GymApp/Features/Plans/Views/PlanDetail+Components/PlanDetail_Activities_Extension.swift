import SwiftUI

extension PlanDetailView {
    var activitiesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                Text("Plan Activities")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                Spacer()
            }
            
            if plan.elements.isEmpty {
                emptyStateView
            } else {
                ForEach(Array(plan.elements.enumerated()), id: \.element.id) { index, element in

                List {
                        Button(action: {
//                            navigationRouter
//                                .goTo(.gymActivityDetail(routines[0]))
                        }, label: {
                            PlanElementRow(
                                element: element,
                                onToggleComplete: {
                                    plan.markElementCompleted(at: index, completed: !element.completed)
                                }
                            )
                        })
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button {
                                // plan.skipElement(at: index)
                            } label: {
                                Label("Saltar", systemImage: "forward.fill")
                            }
                            .tint(.orange)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                .listStyle(.plain)
                .frame(height: 116)
                .scrollDisabled(true)
                }
                

            }
        }
    }
}
