//
//  ActivityMaster.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 27/10/25.
//

import Foundation
import FirebaseFirestore

class AdminActivityManager {
    
    private let db = Firestore.firestore()
    private let globalCollection = "globalActivities"
    
    // MARK: - Upload to Master (globalActivities/)
    
    /// Sube UNA actividad al master de templates
    @MainActor
    func uploadToMaster(_ activity: ActivityType) async throws -> String {
        let docRef = try db.collection(globalCollection)
            .addDocument(from: activity)
        
        print("✅ MASTER: Activity uploaded [\(docRef.documentID)]")
        print("   Name: \(activity.displayName)")
        print("   Type: \(activity.category.rawValue)")
        
        return docRef.documentID
    }
    
    /// Sube actividad con ID específico al master
    @MainActor
    func uploadToMasterWithID(_ activity: ActivityType) async throws {
        try db.collection(globalCollection)
            .document(activity.id)
            .setData(from: activity)
        
        print("✅ MASTER: Activity uploaded with ID [\(activity.id)]")
        print("   Name: \(activity.displayName)")
    }
    
    /// Sube TODAS las activities del dataset al master
    @MainActor
    func uploadDatasetToMaster() async throws {
//        let activities = "ActivityDataset.allActivitiesAsTypes"
//
//        print("🚀 Uploading \(activities.count) activities to MASTER...")
//        
//        var successCount = 0
//        var errorCount = 0
//        
//        for activity in activities {
//            do {
//                try await uploadToMasterWithID(activity)
//                successCount += 1
//            } catch {
//                print("❌ Failed to upload \(activity.displayName): \(error.localizedDescription)")
//                errorCount += 1
//            }
//        }
//        
//        print("✅ Upload complete!")
//        print("   Success: \(successCount)")
//        print("   Failed: \(errorCount)")
    }
    
    /// Sube solo GYM activities del dataset
//    @MainActor
//    func uploadGymActivitiesToMaster() async throws {
//        let gymActivities = ActivityDataset.gymActivities
//        
//        print("🚀 Uploading \(gymActivities.count) GYM activities to MASTER...")
//        
//        for gymActivity in gymActivities {
//            try await uploadToMasterWithID(.gym(gymActivity))
//        }
//        
//        print("✅ All GYM activities uploaded!")
//    }
    
    /// Sube solo RUNNING activities del dataset
    @MainActor
    func uploadRunningActivitiesToMaster() async throws {
//        let runningActivities = ActivityDataset.runningActivities
//        
//        print("🚀 Uploading \(runningActivities.count) RUNNING activities to MASTER...")
//        
//        for runningActivity in runningActivities {
//            try await uploadToMasterWithID(.running(runningActivity))
//        }
//        
//        print("✅ All RUNNING activities uploaded!")
    }
    
    /// Sube solo REST activities del dataset
    @MainActor
    func uploadRestActivitiesToMaster() async throws {
//        let restActivities = ActivityDataset.restActivities
//        
//        print("🚀 Uploading \(restActivities.count) REST activities to MASTER...")
//        
//        for restActivity in restActivities {
//            try await uploadToMasterWithID(.rest(restActivity))
//        }
//        
//        print("✅ All REST activities uploaded!")
    }
    
    /// Sube activities por categoría
    @MainActor
    func uploadToMaster(category: ActivityCategory) async throws {
//        let activities = ActivityDataset.activities(for: category)
//        
//        guard !activities.isEmpty else {
//            print("⚠️ No activities found for \(category.rawValue)")
//            return
//        }
//        
//        print("🚀 Uploading \(activities.count) \(category.rawValue) activities to MASTER...")
//        
//        for activity in activities {
//            try await uploadToMasterWithID(activity)
//        }
//        
//        print("✅ All \(category.rawValue) activities uploaded!")
    }
    
    // MARK: - Read from Master
    
    /// Lista todas las activities del master
    @MainActor
    func listMasterActivities() async throws -> [ActivityType] {
        let snapshot = try await db.collection(globalCollection).getDocuments()
        
        let activities = snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
        
        print("📋 Master Activities: \(activities.count)")
        for activity in activities {
            print("   - [\(activity.category.rawValue)] \(activity.displayName) (\(activity.id))")
        }
        
        return activities
    }
    
    /// Lista activities del master por categoría
    @MainActor
    func listMasterActivities(category: ActivityCategory) async throws -> [ActivityType] {
        let snapshot = try await db.collection(globalCollection)
            .whereField("activityType", isEqualTo: category.rawValue)
            .getDocuments()
        
        let activities = snapshot.documents.compactMap { doc -> ActivityType? in
            try? doc.data(as: ActivityType.self)
        }
        
        print("📋 Master \(category.rawValue) Activities: \(activities.count)")
        return activities
    }
    
    // MARK: - Update Master
    
