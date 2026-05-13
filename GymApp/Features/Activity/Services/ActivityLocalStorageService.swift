//
//  ActivityLocalStorageService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 27/10/25.
//

import Foundation

class ActivityLocalStorageService {
    
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Directories
    
    /// Directorio para actividades guardadas
    private var activitiesDirectory: URL {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let activitiesPath = documentsPath.appendingPathComponent("Activities", isDirectory: true)
        
        if !fileManager.fileExists(atPath: activitiesPath.path) {
            try? fileManager.createDirectory(at: activitiesPath, withIntermediateDirectories: true)
        }
        
        return activitiesPath
    }
    
    /// Archivo de índice que contiene IDs de todas las actividades
    private var indexFileURL: URL {
        activitiesDirectory.appendingPathComponent("activities_index.json")
    }
    
    // MARK: - Init
    
    init() {
        // Configurar encoder/decoder para fechas
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        
        // Configurar JSON para lectura y debug
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    }
    
    // MARK: - Create & Update
    
    /// Guarda una actividad en un archivo JSON
    @MainActor
    func saveActivity(_ activity: ActivityType) async throws {
        let fileURL = activityFileURL(for: activity.id)
        
        do {
            let data = try encoder.encode(activity)
            try data.write(to: fileURL, options: .atomic)
            try await updateIndex(addingActivityID: activity.id)
        } catch {
            throw LocalStorageError.saveFailed(error)
        }
    }
    
    /// Guarda múltiples actividades
    @MainActor
    func saveActivities(_ activities: [ActivityType]) async throws {
        for activity in activities {
            try await saveActivity(activity)
        }
    }
    
    // MARK: - Read
    
