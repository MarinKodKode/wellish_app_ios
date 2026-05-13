//
//  PlansViewViewModel.swift
//  Wellish
//

import Foundation

@MainActor
public final class PlansViewViewModel: ObservableObject {

    // MARK: - Published

    @Published var globalPlans: [Plan] = []
    @Published var myPlans: [Plan] = []
    @Published var myRoutines: [GymActivity] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Services

    private let plansService = PlanService()
    private let activityService = ActivityService()

    // MARK: - Init View

    public func initView() {
        Task {
            await loadAll()
        }
    }

    public func loadAll() async {
        isLoading = true
        defer { isLoading = false }

        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadGlobalPlans() }
            group.addTask { await self.loadMyPlans() }
            group.addTask { await self.loadMyRoutines() }
        }
    }

    // MARK: - Global Plans (Populares)

    /// Carga los planes plantilla globales de Wellish para la seccion "Populares"
    public func loadGlobalPlans() async {
        globalPlans = await plansService.getGlobalPlans()
    }

    // MARK: - My Plans (Planes activos del usuario)

    /// Carga los planes que el usuario esta siguiendo actualmente
    public func loadMyPlans() async {
        myPlans = await plansService.getActivePlans()
    }

    /// El usuario decide seguir un plan plantilla
    public func followPlan(_ plan: Plan) async -> Bool {
        let success = await plansService.followPlan(planId: plan.id)
        if success {
            await loadMyPlans()
        }
        return success
    }

    /// El usuario deja de seguir un plan
    public func unfollowPlan(_ plan: Plan) async -> Bool {
        let success = await plansService.unfollowPlan(id: plan.id)
        if success {
            await loadMyPlans()
        }
        return success
    }

    // MARK: - My Routines (GymActivity del usuario)

    /// Carga las rutinas de gym creadas por el usuario via ActivityService
    public func loadMyRoutines() async {
        let activities = await activityService.getActivities(category: .gym)
        myRoutines = activities.compactMap { activity -> GymActivity? in
            if case .gym(let gymActivity) = activity { return gymActivity }
            return nil
        }
    }

    // MARK: - Computed

    var hasGlobalPlans: Bool { !globalPlans.isEmpty }
    var hasMyPlans: Bool { !myPlans.isEmpty }
    var hasMyRoutines: Bool { !myRoutines.isEmpty }
}
