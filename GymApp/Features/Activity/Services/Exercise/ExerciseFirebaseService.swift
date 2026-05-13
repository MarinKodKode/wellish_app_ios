//
//  ExerciseFirebaseService.swift
//  Wellish
//

import Foundation
import FirebaseFirestore

final class ExerciseFirebaseService {

    // MARK: - Properties

    private let db = Firestore.firestore()
    private let collection = "exercises"

    // MARK: - Create

    @MainActor
    func uploadExercise(_ exercise: Exercise) async throws -> String {
        let docRef = try db.collection(collection).addDocument(from: exercise)
        return docRef.documentID
    }

    @MainActor
    func uploadExerciseWithID(_ exercise: Exercise) async throws {
        try db.collection(collection)
            .document(exercise.id)
            .setData(from: exercise)
    }

    // MARK: - Read

    @MainActor
    func fetchExercises() async throws -> [Exercise] {
        let snapshot = try await db.collection(collection).getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: Exercise.self) }
    }

    @MainActor
    func fetchExercise(id: String) async throws -> Exercise {
        let document = try await db.collection(collection)
            .document(id)
            .getDocument()

        guard document.exists else {
            throw ExerciseServiceError.notFound(id)
        }

        return try document.data(as: Exercise.self)
    }

    // MARK: - Queries

    /// Fetch por activityType — primer nivel del sheet de selección
    @MainActor
    func fetchExercises(byActivityType activityType: String) async throws -> [Exercise] {
        let snapshot = try await db.collection(collection)
            .whereField("activityType", isEqualTo: activityType)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Exercise.self) }
    }

    /// Fetch por activityType + category — segundo nivel del sheet de selección
    /// Requiere índice compuesto en Firestore: activityType + category
    @MainActor
    func fetchExercises(byActivityType activityType: String, category: ExerciseCategory) async throws -> [Exercise] {
        let snapshot = try await db.collection(collection)
            .whereField("activityType", isEqualTo: activityType)
            .whereField("category", isEqualTo: category.rawValue)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Exercise.self) }
    }

    /// Fetch por category — mantiene compatibilidad con el flujo actual
    @MainActor
    func fetchExercises(byCategory category: ExerciseCategory) async throws -> [Exercise] {
        let snapshot = try await db.collection(collection)
            .whereField("category", isEqualTo: category.rawValue)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Exercise.self) }
    }

    /// Fetch por difficulty
    @MainActor
    func fetchExercises(byDifficulty difficulty: ExerciseDifficulty) async throws -> [Exercise] {
        let snapshot = try await db.collection(collection)
            .whereField("difficulty", isEqualTo: difficulty.rawValue)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Exercise.self) }
    }

    /// Fetch por activityType + difficulty — útil para planes segmentados por nivel
    @MainActor
    func fetchExercises(byActivityType activityType: String, difficulty: ExerciseDifficulty) async throws -> [Exercise] {
        let snapshot = try await db.collection(collection)
            .whereField("activityType", isEqualTo: activityType)
            .whereField("difficulty", isEqualTo: difficulty.rawValue)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Exercise.self) }
    }

    /// Fetch solo de base data global — para poblar plantillas de planes
    @MainActor
    func fetchGlobalExercises() async throws -> [Exercise] {
        let snapshot = try await db.collection(collection)
            .whereField("isGlobal", isEqualTo: true)
            .getDocuments()

        return snapshot.documents.compactMap { try? $0.data(as: Exercise.self) }
    }

    /// Búsqueda local por nombre dentro de un set ya cargado
    /// Usar sobre resultados ya fetched para evitar reads innecesarios
    func search(_ exercises: [Exercise], query: String) -> [Exercise] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return exercises }
        let lowercased = query.lowercased()
        return exercises.filter {
            $0.name.lowercased().contains(lowercased) ||
            $0.tags.contains { $0.lowercased().contains(lowercased) }
        }
    }

    // MARK: - Update

    @MainActor
    func updateExercise(_ exercise: Exercise) async throws {
        try db.collection(collection)
            .document(exercise.id)
            .setData(from: exercise, merge: true)
    }

    // MARK: - Delete

    func deleteExercise(id: String) async throws {
        try await db.collection(collection)
            .document(id)
            .delete()
    }
}

// MARK: - ExerciseServiceError

enum ExerciseServiceError: LocalizedError {
    case notFound(String)
    case invalidData

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "No se encontró el ejercicio con ID: \(id)"
        case .invalidData:
            return "Los datos del ejercicio son inválidos"
        }
    }
}
