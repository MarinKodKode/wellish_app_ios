//
//  GymActivityViewModel+Fetch.swift.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/05/26.
//

import SwiftUI


extension GymActivityViewModel {
 
    func fetchExerciseLibrary() async {
        do {
            exerciseLibrary = try await exerciseService
                .fetchExercises(byActivityType: "gym")
            print("✅ Ejercicios cargados: \(exerciseLibrary.count)")
        } catch {
            print("❌ Error cargando ejercicios: \(error.localizedDescription)")
            exerciseLibrary = []
        }
    }
 
    /// Ejercicios filtrados por categoria para el sheet de seleccion
    func exercises(for category: ExerciseCategory) -> [Exercise] {
        exerciseLibrary.filter { $0.category == category }
    }
 
    /// Ejercicios filtrados por busqueda de texto
    func searchExercises(query: String) -> [Exercise] {
        exerciseService.search(exerciseLibrary, query: query)
    }
 
    /// Categorias disponibles en la libreria cargada
    var availableCategories: [ExerciseCategory] {
        let categories = Set(exerciseLibrary.map { $0.category })
        return ExerciseCategory.allCases.filter { categories.contains($0) }
    }
}
 
