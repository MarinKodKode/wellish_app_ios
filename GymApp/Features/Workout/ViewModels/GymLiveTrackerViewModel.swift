//
//  GymLiveTrackerViewModel.swift
//  Wellish
//
//  Integrado con PerformanceLogService para trackear sesiones
//

import Foundation
import ActivityKit
import UserNotifications
import UIKit
import Combine

class GymLiveTrackerViewModel: ObservableObject {
    
    static let shared = GymLiveTrackerViewModel()
    
    private let performanceService = PerformanceLogService.shared
    
    @Published var currentExerciseIndex = 0
    @Published var currentSet = 1
    @Published var isTimerRunning = false
    @Published var elapsedTime = 0
    @Published var restTimer = 10
    @Published var isResting = false
    @Published var showSetComplete = false
    @Published var showWorkoutComplete = false
    @Published var completedSets: [Int: [Int]] = [:]
    @Published var currentPlanElement: PlanElement?
    @Published var currentGymActivity: GymActivity?
    
    @Published var currentPerformance: GymActivityPerformance?
    @Published var currentPerformedSet: PerformedRoutineSet?
    @Published var currentSeriesInSet: [PerformedSeries] = []
    
    private var timer: Timer?
    private var restTimerInstance: Timer?
    private var currentActivity: Activity?
    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var cancellables = Set<AnyCancellable>()
    
    var totalSets: Int {
        guard let gymActivity = currentGymActivity else { return 0 }
        return gymActivity.sets.reduce(0) { $0 + $1.series.count }
    }
    
    var completedSetsCount: Int {
        completedSets.values.reduce(0) { $0 + $1.count }
    }
    
    var progress: Double {
        guard totalSets > 0 else { return 0 }
        return Double(completedSetsCount) / Double(totalSets)
    }
    
    var caloriesBurned: Int {
        elapsedTime / 60 * 8
    }
    
    var currentRoutineSet: RoutineSet? {
        guard let gymActivity = currentGymActivity,
              currentExerciseIndex < gymActivity.sets.count else { return nil }
        return gymActivity.sets[currentExerciseIndex]
    }
    
    private init() {
        requestNotificationPermissions()
        setupNotificationCategories()
        setupBackgroundHandling()
        restoreStateIfNeeded()
    }
    
    
    /// Inicia un nuevo workout con un PlanElement
    func startWorkout(with planElement: PlanElement) {
        guard case .gym(let gymActivity) = planElement.activity else {
            return
        }
        
        // Resetear estado
        reset()
        
        // Configurar workout
        self.currentPlanElement = planElement
        self.currentGymActivity = gymActivity
        self.currentExerciseIndex = 0
        self.currentSet = 1
        self.elapsedTime = 0
        
        // 🆕 CREAR PERFORMANCE LOG
        self.currentPerformance = performanceService.createAndSaveSession(
            planElementId: planElement.id,
            gymActivityId: gymActivity.id,
            userId: getCurrentUserId() // Tu método para obtener userId
        )
        
        // Inicializar el primer PerformedRoutineSet
        if let firstRoutineSet = gymActivity.sets.first {
            self.currentPerformedSet = PerformedRoutineSet(
                routineSetId: firstRoutineSet.id,
                name: firstRoutineSet.exerciseName
            )
        }
        
        // Iniciar timer
        startTimer()
        
        // Guardar estado en UserDefaults
        saveState()
        
        print("✅ Workout iniciado: \(gymActivity.name)")
        print("📊 Performance ID: \(currentPerformance?.id ?? "N/A")")
    }
    
    /// Inicia el timer principal
    private func startTimer() {
        isTimerRunning = true
        
        // Invalidar timer anterior si existe
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self, !self.isResting else { return }
            self.elapsedTime += 1
            self.saveState() // Guardar estado cada segundo
        }
        
        // Mantener timer corriendo en background
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func pauseWorkout() {
        isTimerRunning = false
        timer?.invalidate()
        restTimerInstance?.invalidate()
        
        if isResting {
            UNUserNotificationCenter
                .current()
                .removePendingNotificationRequests(withIdentifiers: ["restComplete"])
        }
        
        saveState()
    }
    
    func resumeWorkout() {
        guard currentGymActivity != nil else { return }
        startTimer()
    }
    
    func recordSeries(weightKg: Double, reps: Int, notes: String? = nil) {
        guard let routineSet = currentRoutineSet else { return }
        let series = PerformedSeries(
            exerciseId: routineSet.exerciseId,
            exerciseName: routineSet.exerciseName,
            weightKg: weightKg,
            reps: reps,
            completedAt: Date(),
            wasSuccessful: true,
            notes: notes
        )
        
        currentSeriesInSet.append(series)
        
        print(
            "✅ Serie registrada: \(routineSet.exerciseName) - \(weightKg)kg x \(reps) reps"
        )
    }
    
