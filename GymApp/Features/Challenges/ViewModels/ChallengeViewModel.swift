//
//  ChallengeViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/11/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ChallengesViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var challenges: [BaseChallenge] = []
    @Published var history: [ChallengeHistoryEntry] = []
    @Published var isLoading: Bool = false
    @Published var showSuccessAnimation: Bool = false
    
    // MARK: - Private Properties
    
    private let userDefaults = UserDefaults.standard
    private let challengesKey = "userChallenges"
    private let historyKey = "challengeHistory"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    // MARK: - Init
    
    init() {
        setupEncoders()
        loadChallenges()
        loadHistory()
        checkAndResetDailyChallenges()
    }
    
    private func setupEncoders() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }
    
    // MARK: - Public Methods
    
    /// Cargar challenges desde UserDefaults
    func loadChallenges() {
        guard let data = userDefaults.data(forKey: challengesKey),
              let decoded = try? decoder.decode([BaseChallenge].self, from: data) else {
            // Si no hay challenges, crear los default
            createDefaultChallenges()
            return
        }
        
        challenges = decoded
    }
    
    /// Crear challenges por defecto
    func createDefaultChallenges() {
        challenges = [
            .stepsChallenge(),
            .waterChallenge(),
            .workoutStreakChallenge()
        ]
        saveChallenges()
    }
    
    /// Guardar challenges
    func saveChallenges() {
        guard let encoded = try? encoder.encode(challenges) else { return }
        userDefaults.set(encoded, forKey: challengesKey)
    }
    
    /// Actualizar un challenge específico
    func updateChallenge(_ challenge: BaseChallenge) {
        if let index = challenges.firstIndex(where: { $0.id == challenge.id }) {
            challenges[index] = challenge
            saveChallenges()
            
            // Si se completó, mostrar animación
            if challenge.isCompleted {
                showCompletionAnimation()
            }
        }
    }
    
    /// Incrementar valor de un challenge
    func incrementChallenge(_ challenge: BaseChallenge, by value: Int = 1) {
        var updatedChallenge = challenge
        updatedChallenge.increment(by: value)
        updateChallenge(updatedChallenge)
        
        // Guardar en historial
        saveToHistory(challenge: updatedChallenge)
    }
    
    /// Decrementar valor de un challenge
    func decrementChallenge(_ challenge: BaseChallenge, by value: Int = 1) {
        var updatedChallenge = challenge
        updatedChallenge.decrement(by: value)
        updateChallenge(updatedChallenge)
        
        // Actualizar historial
        saveToHistory(challenge: updatedChallenge)
    }
    
    /// Establecer valor específico
    func setChallenge(_ challenge: BaseChallenge, value: Int) {
        var updatedChallenge = challenge
        updatedChallenge.setValue(value)
        updateChallenge(updatedChallenge)
        
        // Guardar en historial
        saveToHistory(challenge: updatedChallenge)
    }
    
    /// Resetear un challenge
    func resetChallenge(_ challenge: BaseChallenge) {
        var updatedChallenge = challenge
        updatedChallenge.reset()
        updateChallenge(updatedChallenge)
    }
    
    /// Agregar un nuevo challenge
    func addChallenge(_ challenge: BaseChallenge) {
        challenges.append(challenge)
        saveChallenges()
    }
    
    /// Eliminar un challenge
    func deleteChallenge(_ challenge: BaseChallenge) {
        challenges.removeAll(where: { $0.id == challenge.id })
        saveChallenges()
    }
    
    // MARK: - History Management
    
    /// Cargar historial
    private func loadHistory() {
        guard let data = userDefaults.data(forKey: historyKey),
              let decoded = try? decoder.decode([ChallengeHistoryEntry].self, from: data) else {
            return
        }
        
        history = decoded
    }
    
    /// Guardar en historial
    private func saveToHistory(challenge: BaseChallenge) {
        let entry = ChallengeHistoryEntry(
            challengeId: challenge.id,
            date: Date(),
            value: challenge.currentValue,
            goalValue: challenge.goalValue,
            completed: challenge.isCompleted
        )
        
        // Remover entrada del mismo día si existe
        history.removeAll { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: Date()) &&
            entry.challengeId == challenge.id
        }
        
        history.append(entry)
        saveHistory()
    }
    
    /// Guardar historial
    private func saveHistory() {
        guard let encoded = try? encoder.encode(history) else { return }
        userDefaults.set(encoded, forKey: historyKey)
    }
    
    /// Obtener historial de un challenge
    func getHistory(for challenge: BaseChallenge, last days: Int = 7) -> [ChallengeHistoryEntry] {
        let calendar = Calendar.current
        let startDate = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        return history
            .filter { $0.challengeId == challenge.id && $0.date >= startDate }
            .sorted { $0.date < $1.date }
    }
    
    // MARK: - Reset Logic
    
    /// Verificar y resetear challenges diarios
    func checkAndResetDailyChallenges() {
        let calendar = Calendar.current
        let lastResetKey = "lastChallengeReset"
        
        if let lastReset = userDefaults.object(forKey: lastResetKey) as? Date {
            // Si es un nuevo día, resetear challenges diarios
            if !calendar.isDate(lastReset, inSameDayAs: Date()) {
                resetDailyChallenges()
                userDefaults.set(Date(), forKey: lastResetKey)
            }
        } else {
            userDefaults.set(Date(), forKey: lastResetKey)
        }
    }
    
    /// Resetear challenges diarios
    private func resetDailyChallenges() {
        for i in 0..<challenges.count {
            if challenges[i].period == .daily {
                challenges[i].reset()
            }
        }
        saveChallenges()
    }
    
    // MARK: - Statistics
    
    /// Total de challenges completados hoy
    var completedToday: Int {
        challenges.filter { $0.isCompleted }.count
    }
    
    /// Progreso promedio de todos los challenges
    var averageProgress: Double {
        guard !challenges.isEmpty else { return 0 }
        let total = challenges.reduce(0.0) { $0 + $1.progress }
        return total / Double(challenges.count)
    }
    
    /// Challenges activos (no completados)
    var activeChallenges: [BaseChallenge] {
        challenges.filter { !$0.isCompleted }
    }
    
    /// Challenges completados
    var completedChallenges: [BaseChallenge] {
        challenges.filter { $0.isCompleted }
    }
    
    /// Streak actual (días consecutivos con al menos un challenge completado)
    var currentStreak: Int {
        var streak = 0
        let calendar = Calendar.current
        var currentDate = Date()
        
        for _ in 0..<30 { // Máximo 30 días
            let dayHistory = history.filter { entry in
                calendar.isDate(entry.date, inSameDayAs: currentDate) && entry.completed
            }
            
            if dayHistory.isEmpty {
                break
            }
            
            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
        }
        
        return streak
    }
    
    // MARK: - Animations
    
    private func showCompletionAnimation() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            showSuccessAnimation = true
        }
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        // Ocultar después de 2 segundos
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.showSuccessAnimation = false
            }
        }
    }
    
    // MARK: - Debug
    
    func printStats() {
        print("📊 Challenges Stats:")
        print("   Total Challenges: \(challenges.count)")
        print("   Completed Today: \(completedToday)")
        print("   Average Progress: \(String(format: "%.1f", averageProgress * 100))%")
        print("   Current Streak: \(currentStreak) days")
    }
}
