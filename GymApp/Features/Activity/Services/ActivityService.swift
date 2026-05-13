//
//  ActivityService.swift
//  Wellish
//

import Foundation
import Combine

protocol ActivityServiceProtocol {
    var errorMessage: String? { get set }
    var isOnline: Bool { get }
    var lastSyncDate: Date? { get }

    func getActivities() async -> [ActivityType]
    func getActivities(category: ActivityCategory) async -> [ActivityType]
    func getActivity(by id: String) async -> ActivityType?
    func saveActivity(_ activity: ActivityType) async -> Bool
    func deleteActivity(id: String) async -> Bool
    func syncActivities() async -> Bool
}

// MARK: - ActivityService

final class ActivityService: ActivityServiceProtocol, ObservableObject {

    // MARK: - Published Properties

    @Published public var errorMessage: String?
    @Published public var isOnline: Bool = true
    @Published public var lastSyncDate: Date?
    @Published public var isSyncing: Bool = false

    // MARK: - Services

    private let firestoreService = ActivityFirestoreService()
    private let localStorageService = ActivityLocalStorageService()

    // MARK: - Configuration

    public enum SyncStrategy {
        case localFirst
        case firestoreFirst
        case localOnly
        case firestoreOnly
    }

    public var syncStrategy: SyncStrategy = .localFirst

    // MARK: - Init

    init() {}

    // MARK: - Public Methods

    public func getActivities() async -> [ActivityType] {
        do {
            return try await fetchActivities()
        } catch {
            print("⚠️ Error getting activities: \(error.localizedDescription)")
            return []
        }
    }

    public func getActivities(category: ActivityCategory) async -> [ActivityType] {
        do {
            return try await fetchActivities(category: category)
        } catch {
            print("⚠️ Error getting \(category.rawValue) activities: \(error.localizedDescription)")
            return []
        }
    }

    public func getActivity(by id: String) async -> ActivityType? {
        do {
            return try await fetchActivity(by: id)
        } catch {
            print("⚠️ Error getting activity \(id): \(error.localizedDescription)")
            return nil
        }
    }

    public func saveActivity(_ activity: ActivityType) async -> Bool {
        await MainActor.run { errorMessage = nil }
        do {
            try await saveActivityToStorage(activity)
            print("✅ Activity saved: \(activity.displayName)")
            return true
        } catch {
            await MainActor.run { errorMessage = "Error al guardar: \(error.localizedDescription)" }
            return false
        }
    }

    public func deleteActivity(id: String) async -> Bool {
        await MainActor.run { errorMessage = nil }
        do {
            try await deleteActivityFromStorage(id: id)
            print("✅ Activity deleted: \(id)")
            return true
        } catch {
            await MainActor.run { errorMessage = "Error al eliminar: \(error.localizedDescription)" }
            return false
        }
    }

    public func syncActivities() async -> Bool {
        await MainActor.run { isSyncing = true; errorMessage = nil }
        defer { Task { @MainActor in isSyncing = false } }

        do {
            try await performSync()
            await MainActor.run { lastSyncDate = Date() }
            print("✅ Sync completed")
            return true
        } catch {
            await MainActor.run { errorMessage = "Error en sincronización: \(error.localizedDescription)" }
            return false
        }
    }

    // MARK: - Global Base Data

    /// Obtiene activities de la base data global de Wellish por tipo de actividad
    /// Usar para el sheet de selección al armar un plan
    public func getGlobalActivities(byActivityType activityType: String) async -> [ActivityType] {
        do {
            return try await firestoreService.fetchGlobalActivities(byActivityType: activityType)
        } catch {
            print("❌ Error fetching global activities for \(activityType): \(error.localizedDescription)")
            return []
        }
    }

    /// Obtiene todas las activities de la base data global
    public func getGlobalActivities() async -> [ActivityType] {
        do {
            return try await firestoreService.fetchGlobalActivities()
        } catch {
            print("❌ Error fetching global activities: \(error.localizedDescription)")
            return []
        }
    }

    /// Obtiene templates públicos con filtro opcional de categoría
    public func getGlobalTemplates(category: ActivityCategory? = nil) async -> [ActivityType] {
        do {
            if let category = category {
                return try await firestoreService.fetchGlobalTemplates(category: category)
            } else {
                return try await firestoreService.fetchGlobalTemplates()
            }
        } catch {
            print("❌ Error fetching global templates: \(error.localizedDescription)")
            return []
        }
    }