    func completeSet() {
        guard let currentSet = currentRoutineSet else { return }
        
        if var performedSet = currentPerformedSet {
            performedSet.completedSeries = currentSeriesInSet
            
            if var performance = currentPerformance {
                performanceService.addPerformedSet(to: &performance, set: performedSet)
                currentPerformance = performance
            }
        }
        
        var sets = completedSets[currentExerciseIndex] ?? []
        sets.append(self.currentSet)
        completedSets[currentExerciseIndex] = sets
        
        showSetComplete = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.showSetComplete = false
        }
        
        if self.currentSet < currentSet.series.count {
            self.currentSet += 1
            
            currentSeriesInSet = []
            
            if let restTime = currentSet.series.first?.formattedRestTime {
                startRestTimer(duration: Int(restTime) ?? 60)
            }
        } else {
            moveToNextExercise()
        }
        
        saveState()
    }
    
    private func moveToNextExercise() {
        guard let gymActivity = currentGymActivity else { return }
        
        if currentExerciseIndex < gymActivity.sets.count - 1 {
            currentExerciseIndex += 1
            currentSet = 1
            
            if let nextRoutineSet = gymActivity.sets[safe: currentExerciseIndex] {
                currentPerformedSet = PerformedRoutineSet(
                    routineSetId: nextRoutineSet.id,
                    name: nextRoutineSet.exerciseName
                )
                currentSeriesInSet = []
            }
            
            startRestTimer(duration: 60)
        } else {
            completeWorkout()
        }
    }
    
    func skipExercise() {
        guard let gymActivity = currentGymActivity,
              currentExerciseIndex < gymActivity.sets.count - 1 else { return }
        
        currentExerciseIndex += 1
        currentSet = 1
        isResting = false
        restTimer = 0
        restTimerInstance?.invalidate()
        
        if let nextRoutineSet = gymActivity.sets[safe: currentExerciseIndex] {
            currentPerformedSet = PerformedRoutineSet(
                routineSetId: nextRoutineSet.id,
                name: nextRoutineSet.exerciseName
            )
            currentSeriesInSet = []
        }
        
        UNUserNotificationCenter
            .current()
            .removeDeliveredNotifications(withIdentifiers: ["restComplete"])
        
        saveState()
    }
    
    private func completeWorkout() {
        isTimerRunning = false
        timer?.invalidate()
        restTimerInstance?.invalidate()
        showWorkoutComplete = true
        
        let durationMinutes = elapsedTime / 60
        let calories = caloriesBurned
        
        if var performance = currentPerformance {
            performanceService.completeSession(
                &performance,
                durationMinutes: durationMinutes,
                calories: calories,
                rpe: nil,
                notes: nil
            )
            
            if let gymActivity = currentGymActivity {
                performance.calculateComparisons(plannedActivity: gymActivity)
                performanceService.savePerformance(performance)
            }
        }
        
        if var planElement = currentPlanElement {
            planElement.markCompleted(
                durationMinutes: durationMinutes,
                calories: calories,
                performanceNotes: "Completado con \(completedSetsCount) sets"
            )
        }
        
        clearState()
    }
    
    func finishWorkoutWithFeedback(rpe: Int, notes: String?) {
        guard var performance = currentPerformance else { return }
        
        performance.rpe = rpe
        performance.notes = notes
        
        performanceService.savePerformance(performance)
        
        print("✅ Feedback guardado - RPE: \(rpe)/10")
        
        reset()
    }
    
    private func startRestTimer(duration: Int) {
        isResting = true
        restTimer = duration
        
        restTimerInstance?.invalidate()
        
        restTimerInstance = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.restTimer > 0 {
                self.restTimer -= 1
            } else {
                self.isResting = false
                self.restTimerInstance?.invalidate()
            }
        }
        
        scheduleRestCompleteNotification(duration: duration)
        
        RunLoop.current.add(restTimerInstance!, forMode: .common)
    }
    
    func skipRest() {
        isResting = false
        restTimer = 0
        restTimerInstance?.invalidate()
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: ["restComplete"])
    }
    
    // MARK: - State Persistence
    
    private func saveState() {
        let state: [String: Any] = [
            "currentExerciseIndex": currentExerciseIndex,
            "currentSet": currentSet,
            "isTimerRunning": isTimerRunning,
            "elapsedTime": elapsedTime,
            "restTimer": restTimer,
            "isResting": isResting,
            "completedSets": completedSets.count,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        UserDefaults.standard.set(state, forKey: "GymTrackerState")
        
        if let planElement = currentPlanElement,
           let data = try? JSONEncoder().encode(planElement) {
            UserDefaults.standard.set(data, forKey: "CurrentPlanElement")
        }
        
        // 🆕 GUARDAR PERFORMANCE ACTUAL
        if let performance = currentPerformance,
           let data = try? JSONEncoder().encode(performance) {
            UserDefaults.standard.set(data, forKey: "CurrentPerformance")
        }
    }
    
    private func restoreStateIfNeeded() {
        guard let state = UserDefaults.standard.dictionary(forKey: "GymTrackerState"),
              let timestamp = state["timestamp"] as? TimeInterval else { return }
        
        let elapsed = Date().timeIntervalSince1970 - timestamp
        guard elapsed < 3600 else {
            clearState()
            return
        }
        
        // Restaurar PlanElement
        if let data = UserDefaults.standard.data(forKey: "CurrentPlanElement"),
           let planElement = try? JSONDecoder().decode(PlanElement.self, from: data),
           case .gym(let gymActivity) = planElement.activity {
            
            self.currentPlanElement = planElement
            self.currentGymActivity = gymActivity
        }
        
        // 🆕 RESTAURAR PERFORMANCE
        if let data = UserDefaults.standard.data(forKey: "CurrentPerformance"),
           let performance = try? JSONDecoder().decode(GymActivityPerformance.self, from: data) {
            self.currentPerformance = performance
            print("✅ Performance restaurado: \(performance.id)")
        }
        
        // Restaurar estado
        currentExerciseIndex = state["currentExerciseIndex"] as? Int ?? 0
        currentSet = state["currentSet"] as? Int ?? 1
        elapsedTime = state["elapsedTime"] as? Int ?? 0
        restTimer = state["restTimer"] as? Int ?? 0
        isResting = state["isResting"] as? Bool ?? false
        completedSets = state["completedSets"] as? [Int: [Int]] ?? [:]
        
        if state["isTimerRunning"] as? Bool == true {
            // Ajustar tiempo transcurrido desde que se guardó
            elapsedTime += Int(elapsed)
            startTimer()
        }
        
        print("✅ Estado restaurado del workout anterior")
    }
    
    private func clearState() {
        UserDefaults.standard.removeObject(forKey: "GymTrackerState")
        UserDefaults.standard.removeObject(forKey: "CurrentPlanElement")
        UserDefaults.standard.removeObject(forKey: "CurrentPerformance")
    }
    
    func reset() {
        timer?.invalidate()
        restTimerInstance?.invalidate()
        
        currentExerciseIndex = 0
        currentSet = 1
        isTimerRunning = false
        elapsedTime = 0
        restTimer = 10
        isResting = false
        showSetComplete = false
        showWorkoutComplete = false
        completedSets = [:]
        currentPlanElement = nil
        currentGymActivity = nil
        
        // 🆕 RESETEAR PERFORMANCE
        currentPerformance = nil
        currentPerformedSet = nil
        currentSeriesInSet = []
        
        clearState()
    }
    
    // MARK: - Background Handling
    
    private func setupBackgroundHandling() {
        // Observer para cuando la app entra en background
        NotificationCenter.default.publisher(for: UIApplication.didEnterBackgroundNotification)
            .sink { [weak self] _ in
                self?.handleEnterBackground()
            }
            .store(in: &cancellables)
        
        // Observer para cuando la app vuelve a foreground
        NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)
            .sink { [weak self] _ in
                self?.handleEnterForeground()
            }
            .store(in: &cancellables)
    }
    
    private func handleEnterBackground() {
        saveState()
        
        // Solicitar tiempo extra para continuar corriendo en background
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        print("📱 App en background - estado guardado")
    }
    
    private func handleEnterForeground() {
        restoreStateIfNeeded()
        endBackgroundTask()
        
        print("📱 App en foreground - estado restaurado")
    }
    
    private func endBackgroundTask() {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    // MARK: - Notifications
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("✅ Notificaciones permitidas")
                } else if let error = error {
                    print("❌ Error en permisos de notificaciones: \(error)")
                }
            }
    }
    
    private func setupNotificationCategories() {
        let skipAction = UNNotificationAction(
            identifier: "SKIP_REST",
            title: "Saltar descanso",
            options: .foreground
        )
        
        let restCompleteCategory = UNNotificationCategory(
            identifier: "WORKOUT_REST_COMPLETE",
            actions: [skipAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        UNUserNotificationCenter
            .current()
            .setNotificationCategories([restCompleteCategory])
    }
    
    private func scheduleRestCompleteNotification(duration: Int) {
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: ["restComplete"])
        
        let content = UNMutableNotificationContent()
        content.title = "¡Descanso terminado!"
        content.body = "Es hora de continuar con el siguiente set 💪"
        content.sound = .default
        content.categoryIdentifier = "WORKOUT_REST_COMPLETE"
        
        if let currentSet = currentRoutineSet {
            content.userInfo = [
                "exercise": currentSet.exerciseName,
                "set": currentSet.id,
                "restComplete": true
            ]
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(duration),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "restComplete",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Error al programar notificación: \(error)")
            } else {
                print("✅ Notificación programada para \(duration)s")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func getCurrentUserId() -> String? {
        // Implementa según tu sistema de auth
        // Por ahora retorna un placeholder
        return "user_123"
    }
    
    // MARK: - Deinit
    
    deinit {
        timer?.invalidate()
        restTimerInstance?.invalidate()
        endBackgroundTask()
    }
}

// MARK: - Array Safe Subscript Extension

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
