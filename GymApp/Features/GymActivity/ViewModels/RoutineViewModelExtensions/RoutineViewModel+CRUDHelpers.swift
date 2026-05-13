//
//  GymActivityViewModel+CRUDHelpers.swift
//  Wellish
//

import Foundation

extension GymActivityViewModel {

    // MARK: - Validation

    public func validateGymActivity() -> (isValid: Bool, errors: [String]) {
        var errors: [String] = []

        if gymActivity.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("El nombre no puede estar vacío")
        }

        if gymActivity.sets.isEmpty {
            errors.append("Necesitas al menos un ejercicio")
        }

        for (index, set) in gymActivity.sets.enumerated() {
            if set.series.isEmpty {
                errors.append("El ejercicio \(index + 1) debe tener al menos una serie")
            }
        }

        return (errors.isEmpty, errors)
    }

    // MARK: - Prepare for Save

    public func prepareGymActivityForSave() {
        gymActivity.updatedAt = Date()

        // Calcular duración estimada si no está definida
        if gymActivity.estimatedDurationMinutes == nil {
            gymActivity.estimatedDurationMinutes = calculateEstimatedDuration()
        }

        // Inferir categoría del primer set si no está definida
        if gymActivity.category == nil {
            gymActivity.category = inferCategoryFromSets()
        }

        // Inferir músculos primarios y secundarios desde los ejercicios cargados
        if gymActivity.primaryMuscles.isEmpty {
            let resolved = resolvedExercises()
            gymActivity.primaryMuscles = inferPrimaryMuscles(from: resolved)
            gymActivity.secondaryMuscles = inferSecondaryMuscles(from: resolved)
        }

        // Asignar creator si está disponible
        // if gymActivity.creator == nil {
        //     gymActivity.creator = Auth.auth().currentUser?.uid
        // }
    }

    // MARK: - Set Management

    public func addSet(with exercise: Exercise) {
        let newSet = RoutineSet(exercise: exercise)
        gymActivity.sets.append(newSet)
        gymActivity.updatedAt = Date()
    }

    public func removeSet(at index: Int) {
        guard gymActivity.sets.indices.contains(index) else { return }
        gymActivity.sets.remove(at: index)
        gymActivity.updatedAt = Date()
    }

    // MARK: - Serie Management

    public func addSerie(toSetAt setIndex: Int) {
        guard gymActivity.sets.indices.contains(setIndex) else { return }
        gymActivity.sets[setIndex].series.append(Serie())
        gymActivity.updatedAt = Date()
    }

    public func removeSerie(at serieIndex: Int, inSet setIndex: Int) {
        guard gymActivity.sets.indices.contains(setIndex),
              gymActivity.sets[setIndex].series.indices.contains(serieIndex) else { return }
        gymActivity.sets[setIndex].series.remove(at: serieIndex)
        gymActivity.updatedAt = Date()
    }

    public func updateSerie(_ serie: Serie, at serieIndex: Int, inSet setIndex: Int) {
        guard gymActivity.sets.indices.contains(setIndex),
              gymActivity.sets[setIndex].series.indices.contains(serieIndex) else { return }
        gymActivity.sets[setIndex].series[serieIndex] = serie
        gymActivity.updatedAt = Date()
    }

    // MARK: - Computed State

    public var isValidName: Bool {
        !gymActivity.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var canSave: Bool {
        isValidName && !gymActivity.sets.isEmpty && !isSaving
    }

    // MARK: - Private Helpers

    /// Calcula la duracion estimada en minutos basada en series y descansos
//    internal func calculateEstimatedDuration() -> Int {
//        let totalSeries = gymActivity.sets.reduce(0) { $0 + $1.series.count }
//        let avgSecondsPerSerie = 45
//        let totalRestSeconds = gymActivity.sets.reduce(0) {
//            $0 + (($1.restBetweenSeriesSeconds ?? 60) * max($1.series.count - 1, 0))
//        }
//        let totalSeconds = (totalSeries * avgSecondsPerSerie) + totalRestSeconds
//        return max(totalSeconds / 60, 1)
//    }

    /// Infiere la categoria del primer ejercicio resuelto en la libreria
    private func inferCategoryFromSets() -> ExerciseCategory? {
        guard let firstSet = gymActivity.sets.first else { return nil }
        return exerciseLibrary
            .first { $0.id == firstSet.exerciseId }?
            .category
    }

    /// Resuelve los ejercicios completos desde la libreria en memoria
    /// usando los exerciseId de cada RoutineSet
    private func resolvedExercises() -> [Exercise] {
        gymActivity.sets.compactMap { set in
            exerciseLibrary.first { $0.id == set.exerciseId }
        }
    }

    /// Infiere los musculos primarios mas frecuentes entre los ejercicios resueltos
    private func inferPrimaryMuscles(from exercises: [Exercise]) -> [ExerciseMuscle] {
        let all = exercises.flatMap { $0.primaryMuscles }
        let counted = Dictionary(grouping: all, by: { $0 })
            .sorted { $0.value.count > $1.value.count }
            .map { $0.key }
        return Array(counted.prefix(3))
    }

    /// Infiere los musculos secundarios mas frecuentes entre los ejercicios resueltos
    private func inferSecondaryMuscles(from exercises: [Exercise]) -> [ExerciseMuscle] {
        let primary = Set(inferPrimaryMuscles(from: exercises))
        let all = exercises.flatMap { $0.secondaryMuscles }
            .filter { !primary.contains($0) }
        let counted = Dictionary(grouping: all, by: { $0 })
            .sorted { $0.value.count > $1.value.count }
            .map { $0.key }
        return Array(counted.prefix(3))
    }
}