    /// Copia una activity global a la colección personal del usuario
    public func copyGlobalActivityToUser(activityId: String) async -> Bool {
        do {
            let newId = try await firestoreService.copyGlobalActivityToUser(activityId: activityId)
            print("✅ Global activity copied: \(newId)")
            _ = await syncActivities()
            return true
        } catch {
            await MainActor.run { errorMessage = "Error copiando actividad: \(error.localizedDescription)" }
            return false
        }
    }

    /// Copia un template a la colección personal del usuario
    public func copyTemplateToUser(templateId: String) async -> Bool {
        do {
            let newId = try await firestoreService.copyTemplateToUser(templateId: templateId)
            print("✅ Template copied: \(newId)")
            _ = await syncActivities()
            return true
        } catch {
            await MainActor.run { errorMessage = "Error copiando template: \(error.localizedDescription)" }
            return false
        }
    }

    // MARK: - Sharing

    public func generateShareCode(activityId: String) async -> String? {
        do {
            let code = try await firestoreService.generateShareCode(activityId: activityId)
            print("✅ Share code generated: \(code)")
            return code
        } catch {
            await MainActor.run { errorMessage = "Error generando código: \(error.localizedDescription)" }
            return nil
        }
    }

    public func importActivityFromCode(_ code: String) async -> Bool {
        do {
            let activityId = try await firestoreService.importActivityFromCode(code)
            print("✅ Activity imported: \(activityId)")
            _ = await syncActivities()
            return true
        } catch {
            await MainActor.run { errorMessage = "Error importando: \(error.localizedDescription)" }
            return false
        }
    }

    // MARK: - Statistics

//    public func getStatistics() async -> ActivityServiceStatistics? {
//        do {
//            let localStats = try await localStorageService.getStatistics()
//            let firestoreStats = try? await firestoreService.getUserStatistics()
//            return ActivityServiceStatistics(
//                localStats: localStats,
//                firestoreStats: firestoreStats,
//                isOnline: isOnline,
//                lastSyncDate: lastSyncDate
//            )
//        } catch {
//            print("❌ Error getting statistics: \(error.localizedDescription)")
//            return nil
//        }
//    }

    // MARK: - Internal Fetch Logic

    internal func fetchActivities() async throws -> [ActivityType] {
        await MainActor.run { errorMessage = nil }
        switch syncStrategy {
        case .localFirst:    return try await fetchActivitiesLocalFirst()
        case .firestoreFirst: return try await fetchActivitiesFirestoreFirst()
        case .localOnly:     return try await fetchActivitiesLocalOnly()
        case .firestoreOnly: return try await fetchActivitiesFirestoreOnly()
        }
    }

    internal func fetchActivities(category: ActivityCategory) async throws -> [ActivityType] {
        await MainActor.run { errorMessage = nil }
        switch syncStrategy {
        case .localFirst:    return try await fetchActivitiesLocalFirst(category: category)
        case .firestoreFirst: return try await fetchActivitiesFirestoreFirst(category: category)
        case .localOnly:     return try await localStorageService.fetchActivities(byCategory: category)
        case .firestoreOnly: return try await firestoreService.fetchUserActivities(category: category)
        }
    }

    internal func fetchActivity(by id: String) async throws -> ActivityType? {
        await MainActor.run { errorMessage = nil }

        do {
            let activity = try await firestoreService.fetchActivity(id: id)
            await MainActor.run { isOnline = true }
            try await localStorageService.saveActivity(activity)
            return activity
        } catch {
            print("⚠️ Firestore failed, trying local...")
            await MainActor.run { isOnline = false }
        }

        do {
            let activity = try await localStorageService.fetchActivity(id: id)
            await MainActor.run { errorMessage = "Mostrando versión local (sin conexión)" }
            return activity
        } catch {
            print("❌ Activity not found: \(id)")
            return nil
        }
    }

    // MARK: - Fetch Strategies

    private func fetchActivitiesLocalFirst() async throws -> [ActivityType] {
        do {
            let local = try await localStorageService.fetchActivities()
            if !local.isEmpty {
                print("✅ Loaded \(local.count) activities from local")
                Task { try? await syncWithFirestore() }
                return local
            }
        } catch {
            print("⚠️ Local storage failed, trying Firestore...")
        }
        return try await fetchActivitiesFirestoreOnly()
    }