    /// Actualiza una actividad del master
    @MainActor
    func updateMasterActivity(_ activity: ActivityType) async throws {
        try db.collection(globalCollection)
            .document(activity.id)
            .setData(from: activity, merge: true)
        
        print("✅ MASTER: Activity updated [\(activity.id)]")
    }
    
    // MARK: - Delete from Master
    
    /// Elimina una actividad del master
    @MainActor
    func deleteFromMaster(id: String) async throws {
        try await db.collection(globalCollection)
            .document(id)
            .delete()
        
        print("✅ MASTER: Activity deleted [\(id)]")
    }
    
    /// Elimina TODAS las activities del master (⚠️ PELIGROSO)
    @MainActor
    func deleteAllFromMaster() async throws {
        let snapshot = try await db.collection(globalCollection).getDocuments()
        
        print("⚠️ DELETING ALL \(snapshot.documents.count) activities from MASTER...")
        
        for document in snapshot.documents {
            try await document.reference.delete()
        }
        
        print("✅ All activities deleted from MASTER")
    }
    
    /// Elimina activities por categoría del master
    @MainActor
    func deleteFromMaster(category: ActivityCategory) async throws {
        let snapshot = try await db.collection(globalCollection)
            .whereField("activityType", isEqualTo: category.rawValue)
            .getDocuments()
        
        print("⚠️ DELETING \(snapshot.documents.count) \(category.rawValue) activities from MASTER...")
        
        for document in snapshot.documents {
            try await document.reference.delete()
        }
        
        print("✅ All \(category.rawValue) activities deleted from MASTER")
    }
    
    // MARK: - Batch Operations
    
    /// Sube múltiples activities en batch (más eficiente)
    @MainActor
    func uploadBatchToMaster(_ activities: [ActivityType]) async throws {
        let batch = db.batch()
        
        for activity in activities {
            let docRef = db.collection(globalCollection).document(activity.id)
            try batch.setData(from: activity, forDocument: docRef)
        }
        
        try await batch.commit()
        print("✅ MASTER: Batch uploaded \(activities.count) activities")
    }
    
    // MARK: - Utilities
    
    /// Cuenta activities en el master
    @MainActor
    func countMasterActivities() async throws -> Int {
        let snapshot = try await db.collection(globalCollection).getDocuments()
        return snapshot.documents.count
    }
    
    /// Cuenta activities por categoría en el master
    @MainActor
    func countMasterActivities(category: ActivityCategory) async throws -> Int {
        let snapshot = try await db.collection(globalCollection)
            .whereField("activityType", isEqualTo: category.rawValue)
            .getDocuments()
        return snapshot.documents.count
    }
    
    /// Verifica si una actividad existe en el master
    @MainActor
    func existsInMaster(id: String) async throws -> Bool {
        let doc = try await db.collection(globalCollection)
            .document(id)
            .getDocument()
        return doc.exists
    }
    
    /// Genera reporte del estado del master
    @MainActor
    func generateMasterReport() async throws -> MasterReport {
        let activities = try await listMasterActivities()
        
        var categoryCounts: [ActivityCategory: Int] = [:]
        var sourceCounts: [ActivitySource: Int] = [:]
        
        for activity in activities {
            categoryCounts[activity.category, default: 0] += 1
            sourceCounts[activity.source, default: 0] += 1
        }
        
        let report = MasterReport(
            totalActivities: activities.count,
            categoryCounts: categoryCounts,
            sourceCounts: sourceCounts,
            activities: activities
        )
        
        print(report.formattedReport)
        
        return report
    }
    
    // MARK: - Migration & Cleanup
    
    /// Marca todas las activities del master como templates
    @MainActor
    func markAllAsTemplates() async throws {
        let snapshot = try await db.collection(globalCollection).getDocuments()
        
        print("🔄 Marking \(snapshot.documents.count) activities as templates...")
        
        for document in snapshot.documents {
            try await document.reference.updateData([
                "source": ActivitySource.template.rawValue
            ])
        }
        
        print("✅ All activities marked as templates")
    }
    
    /// Actualiza campo específico en todas las activities
    @MainActor
    func updateFieldInAll(field: String, value: Any) async throws {
        let snapshot = try await db.collection(globalCollection).getDocuments()
        
        print("🔄 Updating field '\(field)' in \(snapshot.documents.count) activities...")
        
        for document in snapshot.documents {
            try await document.reference.updateData([field: value])
        }
        
        print("✅ Field updated in all activities")
    }
}

// MARK: - Master Report

struct MasterReport {
    let totalActivities: Int
    let categoryCounts: [ActivityCategory: Int]
    let sourceCounts: [ActivitySource: Int]
    let activities: [ActivityType]
    
