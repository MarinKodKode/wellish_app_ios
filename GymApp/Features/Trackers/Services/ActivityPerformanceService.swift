//
//  ActivityPerformanceService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//
import Foundation
import Combine

public class PerformanceLogService: ObservableObject {
    
    // MARK: - Singleton
    
    public static let shared = PerformanceLogService()
    
    // MARK: - Published Properties
    
    @Published public private(set) var performanceLogs: [GymActivityPerformance] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var error: PerformanceLogError?
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    private let logsKey = "performanceLogs"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Init
    
    private init() {
        setupEncoders()
        loadLogs()
    }
    
    private func setupEncoders() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - CRUD Operations
    
    /// Crear un nuevo performance log (iniciar sesión)
    public func startSession(
        planElementId: String? = nil,
        gymActivityId: String? = nil,
        userId: String? = nil
    ) -> GymActivityPerformance {
        let performance = GymActivityPerformance(
            planElementId: planElementId,
            gymActivityId: gymActivityId,
            userId: userId,
            startedAt: Date()
        )
        
        return performance
    }
    
    /// Guardar o actualizar un performance log
    public func savePerformance(_ performance: GymActivityPerformance) {
        if let index = performanceLogs.firstIndex(where: { $0.id == performance.id }) {
            // Actualizar existente
            performanceLogs[index] = performance
        } else {
            // Agregar nuevo
            performanceLogs.append(performance)
        }
        
        persistLogs()
    }
    
    /// Completar una sesión
    public func completeSession(
        _ performance: inout GymActivityPerformance,
        durationMinutes: Int? = nil,
        calories: Int? = nil,
        rpe: Int? = nil,
        notes: String? = nil
    ) {
        performance.complete(
            durationMinutes: durationMinutes,
            calories: calories,
            rpe: rpe,
            notes: notes
        )
        
        savePerformance(performance)
    }
    
    /// Agregar un set completado a una sesión activa
    public func addPerformedSet(
        to performance: inout GymActivityPerformance,
        set: PerformedRoutineSet
    ) {
        performance.addPerformedSet(set)
        savePerformance(performance)
    }
    
    /// Obtener un performance por ID
    public func getPerformance(byId id: String) -> GymActivityPerformance? {
        return performanceLogs.first(where: { $0.id == id })
    }
    
    /// Obtener performances por PlanElement
    public func getPerformances(forPlanElement planElementId: String) -> [GymActivityPerformance] {
        return performanceLogs.filter { $0.planElementId == planElementId }
    }
    
    /// Obtener performances por GymActivity
    public func getPerformances(forGymActivity gymActivityId: String) -> [GymActivityPerformance] {
        return performanceLogs.filter { $0.gymActivityId == gymActivityId }
    }
    
    /// Obtener performances por fecha
    public func getPerformances(forDate date: Date) -> [GymActivityPerformance] {
        let calendar = Calendar.current
        return performanceLogs.filter { performance in
            calendar.isDate(performance.startedAt, inSameDayAs: date)
        }
    }
    
    /// Obtener performances en un rango de fechas
    public func getPerformances(from startDate: Date, to endDate: Date) -> [GymActivityPerformance] {
        return performanceLogs.filter { performance in
            performance.startedAt >= startDate && performance.startedAt <= endDate
        }
    }
    
    /// Obtener solo sesiones completadas
    public func getCompletedPerformances() -> [GymActivityPerformance] {
        return performanceLogs.filter { $0.isCompleted }
    }
    
    /// Obtener sesiones activas (no completadas)
    public func getActivePerformances() -> [GymActivityPerformance] {
        return performanceLogs.filter { !$0.isCompleted }
    }
    
    /// Eliminar un performance
    public func deletePerformance(byId id: String) {
        performanceLogs.removeAll(where: { $0.id == id })
        persistLogs()
    }
    
    /// Eliminar todos los logs
    public func deleteAllPerformances() {
        performanceLogs.removeAll()
        persistLogs()
    }
    
    // MARK: - Statistics & Analytics
    
    /// Total de sesiones completadas
    public var totalCompletedSessions: Int {
        getCompletedPerformances().count
    }
    
    /// Volumen total levantado (todos los tiempos)
    public var totalVolumeLifted: Double {
        performanceLogs.reduce(0) { $0 + $1.totalVolumeKg }
    }
    
    /// Promedio de RPE
    public var averageRPE: Double {
        let completedWithRPE = performanceLogs.filter { $0.isCompleted && $0.rpe != nil }
        guard !completedWithRPE.isEmpty else { return 0 }
        
        let totalRPE = completedWithRPE.compactMap { $0.rpe }.reduce(0, +)
        return Double(totalRPE) / Double(completedWithRPE.count)
    }
    
    /// Calorías totales quemadas
    public var totalCaloriesBurned: Int {
        performanceLogs.compactMap { $0.actualCalories }.reduce(0, +)
    }