    private func fetchActivitiesLocalFirst(category: ActivityCategory) async throws -> [ActivityType] {
        do {
            let local = try await localStorageService.fetchActivities(byCategory: category)
            if !local.isEmpty {
                print("✅ Loaded \(local.count) \(category.rawValue) activities from local")
                Task { try? await syncWithFirestore() }
                return local
            }
        } catch {
            print("⚠️ Local storage failed, trying Firestore...")
        }
        let firestore = try await firestoreService.fetchUserActivities(category: category)
        try await localStorageService.saveActivities(firestore)
        return firestore
    }

    private func fetchActivitiesFirestoreFirst() async throws -> [ActivityType] {
        do {
            let firestore = try await firestoreService.fetchUserActivities()
            await MainActor.run { isOnline = true; lastSyncDate = Date() }
            print("✅ Loaded \(firestore.count) activities from Firestore")
            Task { try await localStorageService.saveActivities(firestore) }
            return firestore
        } catch {
            print("⚠️ Firestore failed, trying local...")
            await MainActor.run { isOnline = false }
        }
        return try await fetchActivitiesLocalOnly()
    }

    private func fetchActivitiesFirestoreFirst(category: ActivityCategory) async throws -> [ActivityType] {
        do {
            let firestore = try await firestoreService.fetchUserActivities(category: category)
            await MainActor.run { isOnline = true; lastSyncDate = Date() }
            Task { try await localStorageService.saveActivities(firestore) }
            return firestore
        } catch {
            print("⚠️ Firestore failed, trying local...")
            await MainActor.run { isOnline = false }
        }
        return try await localStorageService.fetchActivities(byCategory: category)
    }

    private func fetchActivitiesLocalOnly() async throws -> [ActivityType] {
        let local = try await localStorageService.fetchActivities()
        await MainActor.run {
            isOnline = false
            if !local.isEmpty { errorMessage = "Mostrando actividades locales (modo offline)" }
        }
        return local
    }

    private func fetchActivitiesFirestoreOnly() async throws -> [ActivityType] {
        let firestore = try await firestoreService.fetchUserActivities()
        await MainActor.run { isOnline = true; lastSyncDate = Date() }
        return firestore
    }

    // MARK: - Save / Delete

    internal func saveActivityToStorage(_ activity: ActivityType) async throws {
        try await localStorageService.saveActivity(activity)
        print("✅ Saved to local storage")
        do {
            try await firestoreService.uploadActivityWithID(activity)
            await MainActor.run { isOnline = true; lastSyncDate = Date() }
            print("✅ Saved to Firestore")
        } catch {
            await MainActor.run { isOnline = false }
            print("⚠️ Firestore save failed, queued for sync")
        }
    }

    internal func deleteActivityFromStorage(id: String) async throws {
        try await localStorageService.deleteActivity(id)
        print("✅ Deleted from local storage")
        do {
            try await firestoreService.deleteActivity(id: id)
            await MainActor.run { isOnline = true; lastSyncDate = Date() }
            print("✅ Deleted from Firestore")
        } catch {
            await MainActor.run { isOnline = false }
            print("⚠️ Firestore delete failed, queued for sync")
        }
    }

    // MARK: - Sync

    internal func performSync() async throws {
        print("🔄 Starting sync...")
        let firestore = try await firestoreService.fetchUserActivities()
        try await localStorageService.deleteAllActivities()
        try await localStorageService.saveActivities(firestore)
        await MainActor.run { isOnline = true; lastSyncDate = Date() }
        print("✅ Sync completed: \(firestore.count) activities")
    }

    private func syncWithFirestore() async throws {
        let firestore = try await firestoreService.fetchUserActivities()
        try await localStorageService.saveActivities(firestore)
        await MainActor.run { lastSyncDate = Date() }
    }
}

// MARK: - Statistics Model

//struct ActivityServiceStatistics {
//    let localStats: ActivityStorageStatistics
//    let firestoreStats: ActivityFirestoreStatistics?
//    let isOnline: Bool
//    let lastSyncDate: Date?
//
//    var totalActivities: Int { localStats.totalActivities }
//
//    var syncStatus: String {
//        if let syncDate = lastSyncDate {
//            let formatter = RelativeDateTimeFormatter()
//            return "Última sincronización: \(formatter.localizedString(for: syncDate, relativeTo: Date()))"
//        }
//        return "Sin sincronizar"
//    }
//}
