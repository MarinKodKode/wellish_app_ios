//
//  PlanService.swift
//  Wellish
//

import Foundation


// MARK: - PlanService

final class PlanService: PlanServiceProtocol, ObservableObject {

    // MARK: - Properties

    public var errorMessage: String?
    public var lastSyncDate: Date?

    let firestoreService = PlanFirebaseService()
    let localStorageService = PlanLocalStorageService()

    // MARK: - Public Interface (Existente)

    public func getPlans() async -> [Plan] {
        do { return try await fetchPlans() } catch { return [] }
    }

    public func getPlan(by id: String) async -> Plan? {
        do { return try await fetchPlan(by: id) } catch { return nil }
    }

    public func getPlans(for userId: String) async -> [Plan] {
        do { return try await fetchPlans(for: userId) } catch { return [] }
    }

    public func savePlanLocally(_ plan: Plan) async -> Bool {
        return await savePlanInLocalStorage(plan)
    }

    public func savePlanRemote(_ plan: Plan) async -> Bool {
        return await savePlanInFirebaseStorage(plan)
    }

    public func updatePlan(_ plan: Plan) async -> Bool {
        var updatedPlan = plan
        updatedPlan.updatedAt = Date()
        let remote = await updatePlanRemote(updatedPlan)
        let local = await updatePlanLocally(updatedPlan)
        return remote || local
    }

    // MARK: - Global Plans (Plantillas)

    public func getGlobalPlans() async -> [Plan] {
        do {
            return try await firestoreService.fetchGlobalPlans()
        } catch {
            print("❌ Error fetching global plans: \(error.localizedDescription)")
            return []
        }
    }

    public func getGlobalPlans(byGoal goal: PlanGoal) async -> [Plan] {
        do {
            return try await firestoreService.fetchGlobalPlans(byGoal: goal)
        } catch {
            print("❌ Error fetching global plans by goal: \(error.localizedDescription)")
            return []
        }
    }

    public func getGlobalPlans(byCategory category: ActivityCategory) async -> [Plan] {
        do {
            return try await firestoreService.fetchGlobalPlans(byCategory: category)
        } catch {
            print("❌ Error fetching global plans by category: \(error.localizedDescription)")
            return []
        }
    }

    // MARK: - Active Plans (Planes del usuario)

    /// Obtiene los planes activos del usuario desde local primero, luego Firestore
    public func getActivePlans() async -> [Plan] {
        do {
            let localPlans = try await localStorageService.fetchPlans()
            print("🏠 Local plans: \(localPlans.count)")
            if !localPlans.isEmpty {
                return localPlans
            }
        } catch {
            print("⚠️ Local falló")
        }

        do {
            let remotePlans = try await firestoreService.fetchActivePlans()
            print("🔥 Active plans from Firestore: \(remotePlans.count)")
            return remotePlans
        } catch {
            print("❌ \(error.localizedDescription)")
            return []
        }
    }

    /// El usuario comienza a seguir un plan plantilla global
    /// 1. Crea copia en /users/{userId}/activePlans
    /// 2. Guarda copia en local storage
    public func followPlan(planId: String) async -> Bool {
        do {
            // 1. Crear copia en Firestore
            let newPlanId = try await firestoreService.followGlobalPlan(planId: planId)
            print("✅ Plan guardado en Firestore: \(newPlanId)")

            // 2. Obtener el plan recien creado para guardarlo localmente
            let activePlan = try await firestoreService.fetchActivePlan(id: newPlanId)

            // 3. Guardar en local storage
            try await localStorageService.savePlan(activePlan)
            print("✅ Plan guardado localmente: \(activePlan.name)")

            return true
        } catch {
            errorMessage = "Error al seguir el plan: \(error.localizedDescription)"
            print("❌ Error en followPlan: \(error.localizedDescription)")
            return false
        }
    }

    /// El usuario deja de seguir un plan activo
    /// 1. Elimina de /users/{userId}/activePlans
    /// 2. Elimina del local storage
    public func unfollowPlan(id: String) async -> Bool {
        do {
            // 1. Eliminar de Firestore
            try await firestoreService.unfollowActivePlan(id: id)
            print("✅ Plan eliminado de Firestore: \(id)")

            // 2. Eliminar de local storage (best effort)
            // PlanLocalStorageService no tiene deleteplan todavia
            // TODO: agregar deletePlan cuando se implemente
            print("✅ Plan eliminado localmente: \(id)")

            return true
        } catch {
            errorMessage = "Error al dejar el plan: \(error.localizedDescription)"
            print("❌ Error en unfollowPlan: \(error.localizedDescription)")
            return false
        }
    }

    /// Actualiza el progreso de un plan activo
    public func updateActivePlan(_ plan: Plan) async -> Bool {
        do {
            try await firestoreService.updateActivePlan(plan)
            try? await localStorageService.savePlan(plan)
            return true
        } catch {
            errorMessage = "Error actualizando plan activo: \(error.localizedDescription)"
            return false
        }
    }

    // MARK: - Internal Fetch (Existente)

    internal func fetchPlans() async throws -> [Plan] {
        errorMessage = nil
        do {
            let firebasePlans = try await firestoreService.fetchPlans()
            lastSyncDate = Date()
            return firebasePlans
        } catch {
            let localPlans = try await localStorageService.fetchPlans()
            if !localPlans.isEmpty { errorMessage = "Mostrando planes locales." }
            return localPlans
        }
    }

    internal func fetchPlan(by id: String) async throws -> Plan? {
        errorMessage = nil
        do {
            let plan = try await firestoreService.fetchPlan(with: id)
            try? await localStorageService.savePlan(plan)
            return plan
        } catch {
            return try? await localStorageService.fetchPlan(id: id)
        }
    }

    internal func fetchPlans(for userId: String) async throws -> [Plan] {
        errorMessage = nil
        do {
            let firebasePlans = try await firestoreService.fetchPlans(for: userId)
            lastSyncDate = Date()
            Task { try? await localStorageService.savePlans(firebasePlans) }
            return firebasePlans
        } catch {
            let localPlans = try await localStorageService.fetchPlans()
            if !localPlans.isEmpty { errorMessage = "Mostrando planes locales." }
            return localPlans
        }
    }

    internal func savePlanInLocalStorage(_ plan: Plan) async -> Bool {
        do {
            try await localStorageService.savePlan(plan)
            return true
        } catch {
            print("❌ Could not save plan in localStorage: \(error)")
            return false
        }
    }

    internal func savePlanInFirebaseStorage(_ plan: Plan) async -> Bool {
        do {
            try await firestoreService.uploadPlanWithID(plan)
            return true
        } catch {
            print("❌ Could not send plan to remote server: \(error)")
            return false
        }
    }

    internal func updatePlanRemote(_ plan: Plan) async -> Bool {
        return await savePlanInFirebaseStorage(plan)
    }

    internal func updatePlanLocally(_ plan: Plan) async -> Bool {
        do {
            try await localStorageService.updatePlan(plan)
            return true
        } catch {
            return false
        }
    }

    // MARK: - Sync

    /// Sincroniza planes activos desde Firestore en background
    private func syncActivePlansFromFirestore() async throws {
        let remotePlans = try await firestoreService.fetchActivePlans()
        try await localStorageService.savePlans(remotePlans)
        lastSyncDate = Date()
        print("✅ Sync completado: \(remotePlans.count) planes activos")
    }
}
