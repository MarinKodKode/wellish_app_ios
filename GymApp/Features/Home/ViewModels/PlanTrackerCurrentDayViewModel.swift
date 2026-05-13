//
//  PlanTrackerCurrentDayViewModel.swift
//  Wellish
//

import Foundation

public class PlanTrackerCurrentDayViewModel: ObservableObject {

    private let planService = PlanService()

    @Published var activePlans: [Plan] = []
    @Published var todayActivities: [TodayActivityModel] = []
    @Published var isLoading: Bool = false

    var hasTodayActivities: Bool { !todayActivities.isEmpty }
    
    var streakDays: Int {
        let completed = activePlans.flatMap { $0.elements }.filter { $0.completed }
        return max(completed.count, 1)
    }
    
    var completedCount: Int {
        activePlans.flatMap { $0.elements }.filter { $0.completed }.count
    }

    public func initView() async {
        await MainActor.run { isLoading = true }
        activePlans = await fetchActivePlans()
        let activities = buildTodayActivities(from: activePlans)
        await MainActor.run {
            todayActivities = activities
            isLoading = false
        }
    }

    func fetchActivePlans() async -> [Plan] {
        let plans = await planService.getActivePlans()
        return plans.filter { $0.startDate != nil }
    }

    func buildTodayActivities(from plans: [Plan]) -> [TodayActivityModel] {
        var activities: [TodayActivityModel] = []
        for plan in plans {
            guard let element = plan.upcomingActivity() else { continue }
            activities.append(
                TodayActivityModel(
                    title: element.activity.displayName,
                    calories: element.activity.estimatedCalories?.asString ?? "0",
                    time: element.activity.estimatedDuration?.asString ?? "0",
                    element: element,
                    image: element.activity.imageURL ?? "",
                    parentPlan: plan
                )
            )
        }
        return activities
    }
}

struct TodayActivityModel: Identifiable, Codable {
    var id = UUID()
    var title: String
    var calories: String
    var time: String
    var element: PlanElement
    var image: String
    var parentPlan: Plan
}