    func fetchActivity(id: String) async throws -> ActivityType {
        let fileURL = activityFileURL(for: id)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw LocalStorageError.activityNotFound(id)
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let activity = try decoder.decode(ActivityType.self, from: data)
            return activity
        } catch {
            throw LocalStorageError.readFailed(error)
        }
    }
    
    /// Obtiene todas las actividades guardadas localmente
    @MainActor
    func fetchActivities() async throws -> [ActivityType] {
        let activityIDs = try await loadIndex()
        var activities: [ActivityType] = []
        
        for id in activityIDs {
            do {
                let activity = try await fetchActivity(id: id)
                activities.append(activity)
            } catch {
                print("⚠️ Error fetching activity \(id), skipping...")
            }
        }
        
        print("✅ \(activities.count) activities loaded from local storage")
        print("Activities : -\(activities)")
        return activities
    }
    
    // MARK: - Delete
    
    /// Elimina una actividad del almacenamiento local usando su ID
    @MainActor
    func deleteActivity(_ id: String) async throws {
        let fileURL = activityFileURL(for: id)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw LocalStorageError.activityNotFound(id)
        }
        
        do {
            try fileManager.removeItem(at: fileURL)
            try await updateIndex(removingActivityID: id)
            print("✅ Activity deleted: \(id)")
        } catch {
            print("❌ Error deleting activity: \(error.localizedDescription)")
            throw LocalStorageError.deleteFailed(error)
        }
    }
    
    /// Elimina todas las actividades
    @MainActor
    func deleteAllActivities() async throws {
        let activityIDs = try await loadIndex()
        
        for id in activityIDs {
            try? await deleteActivity(id)
        }
        
        // Limpiar índice
        try saveIndex([])
        print("✅ All activities deleted")
    }
    
    // MARK: - Queries
    
    /// Obtiene actividades por categoría
    @MainActor
    func fetchActivities(byCategory category: ActivityCategory) async throws -> [ActivityType] {
        let allActivities = try await fetchActivities()
        return allActivities.filter { $0.category == category }
    }
    
    /// Obtiene actividades por creador
    @MainActor
    func fetchActivities(byCreator creatorID: String) async throws -> [ActivityType] {
        let allActivities = try await fetchActivities()
        return allActivities.filter { $0.activity.creator == creatorID }
    }
    
    /// Obtiene actividades compartibles
    @MainActor
    func fetchShareableActivities() async throws -> [ActivityType] {
        let allActivities = try await fetchActivities()
        return allActivities.filter { $0.shareable }
    }
    
    /// Obtiene actividades por fuente (created, template, community, club)
    @MainActor
    func fetchActivities(bySource source: ActivitySource) async throws -> [ActivityType] {
        let allActivities = try await fetchActivities()
        return allActivities.filter { $0.source == source }
    }
    
    /// Obtiene actividades de un club específico
    @MainActor
    func fetchActivities(byClub clubId: String) async throws -> [ActivityType] {
        let allActivities = try await fetchActivities()
        return allActivities.filter { $0.activity.clubId == clubId }
    }
    
    /// Busca actividades por query
    @MainActor
    func searchActivities(query: String) async throws -> [ActivityType] {
        let allActivities = try await fetchActivities()
        let lowercasedQuery = query.lowercased()
        
        return allActivities.filter { activity in
            let name = activity.displayName.lowercased()
            let description = activity.description?.lowercased() ?? ""
            let tags = activity.tags.map { $0.lowercased() }
            
            return name.contains(lowercasedQuery) ||
                   description.contains(lowercasedQuery) ||
                   tags.contains { $0.contains(lowercasedQuery) }
        }
    }
    
    /// Obtiene actividades con filtros múltiples
    @MainActor
    func fetchActivities(
        category: ActivityCategory? = nil,
        source: ActivitySource? = nil,
        tags: [String]? = nil,
        minDuration: Int? = nil,
        maxDuration: Int? = nil
    ) async throws -> [ActivityType] {
        var activities = try await fetchActivities()
        
        // Filtrar por categoría
        if let category = category {
            activities = activities.filter { $0.category == category }
        }
        
        // Filtrar por fuente
        if let source = source {
            activities = activities.filter { $0.source == source }
        }
        
        // Filtrar por tags
        if let tags = tags, !tags.isEmpty {
            activities = activities.filter { activity in
                !Set(activity.tags).isDisjoint(with: Set(tags))
            }
        }
        
        // Filtrar por duración mínima
        if let minDuration = minDuration {
            activities = activities.filter {
                guard let duration = $0.estimatedDuration else { return false }
                return duration >= minDuration
            }
        }
        
        // Filtrar por duración máxima
        if let maxDuration = maxDuration {
            activities = activities.filter {
                guard let duration = $0.estimatedDuration else { return false }
                return duration <= maxDuration
            }
        }
        
        return activities
    }
    
    // MARK: - Utilities
    
    /// Verifica si existe una actividad localmente
    func activityExists(id: String) -> Bool {
        let fileURL = activityFileURL(for: id)
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    /// Obtiene el tamaño del almacenamiento
    func getStorageSize() throws -> Int64 {
        var totalSize: Int64 = 0
        
        let files = try fileManager.contentsOfDirectory(
            at: activitiesDirectory,
            includingPropertiesForKeys: [.fileSizeKey]
        )
        
        for file in files {
            let attributes = try fileManager.attributesOfItem(atPath: file.path)
            if let size = attributes[.size] as? Int64 {
                totalSize += size
            }
        }
        
        return totalSize
    }
    
    /// Formatea el tamaño del almacenamiento
    func getFormattedStorageSize() throws -> String {
        let size = try getStorageSize()
        return ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
    
    /// Obtiene estadísticas del almacenamiento local
    @MainActor
    func getStatistics() async throws -> ActivityStorageStatistics {
        let activities = try await fetchActivities()
        let storageSize = try getStorageSize()
        
        // Contar por categoría
        var categoryCounts: [ActivityCategory: Int] = [:]
        for activity in activities {
            categoryCounts[activity.category, default: 0] += 1
        }
        
        // Calcular duración total estimada
        let totalDuration = activities.compactMap { $0.estimatedDuration }.reduce(0, +)
        
        // Calcular calorías totales estimadas
        let totalCalories = activities.compactMap { $0.estimatedCalories }.reduce(0, +)
        
        // Contar por fuente
        let createdCount = activities.filter { $0.source == .created }.count
        let templateCount = activities.filter { $0.source == .template }.count
        let communityCount = activities.filter { $0.source == .community }.count
        let clubCount = activities.filter { $0.source == .club }.count
        
        return ActivityStorageStatistics(
            totalActivities: activities.count,
            categoryCounts: categoryCounts,
            createdCount: createdCount,
            templateCount: templateCount,
            communityCount: communityCount,
            clubCount: clubCount,
            totalEstimatedDuration: totalDuration,
            totalEstimatedCalories: totalCalories,
            storageSize: storageSize,
            formattedSize: ByteCountFormatter.string(fromByteCount: storageSize, countStyle: .file)
        )
    }
    
    // MARK: - Index Management
    
    /// Carga el índice de IDs de actividades
    private func loadIndex() async throws -> [String] {
        guard fileManager.fileExists(atPath: indexFileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: indexFileURL)
            let index = try decoder.decode([String].self, from: data)
            return index
        } catch {
            print("⚠️ Error loading index, attempting to rebuild...")
            try await rebuildIndex()
            return try await loadIndex()
        }
    }
    
    /// Guarda el índice de IDs de actividades
    private func saveIndex(_ ids: [String]) throws {
        let data = try encoder.encode(ids)
        try data.write(to: indexFileURL, options: .atomic)
    }
    
    /// Actualiza el índice agregando un ID
    private func updateIndex(addingActivityID id: String) async throws {
        var ids = try await loadIndex()
        
        if !ids.contains(id) {
            ids.append(id)
            try saveIndex(ids)
        }
    }
    
    /// Actualiza el índice removiendo un ID
    private func updateIndex(removingActivityID id: String) async throws {
        var ids = try await loadIndex()
        ids.removeAll { $0 == id }
        try saveIndex(ids)
    }
    
    /// Reconstruye el índice escaneando todos los archivos
    @MainActor
    private func rebuildIndex() async throws {
        let files = try fileManager.contentsOfDirectory(
            at: activitiesDirectory,
            includingPropertiesForKeys: nil
        )
        
        let activityFiles = files.filter {
            $0.pathExtension == "json" &&
            $0.lastPathComponent != "activities_index.json"
        }
        
        var ids: [String] = []
        
        for file in activityFiles {
            let id = file.deletingPathExtension().lastPathComponent
            ids.append(id)
        }
        
        try saveIndex(ids)
        print("✅ Index rebuilt with \(ids.count) activities")
    }
    
    // MARK: - Private Helpers
    
    /// Genera la URL del archivo para una actividad específica
    private func activityFileURL(for id: String) -> URL {
        activitiesDirectory.appendingPathComponent("\(id).json")
    }
}