    public var totalCaloriesBurnedThisMonth : Int {
        getPerformancesThisMonth().compactMap { $0.actualCalories }.reduce(0, +)
    }
    
    public var totalCaloriesBurnedThiwWeek : Int {
        getPerformancesThisWeek().compactMap { $0.actualCalories }.reduce(0, +)
    }
    
    /// Tiempo total de entrenamiento (en minutos)
    public var totalTrainingMinutes: Int {
        performanceLogs.compactMap { $0.actualDurationMinutes }.reduce(0, +)
    }
    
    /// Última sesión completada
    public var lastCompletedSession: GymActivityPerformance? {
        getCompletedPerformances()
            .sorted(by: { $0.startedAt > $1.startedAt })
            .first
    }
    
    /// Sesiones esta semana
    public func getPerformancesThisWeek() -> [GymActivityPerformance] {
        let calendar = Calendar.current
        let now = Date()
        guard let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)) else {
            return []
        }
        
        return getPerformances(from: weekStart, to: now)
    }
    
    /// Sesiones este mes
    public func getPerformancesThisMonth() -> [GymActivityPerformance] {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: now)
        guard let monthStart = calendar.date(from: components) else {
            return []
        }
        
        return getPerformances(from: monthStart, to: now)
    }
    
    /// Progresión de volumen (últimas N sesiones)
    public func getVolumeProgression(lastN: Int = 10) -> [VolumeDataPoint] {
        return getCompletedPerformances()
            .sorted(by: { $0.startedAt < $1.startedAt })
            .suffix(lastN)
            .map { VolumeDataPoint(date: $0.startedAt, volume: $0.totalVolumeKg) }
    }
    
    // MARK: - Local Storage (UserDefaults)
    
    private func loadLogs() {
        isLoading = true
        
        guard let data = userDefaults.data(forKey: logsKey) else {
            isLoading = false
            return
        }
        
        do {
            performanceLogs = try decoder.decode([GymActivityPerformance].self, from: data)
            isLoading = false
        } catch {
            self.error = .decodingFailed(error)
            isLoading = false
            print("❌ Error loading performance logs: \(error)")
        }
    }
    
    private func persistLogs() {
        do {
            let data = try encoder.encode(performanceLogs)
            userDefaults.set(data, forKey: logsKey)
            error = nil
        } catch {
            self.error = .encodingFailed(error)
            print("❌ Error saving performance logs: \(error)")
        }
    }
    
    // MARK: - Future: Firebase Migration Helpers
    
    /// Preparar para migración a Firebase (exportar todos los logs)
    public func exportLogsForMigration() -> [GymActivityPerformance] {
        return performanceLogs
    }
    
    /// Importar logs desde Firebase (durante migración)
    public func importLogsFromFirebase(_ logs: [GymActivityPerformance]) {
        performanceLogs = logs
        persistLogs()
    }
    
    // MARK: - Debug Helpers
    
    public func printStats() {
        print("📊 Performance Stats:")
        print("   Total Sessions: \(totalCompletedSessions)")
        print("   Total Volume: \(String(format: "%.1f", totalVolumeLifted)) kg")
        print("   Total Calories: \(totalCaloriesBurned) kcal")
        print("   Total Training Time: \(totalTrainingMinutes) min")
        print("   Average RPE: \(String(format: "%.1f", averageRPE))/10")
    }
}

// MARK: - Supporting Types

public struct VolumeDataPoint: Identifiable {
    public let id = UUID()
    public let date: Date
    public let volume: Double
}

// MARK: - Errors

public enum PerformanceLogError: LocalizedError {
    case encodingFailed(Error)
    case decodingFailed(Error)
    case performanceNotFound
    case invalidData
    
    public var errorDescription: String? {
        switch self {
        case .encodingFailed(let error):
            return "Error al guardar: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Error al cargar: \(error.localizedDescription)"
        case .performanceNotFound:
            return "No se encontró el registro de performance"
        case .invalidData:
            return "Datos inválidos"
        }
    }
}

// MARK: - Convenience Extensions

extension PerformanceLogService {
    
    /// Helper para crear y guardar una sesión en un solo paso
    public func createAndSaveSession(
        planElementId: String? = nil,
        gymActivityId: String? = nil,
        userId: String? = nil
    ) -> GymActivityPerformance {
        let performance = startSession(
            planElementId: planElementId,
            gymActivityId: gymActivityId,
            userId: userId
        )
        
        savePerformance(performance)
        return performance
    }
    
    /// Helper para obtener la última sesión activa (útil si el usuario cierra y abre la app)
    public func getLastActiveSession() -> GymActivityPerformance? {
        return getActivePerformances()
            .sorted(by: { $0.startedAt > $1.startedAt })
            .first
    }
}
