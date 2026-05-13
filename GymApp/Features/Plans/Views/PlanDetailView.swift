import SwiftUI

public struct PlanDetailView: View {
    
    @State var plan: Plan
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navigationRouter: NavigationRouter
    @State var startedPlan : Bool = false
    @ObservedObject var vm: PlanDetailViewModel
    
    public var body : some View {
        ZStack{
            Color.backgroundPrimary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    
                    headerSection
                        .padding(.top, 24)
                        .padding(.horizontal, 16)
                    
                    Group {
                        if vm.isFollowing {
                            progressSection
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        } else {
                            startPlanButton
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    activitiesSection
                        .padding(.horizontal, 16)
                    
                }
            }
        }
        .navigationTitle(plan.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    Button("", systemImage: "square.and.arrow.up") {}

                    if !vm.isFollowing {
                        Button("", systemImage: vm.isSaved ? "bookmark.fill" : "bookmark") {
                            Task { _ = await vm.savePlan(plan) }
                        }
                    }

                    if vm.isFollowing {
                        Menu("", systemImage: "ellipsis") {
                            Button("Pausar", systemImage: "pause.circle") {
                                vm.onTap_StopTrackingPlan(plan)
                            }
                        }
                    }
                }
            }
        }
        .task {
            await vm.checkIfFollowing(plan.id)
        }
    }
}


#Preview {
    NavigationStack {
        PlanDetailView(
plan: Plan(
            name: "4-Week Fitness Challenge",
            description: "Complete fitness plan to improve your overall health and strength",
            category: "Fitness",
            elements: [
                PlanElement(
                    activity: .running(RunningActivity(
                        name: "Morning Run",
                        runningType: .steady,
                        targetDistanceKm: 5.0,
                        targetDurationMinutes: 30,
                        estimatedCalories: 300
                    )),
                    day: 1,
                    scheduledTime: Calendar.current
                        .date(
                            bySettingHour: 7,
                            minute: 0,
                            second: 0,
                            of: Date()
                        ),
                    imageURL: ""
                ),
                PlanElement(
                    activity: .gym(GymActivity(
                        name: "Upper Body Strength",
                        sets: [],
                        estimatedDurationMinutes: 45,
                        estimatedCalories: 320
                    )),
                    day: 1,
                    completed: true,
                    completedAt: Date(),
                    actualDurationMinutes: 48,
                    actualCalories: 340,
                    rpe: 8,
                    imageURL: ""
                ),
                PlanElement(
                    activity: .rest(RestActivity(
                        name: "Active Recovery",
                        restType: .active
                    )),
                    day: 2,
                    imageURL: ""
                ),
                PlanElement(
                    activity: .cycling(CyclingActivity(
                        name: "Evening Ride",
                        targetDistanceKm: 15.0,
                        targetDurationMinutes: 40,
                        estimatedCalories: 280
                    )),
                    day: 2,
                    scheduledTime: Calendar.current
                        .date(
                            bySettingHour: 18,
                            minute: 0,
                            second: 0,
                            of: Date()
                        ),
                    imageURL: ""
                )
            ],
            goal: .general,
            durationWeeks: 4
), vm:  PlanDetailViewModel()
)
    }
}