// MARK: - Supporting Types

enum LocalStorageError: LocalizedError {
    case saveFailed(Error)
    case readFailed(Error)
    case deleteFailed(Error)
    case activityNotFound(String)
    case planNotFound(String)
    case indexCorrupted
    
    var errorDescription: String? {
        switch self {
        case .saveFailed(let error):
            return "Error al guardar: \(error.localizedDescription)"
        case .readFailed(let error):
            return "Error al leer: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Error al eliminar: \(error.localizedDescription)"
        case .activityNotFound(let id):
            return "Actividad no encontrada: \(id)"
        case .planNotFound(let id):
            return "Plan no encontrado: \(id)"
        case .indexCorrupted:
            return "Índice corrupto, reconstruyendo..."
        }
    }
}

struct ActivityStorageStatistics {
    let totalActivities: Int
    let categoryCounts: [ActivityCategory: Int]
    let createdCount: Int
    let templateCount: Int
    let communityCount: Int
    let clubCount: Int
    let totalEstimatedDuration: Int // minutos
    let totalEstimatedCalories: Int
    let storageSize: Int64
    let formattedSize: String
    
    // Computed properties
    
    var formattedDuration: String {
        let hours = totalEstimatedDuration / 60
        let minutes = totalEstimatedDuration % 60
        if hours > 0 {
            return "\(hours)h \(minutes)min"
        } else {
            return "\(minutes) min"
        }
    }
    
    var formattedCalories: String {
        "\(totalEstimatedCalories) kcal"
    }
    
    var categorySummary: String {
        categoryCounts.map { category, count in
            "\(category.rawValue): \(count)"
        }.joined(separator: ", ")
    }
    
    var sourcesSummary: String {
        var parts: [String] = []
        if createdCount > 0 { parts.append("Creadas: \(createdCount)") }
        if templateCount > 0 { parts.append("Templates: \(templateCount)") }
        if communityCount > 0 { parts.append("Comunidad: \(communityCount)") }
        if clubCount > 0 { parts.append("Club: \(clubCount)") }
        return parts.joined(separator: " · ")
    }
}

// MARK: - Migration Helper (de RoutineLocalStorageService)

extension ActivityLocalStorageService {
    
    /// Migra rutinas antiguas (GymActivity) al nuevo formato (ActivityType)
    @MainActor
    func migrateFromRoutineStorage() async throws {
        // Ruta del antiguo directorio de rutinas
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let oldRoutinesPath = documentsPath.appendingPathComponent("Routines", isDirectory: true)
        
        guard fileManager.fileExists(atPath: oldRoutinesPath.path) else {
            print("ℹ️ No hay rutinas antiguas para migrar")
            return
        }
        
        // Leer archivo de índice antiguo
        let oldIndexPath = oldRoutinesPath.appendingPathComponent("routines_index.json")
        
        guard fileManager.fileExists(atPath: oldIndexPath.path) else {
            print("ℹ️ No hay índice de rutinas antiguas")
            return
        }
        
        do {
            let indexData = try Data(contentsOf: oldIndexPath)
            let oldRoutineIDs = try decoder.decode([String].self, from: indexData)
            
            print("🔄 Migrando \(oldRoutineIDs.count) rutinas antiguas...")
            
            var migratedCount = 0
            
            for id in oldRoutineIDs {
                let oldFileURL = oldRoutinesPath.appendingPathComponent("\(id).json")
                
                guard fileManager.fileExists(atPath: oldFileURL.path) else {
                    continue
                }
                
                do {
                    let data = try Data(contentsOf: oldFileURL)
                    let gymActivity = try decoder.decode(GymActivity.self, from: data)
                    
                    // Convertir a ActivityType
                    let activityType = ActivityType.gym(gymActivity)
                    
                    // Guardar en nueva ubicación
                    try await saveActivity(activityType)
                    
                    migratedCount += 1
                } catch {
                    print("⚠️ Error migrando rutina \(id): \(error.localizedDescription)")
                }
            }
            
            print("✅ Migración completada: \(migratedCount) rutinas migradas")
            
            // Opcional: eliminar directorio antiguo
            // try? fileManager.removeItem(at: oldRoutinesPath)
            
        } catch {
            print("❌ Error en migración: \(error.localizedDescription)")
            throw error
        }
    }
}
