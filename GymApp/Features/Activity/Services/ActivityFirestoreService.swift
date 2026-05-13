
import Foundation
import FirebaseFirestore
import FirebaseAuth

class ActivityFirestoreService {

    // MARK: - Properties

    private let db = Firestore.firestore()

    /// Colección global de base data semilla de Wellish
    private let globalCollection = "activities"

    /// Colección de actividades compartidas por código
    private let sharedCollection = "sharedActivities"

    // MARK: - Helper: User Activities Path

    private func userActivitiesCollection(userId: String) -> CollectionReference {
        db.collection("users")
            .document(userId)
            .collection("user-activities")
    }

    private func getCurrentUserId() throws -> String {
        guard let userId = Auth.auth().currentUser?.uid else {
            throw FirestoreError.notAuthenticated
        }
        return userId
    }

    // MARK: - CREATE

    @MainActor
    func uploadActivity(_ activity: ActivityType) async throws -> String {
        let userId = try getCurrentUserId()
        let docRef = try userActivitiesCollection(userId: userId)
            .addDocument(from: activity)
        return docRef.documentID
    }

    @MainActor
    func uploadActivityWithID(_ activity: ActivityType) async throws {
        let userId = try getCurrentUserId()
        try userActivitiesCollection(userId: userId)
            .document(activity.id)
            .setData(from: activity)
    }

    @MainActor
    func uploadActivities(_ activities: [ActivityType]) async throws {
        for activity in activities {
            try await uploadActivityWithID(activity)
        }
    }

    // MARK: - READ (User Activities)

    @MainActor
    func fetchUserActivities() async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        let snapshot = try await userActivitiesCollection(userId: userId).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    @MainActor
    func fetchUserActivities(category: ActivityCategory) async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        let snapshot = try await userActivitiesCollection(userId: userId)
            .whereField("activityType", isEqualTo: category.rawValue)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    @MainActor
    func fetchActivity(id: String) async throws -> ActivityType {
        let userId = try getCurrentUserId()
        let document = try await userActivitiesCollection(userId: userId)
            .document(id)
            .getDocument()

        guard document.exists else {
            throw FirestoreError.activityNotFound
        }

        return try document.data(as: ActivityType.self)
    }

