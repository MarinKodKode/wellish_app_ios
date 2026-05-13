//
//  PlanFirebaseService.swift
//  Wellish
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class PlanFirebaseService {

    // MARK: - Properties

    private let db = Firestore.firestore()

    /// Coleccion global de planes plantilla — base data de Wellish
    private let globalPlansCollection = "plans"

    // MARK: - Helpers

    private func userActivePlansCollection(userId: String) -> CollectionReference {
        db.collection("users")
            .document(userId)
            .collection("activePlans")
    }

    private func userCreatedPlansCollection(userId: String) -> CollectionReference {
        db.collection("users")
            .document(userId)
            .collection("userCreatedPlans")
    }

    private func getCurrentUserId() throws -> String {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw PlanServiceError.notAuthenticated
        }
        return userId
    }

    // MARK: - CREATE (Global Plans)

    @MainActor
    func uploadPlan(_ plan: Plan) async throws -> String {
        let docRef = try db.collection(globalPlansCollection).addDocument(from: plan)
        return docRef.documentID
    }

    @MainActor
    func uploadPlanWithID(_ plan: Plan) async throws {
        try db.collection(globalPlansCollection)
            .document(plan.id)
            .setData(from: plan)
    }

    // MARK: - READ (Global Plans — Plantillas)

    /// Obtiene todos los planes plantilla globales de Wellish
    @MainActor
    func fetchGlobalPlans() async throws -> [Plan] {
        let snapshot = try await db.collection(globalPlansCollection)
            .getDocuments()
        let plans = snapshot.documents.compactMap { doc -> Plan? in
            do {
                return try doc.data(as: Plan.self)
            } catch {
                return nil
            }
        }
        return plans
    }

    /// Obtiene planes plantilla por goal
    /// Requiere indice compuesto: isGlobal + goal
    @MainActor
    func fetchGlobalPlans(byGoal goal: PlanGoal) async throws -> [Plan] {
        let snapshot = try await db.collection(globalPlansCollection)
            .whereField("isGlobal", isEqualTo: true)
            .whereField("goal", isEqualTo: goal.rawValue)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Plan.self) }
    }

    /// Obtiene planes plantilla por categoria de actividad
    /// Requiere indice compuesto: isGlobal + category
    @MainActor
    func fetchGlobalPlans(byCategory category: ActivityCategory) async throws -> [Plan] {
        let snapshot = try await db.collection(globalPlansCollection)
            .whereField("isGlobal", isEqualTo: true)
            .whereField("category", isEqualTo: category.rawValue)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Plan.self) }
    }

    /// Obtiene un plan plantilla especifico por ID
    @MainActor
    func fetchGlobalPlan(id: String) async throws -> Plan {
        let document = try await db.collection(globalPlansCollection)
            .document(id)
            .getDocument()

        guard document.exists else {
            throw PlanServiceError.planNotFound(id)
        }

        return try document.data(as: Plan.self)
    }

    // MARK: - READ (User Plans — Legacy support)

    /// Mantiene compatibilidad con el flujo actual que trae todos los planes
    @MainActor
    func fetchPlans() async throws -> [Plan] {
        let snapshot = try await db.collection(globalPlansCollection).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Plan.self) }
    }

    /// Obtiene planes filtrados por userId — flujo actual
    @MainActor
    func fetchPlans(for userId: String) async throws -> [Plan] {
        let snapshot = try await db.collection(globalPlansCollection)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Plan.self) }
    }

    /// Obtiene un plan por ID
    @MainActor
    func fetchPlan(with id: String) async throws -> Plan {
        let document = try await db.collection(globalPlansCollection)
            .document(id)
            .getDocument()

        guard document.exists else {
            throw PlanServiceError.planNotFound(id)
        }

        return try document.data(as: Plan.self)
    }

    // MARK: - READ (Active Plans — Usuario siguiendo un plan)

    /// Obtiene los planes que el usuario esta siguiendo actualmente
    @MainActor
    func fetchActivePlans() async throws -> [Plan] {
        let userId = try getCurrentUserId()
        let snapshot = try await userActivePlansCollection(userId: userId).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Plan.self) }
    }

    /// Obtiene un plan activo especifico
    @MainActor
    func fetchActivePlan(id: String) async throws -> Plan {
        let userId = try getCurrentUserId()
        print("🔍 fetchActivePlan - userId: \(userId), planId: \(id)")
        let document = try await userActivePlansCollection(userId: userId)
            .document(id)
            .getDocument()

        guard document.exists else {
            throw PlanServiceError.planNotFound(id)
        }

        return try document.data(as: Plan.self)
    }

    /// Copia un plan plantilla global a los planes activos del usuario
    /// Este es el flujo de "seguir un plan"
    @MainActor
    func followGlobalPlan(planId: String) async throws -> String {
        let userId = try getCurrentUserId()
        // Obtener la copia existente o el plan global
        let docRef = userActivePlansCollection(userId: userId).document(planId)
        var plan: Plan
        let existing = try await docRef.getDocument()
        if existing.exists {
            plan = try existing.data(as: Plan.self)
        } else {
            let globalDoc = try await db.collection(globalPlansCollection)
                .document(planId).getDocument()
            guard globalDoc.exists else { throw PlanServiceError.planNotFound(planId) }
            plan = try globalDoc.data(as: Plan.self)
        }
        plan.start() // Solo aqui se inicia
        try docRef.setData(from: plan)
        return planId
    }

    // MARK: - UPDATE

    @MainActor
    func updatePlan(_ plan: Plan) async throws {
        var updatedPlan = plan
        updatedPlan.updatedAt = Date()

        try db.collection(globalPlansCollection)
            .document(plan.id)
            .setData(from: updatedPlan, merge: true)
    }

    /// Actualiza el progreso de un plan activo del usuario
    @MainActor
    func updateActivePlan(_ plan: Plan) async throws {
        let userId = try getCurrentUserId()
        var updatedPlan = plan
        updatedPlan.updatedAt = Date()

        try userActivePlansCollection(userId: userId)
            .document(plan.id)
            .setData(from: updatedPlan, merge: true)
    }

    // MARK: - DELETE

    func deletePlan(id: String) async throws {
        try await db.collection(globalPlansCollection)
            .document(id)
            .delete()
    }

    /// Deja de seguir un plan activo
    @MainActor
    func unfollowActivePlan(id: String) async throws {
        let userId = try getCurrentUserId()
        try await userActivePlansCollection(userId: userId)
            .document(id)
            .delete()
    }

    // MARK: - QUERIES

    @MainActor
    func fetchPlans(byCategory category: ActivityCategory) async throws -> [Plan] {
        let snapshot = try await db.collection(globalPlansCollection)
            .whereField("category", isEqualTo: category.rawValue)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Plan.self) }
    }
    
    @MainActor
    func saveGlobalPlan(planId: String) async throws -> String {
        let userId = try getCurrentUserId()
        let planDoc = try await db.collection(globalPlansCollection)
            .document(planId).getDocument()
        guard planDoc.exists else { throw PlanServiceError.planNotFound(planId) }
        let plan = try planDoc.data(as: Plan.self)
        // Sin plan.start() — no tiene startDate aun
        let docRef = userActivePlansCollection(userId: userId).document(planId)
        try docRef.setData(from: plan)
        return planId
    }
}

// MARK: - PlanServiceError

enum PlanServiceError: LocalizedError {
    case notAuthenticated
    case planNotFound(String)
    case planNotFollowable

    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Usuario no autenticado"
        case .planNotFound(let id):
            return "Plan no encontrado: \(id)"
        case .planNotFollowable:
            return "Este plan no puede seguirse en este momento"
        }
    }
}
