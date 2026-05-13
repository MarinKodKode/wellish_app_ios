//
//  PlanDetailViewModel.swift
//  Wellish
//

import Foundation
import SwiftUI

@MainActor
class PlanDetailViewModel: ObservableObject {

    // MARK: - Published

    @Published var isFollowing: Bool = false
    @Published var isSaving: Bool = false
    @Published var errorMessage: String?
    @Published var isSaved: Bool = false
    
    // MARK: - Services

    private let planService = PlanService()
    private let alertVM = AlertViewModel.shared

    // MARK: - Fetch

    /// Obtiene el plan desde la coleccion global (para planes plantilla)
    func fetchGlobalPlan(_ id: String) async -> Plan? {
        do {
            return try await planService.firestoreService.fetchGlobalPlan(id: id)
        } catch {
            print("❌ Error fetching global plan: \(error.localizedDescription)")
            return nil
        }
    }

    /// Obtiene el plan activo del usuario (copia personal)
    func fetchActivePlan(_ id: String) async -> Plan? {
        do {
            return try await planService.firestoreService.fetchActivePlan(id: id)
        } catch {
            print("❌ Error fetching active plan: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Follow / Unfollow

    /// El usuario decide seguir un plan plantilla global
    /// Crea una copia en /users/{userId}/activePlans
    func startTrackingPlan(_ plan: Plan) async -> Bool {
        guard !isSaving else { return false }
        isSaving = true
        defer { isSaving = false }

        let success = await planService.followPlan(planId: plan.id)

        if success {
            isFollowing = true
            print("✅ Plan seguido: \(plan.name)")
        } else {
            errorMessage = "No se pudo iniciar el plan. Intenta de nuevo."
            print("❌ Error siguiendo plan: \(plan.name)")
        }

        return success
    }

    /// El usuario deja de seguir un plan activo
    func stopTrackingPlan(_ plan: Plan) async -> Bool {
        guard !isSaving else { return false }
        isSaving = true
        defer { isSaving = false }

        let success = await planService.unfollowPlan(id: plan.id)

        if success {
            isFollowing = false
            print("✅ Plan abandonado: \(plan.name)")
        } else {
            errorMessage = "No se pudo pausar el plan. Intenta de nuevo."
        }

        return success
    }

    /// Muestra alerta de confirmacion antes de dejar de seguir el plan
    func onTap_StopTrackingPlan(_ plan: Plan) {
        alertVM.showWarningAlert(
            alertType: .stopTrackingPlan,
            alertMessage: StringConstants.warningStopTrackingPlan,
            action: {
                Task {
                    _ = await self.stopTrackingPlan(plan)
                }
            }
        )
    }

    // MARK: - Element Completion

    /// Marca un elemento del plan activo como completado
    /// Opera sobre la copia personal del usuario en /users/{userId}/activePlans
    func markElementAsCompleted(_ plan: Plan, _ planElement: PlanElement) async -> Bool {
        guard var mutablePlan = await fetchActivePlan(plan.id) else {
            // Fallback: intenta con el ID del plan activo si es diferente
            print("⚠️ No se encontro plan activo con ID \(plan.id)")
            return false
        }

        mutablePlan.markElementCompleted(id: planElement.id, completed: true)

        do {
            try await planService.firestoreService.updateActivePlan(mutablePlan)
            print("✅ Elemento completado: \(planElement.displayName)")
            return true
        } catch {
            errorMessage = "No se pudo marcar como completado."
            print("❌ Error: \(error.localizedDescription)")
            return false
        }
    }

    /// Verifica si el usuario ya esta siguiendo este plan
    func checkIfFollowing(_ planId: String) async {
        if let activePlan = await fetchActivePlan(planId) {
            isSaved = true
            isFollowing = activePlan.startDate != nil
        }
    }
    
    func savePlan(_ plan: Plan) async -> Bool {
        isSaving = true
        defer { isSaving = false }
        do {
            let id = try await planService.firestoreService.saveGlobalPlan(planId: plan.id)
            let saved = try await planService.firestoreService.fetchActivePlan(id: id)
            try await planService.localStorageService.savePlan(saved)
            isSaved = true
            AlertViewModel.shared.showSuccessToast(
                message: "Plan guardado correctamente",
                icon: "bookmark.fill"
            )
            return true
        } catch {
            errorMessage = "No se pudo guardar el plan."
            return false
        }
    }
}