    @MainActor
    func fetchUserActivities(bySource source: ActivitySource) async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        let snapshot = try await userActivitiesCollection(userId: userId)
            .whereField("source", isEqualTo: source.rawValue)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    @MainActor
    func fetchUserShareableActivities() async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        let snapshot = try await userActivitiesCollection(userId: userId)
            .whereField("shareable", isEqualTo: true)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    @MainActor
    func fetchUserActivities(withTag tag: String) async throws -> [ActivityType] {
        let userId = try getCurrentUserId()
        let snapshot = try await userActivitiesCollection(userId: userId)
            .whereField("tags", arrayContains: tag)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    // MARK: - READ (Global Base Data)

    /// Obtiene todas las activities de la base data global
    @MainActor
    func fetchGlobalActivities() async throws -> [ActivityType] {
        let snapshot = try await db.collection(globalCollection)
            .whereField("source", isEqualTo: ActivitySource.global.rawValue)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    /// Obtiene activities globales por tipo de actividad
    /// Requiere índice compuesto en Firestore: source + activityType
    @MainActor
    func fetchGlobalActivities(byActivityType activityType: String) async throws -> [ActivityType] {
        print("🔥 Fetching global activities by type: \(activityType)")
        let snapshot = try await db.collection(globalCollection)
            .whereField("source", isEqualTo: ActivitySource.global.rawValue)
            .whereField("activityTypeKey", isEqualTo: activityType)
            .getDocuments()
        print("🔥 Snapshot count: \(snapshot.documents.count)")
        let activities = snapshot.documents.compactMap { doc -> ActivityType? in
            do {
                return try doc.data(as: ActivityType.self)
            } catch {
                print("🔥 Decode error: \(error)")
                return nil
            }
        }
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    /// Obtiene templates públicos (source == .template)
    @MainActor
    func fetchGlobalTemplates() async throws -> [ActivityType] {
        let snapshot = try await db.collection(globalCollection)
            .whereField("source", isEqualTo: ActivitySource.template.rawValue)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    /// Obtiene templates públicos por categoría
    @MainActor
    func fetchGlobalTemplates(category: ActivityCategory) async throws -> [ActivityType] {
        let snapshot = try await db.collection(globalCollection)
            .whereField("source", isEqualTo: ActivitySource.template.rawValue)
            .whereField("activityType", isEqualTo: category.rawValue)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    /// Obtiene contenido de un club específico
    @MainActor
    func fetchClubActivities(clubId: String) async throws -> [ActivityType] {
        let snapshot = try await db.collection(globalCollection)
            .whereField("clubId", isEqualTo: clubId)
            .getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: ActivityType.self) }
    }

    /// Copia una activity global a la colección personal del usuario
    @MainActor
    func copyGlobalActivityToUser(activityId: String) async throws -> String {
        let userId = try getCurrentUserId()

        let globalDoc = try await db.collection(globalCollection)
            .document(activityId)
            .getDocument()

        guard globalDoc.exists else {
            throw FirestoreError.activityNotFound
        }

        let activity = try globalDoc.data(as: ActivityType.self)

        let newDocRef = try userActivitiesCollection(userId: userId)
            .addDocument(from: activity)

        return newDocRef.documentID
    }

    /// Copia un template a la colección personal del usuario
    @MainActor
    func copyTemplateToUser(templateId: String) async throws -> String {
        let userId = try getCurrentUserId()

        let templateDoc = try await db.collection(globalCollection)
            .document(templateId)
            .getDocument()

        guard templateDoc.exists else {
            throw FirestoreError.templateNotFound
        }

        let activity = try templateDoc.data(as: ActivityType.self)

        let newDocRef = try userActivitiesCollection(userId: userId)
            .addDocument(from: activity)

        return newDocRef.documentID
    }

    // MARK: - UPDATE

    @MainActor
    func updateActivity(_ activity: ActivityType) async throws {
        let userId = try getCurrentUserId()
        try userActivitiesCollection(userId: userId)
            .document(activity.id)
            .setData(from: activity, merge: true)
    }

    // MARK: - DELETE

    @MainActor
    func deleteActivity(id: String) async throws {
        let userId = try getCurrentUserId()
        try await userActivitiesCollection(userId: userId)
            .document(id)
            .delete()
    }

    @MainActor
    func deleteActivities(ids: [String]) async throws {
        for id in ids {
            try await deleteActivity(id: id)
        }
    }

    // MARK: - BATCH OPERATIONS

    @MainActor
    func uploadActivitiesBatch(_ activities: [ActivityType]) async throws {
        let userId = try getCurrentUserId()
        let batch = db.batch()

        for activity in activities {
            let docRef = userActivitiesCollection(userId: userId)
                .document(activity.id)
            try batch.setData(from: activity, forDocument: docRef)
        }

        try await batch.commit()
    }

    // MARK: - SHARING

    @MainActor
    func generateShareCode(activityId: String) async throws -> String {
        let userId = try getCurrentUserId()
        let activity = try await fetchActivity(id: activityId)

        guard activity.shareable else {
            throw FirestoreError.activityNotShareable
        }

        let code = generateRandomCode()

        try await db.collection(sharedCollection)
            .document(code)
            .setData([
                "userId": userId,
                "activityId": activityId,
                "createdAt": FieldValue.serverTimestamp(),
                "expiresAt": Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
            ])

        return code
    }

    @MainActor
    func importActivityFromCode(_ code: String) async throws -> String {
        let userId = try getCurrentUserId()

        let codeDoc = try await db.collection(sharedCollection)
            .document(code)
            .getDocument()

        guard codeDoc.exists,
              let data = codeDoc.data(),
              let ownerId = data["userId"] as? String,
              let activityId = data["activityId"] as? String
        else {
            throw FirestoreError.invalidShareCode
        }

        let activityDoc = try await db.collection("users")
            .document(ownerId)
            .collection("activities")
            .document(activityId)
            .getDocument()

        guard activityDoc.exists else {
            throw FirestoreError.activityNotFound
        }

        let activity = try activityDoc.data(as: ActivityType.self)

        let newDocRef = try userActivitiesCollection(userId: userId)
            .addDocument(from: activity)

        return newDocRef.documentID
    }

    // MARK: - HELPERS

    private func generateRandomCode() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map { _ in characters.randomElement()! })
    }
}

// MARK: - Statistics

//extension ActivityFirestoreService {
//
//    @MainActor
////    func getUserStatistics() async throws -> ActivityFirestoreStatistics {
////        let activities = try await fetchUserActivities()
////
////        var categoryCounts: [ActivityCategory: Int] = [:]
////        var sourceCounts: [ActivitySource: Int] = [:]
////
////        for activity in activities {
////            categoryCounts[activity.category, default: 0] += 1
////            sourceCounts[activity.source, default: 0] += 1
////        }
////
////        let totalDuration = activities.compactMap { $0.estimatedDuration }.reduce(0, +)
////        let totalCalories = activities.compactMap { $0.estimatedCalories }.reduce(0, +)
////
////        return ActivityFirestoreStatistics(
////            totalActivities: activities.count,
////            categoryCounts: categoryCounts,
////            sourceCounts: sourceCounts,
////            totalEstimatedDuration: totalDuration,
////            totalEstimatedCalories: totalCalories,
////            shareableCount: activities.filter { $0.shareable }.count
////        )
////    }
//}

// MARK: - Migration

extension ActivityFirestoreService {

    @MainActor
    func migrateRoutinesFromOldStructure() async throws {
        let userId = try getCurrentUserId()

        let oldSnapshot = try await db.collection("routines")
            .whereField("creator", isEqualTo: userId)
            .getDocuments()

        print("🔄 Migrando \(oldSnapshot.documents.count) rutinas antiguas...")

        var migratedCount = 0

        for doc in oldSnapshot.documents {
            do {
                let gymActivity = try doc.data(as: GymActivity.self)
                let activityType = ActivityType.gym(gymActivity)
                try await uploadActivityWithID(activityType)
                migratedCount += 1
            } catch {
                print("⚠️ Error migrando rutina \(doc.documentID): \(error.localizedDescription)")
            }
        }

        print("✅ Migración completada: \(migratedCount) rutinas migradas")
    }
}

enum FirestoreError: Error {
    case notAuthenticated
    case activityNotFound
    case invalidShareCode
    case activityNotShareable
    case templateNotFound
}