    var formattedReport: String {
        var report = """
        
        ═══════════════════════════════════════
        📊 MASTER ACTIVITIES REPORT
        ═══════════════════════════════════════
        
        Total Activities: \(totalActivities)
        
        """
        
        // Por categoría
        report += "📁 By Category:\n"
        for (category, count) in categoryCounts.sorted(by: { $0.value > $1.value }) {
            let percentage = Double(count) / Double(totalActivities) * 100
            report += "   • \(category.rawValue): \(count) (\(String(format: "%.1f", percentage))%)\n"
        }
        
        // Por fuente
        report += "\n📦 By Source:\n"
        for (source, count) in sourceCounts.sorted(by: { $0.value > $1.value }) {
            report += "   • \(source.rawValue): \(count)\n"
        }
        
        // Lista de activities
        report += "\n📋 Activities:\n"
        for activity in activities.sorted(by: { $0.category.rawValue < $1.category.rawValue }) {
            let duration = activity.estimatedDuration.map { "\($0) min" } ?? "—"
            let calories = activity.estimatedCalories.map { "\($0) kcal" } ?? "—"
            report += """
               [\(activity.category.rawValue)] \(activity.displayName)
                  ID: \(activity.id)
                  Duration: \(duration) | Calories: \(calories)
                  Source: \(activity.source.rawValue)
            
            """
        }
        
        report += "═══════════════════════════════════════\n"
        
        return report
    }
}

//// MARK: - Admin Button View (SwiftUI)
//
//#if DEBUG
//import SwiftUI
//
//struct AdminActivityUploadView: View {
//    
//    @State private var isUploading = false
//    @State private var statusMessage = ""
//    @State private var showReport = false
//    @State private var report: MasterReport?
//    
//    private let manager = AdminActivityManager()
//    
//    var body: some View {
//        NavigationView {
//            List {
//                Section("⚠️ ADMIN ONLY - Master Activities") {
//                    Text("Sube activities al master (globalActivities/)")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//                
//                Section("Upload Dataset") {
//                    uploadButton(
//                        title: "Upload ALL Activities",
//                        icon: "square.and.arrow.up.fill",
//                        color: .blue
//                    ) {
//                        try await manager.uploadDatasetToMaster()
//                    }
//                    
//                    uploadButton(
//                        title: "Upload GYM Activities",
//                        icon: "dumbbell.fill",
//                        color: .indigo
//                    ) {
//                        try await manager.uploadGymActivitiesToMaster()
//                    }
//                    
//                    uploadButton(
//                        title: "Upload RUNNING Activities",
//                        icon: "figure.run",
//                        color: .green
//                    ) {
//                        try await manager.uploadRunningActivitiesToMaster()
//                    }
//                    
//                    uploadButton(
//                        title: "Upload REST Activities",
//                        icon: "bed.double.fill",
//                        color: .gray
//                    ) {
//                        try await manager.uploadRestActivitiesToMaster()
//                    }
//                }
//                
//                Section("Master Info") {
//                    Button {
//                        Task {
//                            report = try await manager.generateMasterReport()
//                            showReport = true
//                        }
//                    } label: {
//                        Label("Generate Report", systemImage: "doc.text.fill")
//                    }
//                    
//                    Button {
//                        Task {
//                            let count = try await manager.countMasterActivities()
//                            statusMessage = "Master has \(count) activities"
//                        }
//                    } label: {
//                        Label("Count Activities", systemImage: "number")
//                    }
//                }
//                
//                Section("⚠️ Danger Zone") {
//                    Button(role: .destructive) {
//                        Task {
//                            try await manager.deleteAllFromMaster()
//                            statusMessage = "All activities deleted from master"
//                        }
//                    } label: {
//                        Label("Delete ALL from Master", systemImage: "trash.fill")
//                    }
//                }
//                
//                if !statusMessage.isEmpty {
//                    Section("Status") {
//                        Text(statusMessage)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
//            .navigationTitle("Admin - Master Upload")
//            .disabled(isUploading)
//            .sheet(isPresented: $showReport) {
//                if let report = report {
//                    ReportView(report: report)
//                }
//            }
//        }
//    }
//    
//    private func uploadButton(
//        title: String,
//        icon: String,
//        color: Color,
//        action: @escaping () async throws -> Void
//    ) -> some View {
//        Button {
//            Task {
//                isUploading = true
//                statusMessage = "Uploading..."
//                
//                do {
//                    try await action()
//                    statusMessage = "✅ \(title) - Success!"
//                } catch {
//                    statusMessage = "❌ Error: \(error.localizedDescription)"
//                }
//                
//                isUploading = false
//            }
//        } label: {
//            HStack {
//                Image(systemName: icon)
//                    .foregroundColor(color)
//                Text(title)
//                
//                if isUploading {
//                    Spacer()
//                    ProgressView()
//                        .scaleEffect(0.8)
//                }
//            }
//        }
//    }
//}
//
//struct ReportView: View {
//    let report: MasterReport
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                Text(report.formattedReport)
//                    .font(.system(.body, design: .monospaced))
//                    .padding()
//            }
//            .navigationTitle("Master Report")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//#Preview {
//    AdminActivityUploadView()
//}
//#endif
