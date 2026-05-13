//
//  RoutineFirestoreService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/10/25.
//

import Foundation
import FirebaseFirestore


class RoutineFirestoreService {
    
    
    //MARK: - Properties
    private let db = Firestore.firestore()
    private let routinesCollection = "routines"
    
    //MARK: - CREATE (routine)
    /// Sube una nueva rutina a Firestore (genera un ID automático)
    /// - Parameters:
    ///   - routine: La rutina a subir
    ///   - completion: Closure que retorna el ID del documento o un error
    
    func uploadRoutine(_ routine : GymActivity, completion: @escaping(Result<String, Error>) -> Void){
        do {
            //Firestore handles automatically conversation of Codable and JSON
            let docRef = try db.collection(routinesCollection).addDocument(from : routine)
            
            completion(.success(docRef.documentID))
            print("Routine uploaded succesfully")
            
        }catch {
            completion(.failure(error))
            print(
                "Something went wrong, check localized description: \(error.localizedDescription)"
            )
        }
    }
    
    
    /// Sube una rutina con un ID específico (útil si quieres mantener el ID del modelo)
    /// - Parameters:
    ///   - routine: La rutina a subir
    ///   - completion: Closure que indica éxito o error
    
    func uploadRoutineWithID(_ routine : GymActivity, completion : @escaping(Result<Void, Error>) -> Void){
        do{
            try db.collection(routinesCollection)
                .document(routine.id)
                .setData(from: routine)
            
            completion(.success(()))
            print("Routine uploaded succesfully")
        }catch{
            completion(.failure(error))
            print("Something went wrong: \(error.localizedDescription) ")
        }
    }
    
    // MARK: - Read (Leer rutinas)
    
    /// Obtiene todas las rutina
    
    func fetchRoutine(completion : @escaping(Result<[GymActivity], Error>) -> Void){
        db.collection(routinesCollection)
            .getDocuments{ snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let routines = documents.compactMap { doc -> GymActivity? in
                    try? doc.data(as: GymActivity.self)
                }
                
                completion(.success(routines))
            }
    }
    
    func fetchRoutine(id: String, completion : @escaping(Result<GymActivity, Error>) -> Void){
        db.collection(routinesCollection)
            .document(id)
            .getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let document = document, document.exists else {
                    let notFoundError = NSError(
                        domain: "",
                        code: 404,
                        userInfo: [NSLocalizedDescriptionKey : "Not founded routine"]
                    )
                    completion(.failure(notFoundError))
                    return
                }
                
                do {
                    let routine = try document.data(as: GymActivity.self)
                    completion(.success(routine))
                }catch{
                    completion(.failure(error))
                }
            }
    }
    
    
    // MARK: - Update (Actualizar rutina)
    
    /// Actualiza una rutina existente

    func updateRoutine(_ routine : GymActivity, completion : @escaping (Result<Void, Error>) -> Void){
        
        var updateRoutine = routine
        updateRoutine.updatedAt = Date()
        
        do {
            try db.collection(routinesCollection)
                .document(routine.id)
                .setData(from: updateRoutine, merge: true)
            
            completion(.success(()))
            print("Updated routine successfully")
        }catch{
            completion(.failure(error))
            print("Something went wrong: - \(error.localizedDescription)")
        }
    }
    
    // MARK: - Delete (Eliminar rutina)
    
    func deleteRoutine(id: String, completion : @escaping(Result<Void, Error>)-> Void){
        db.collection(routinesCollection)
            .document(id)
            .delete { error in
                if let error = error {
                    completion(.failure(error))
                    print("Could not delete routine")
                }else{
                    completion(.success(()))
                    print("Routine deleted successfully")
                }
            }
    }
    
    // MARK: - Specific Queries
    
    func fetchRoutines(byCategory category : String, completion: @escaping(Result<[GymActivity], Error>) -> Void){
        db.collection(routinesCollection)
            .whereField("category", isEqualTo: category)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let routines = snapshot?.documents.compactMap { doc -> GymActivity? in
                    try? doc.data(as: GymActivity.self)
                } ?? []
                
                completion(.success(routines))
            }
    }
    
    ///Fetch user routines
    
    func fetchRoutines(byCreator creatorID : String, completion: @escaping(Result<[GymActivity], Error>) -> Void){
        db.collection(routinesCollection)
            .whereField("creator", isEqualTo: creatorID)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let routines = snapshot?.documents.compactMap{ doc -> GymActivity? in
                    try? doc.data(as : GymActivity.self)
                } ?? []
                completion(.success(routines))
            }
    }
    
    /// Obtiene rutinas compartibles (shareable = true)
    
    func fetchShareableRoutines(completion : @escaping(Result<[GymActivity], Error>) -> Void ){
        db.collection(routinesCollection)
            .whereField("shareable", isEqualTo: true)
            .getDocuments{ snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                let routines = snapshot?.documents.compactMap { doc -> GymActivity? in
                    try? doc.data(as : GymActivity.self)
                } ?? []
                completion(.success(routines))
            }
    }
}

// MARK: - Async/Await versions (Swift Concurrency)

extension RoutineFirestoreService {
    
    @MainActor
    func uploadRoutine(_ routine : GymActivity) async throws -> String {
        let docRef = try db.collection(routinesCollection).addDocument(from : routine)
        print("Routine uploaded successfully with ID: \(docRef.documentID)")
        return docRef.documentID
    }
    
    @MainActor
    func uploadRoutinesWithID(_ routine : GymActivity) async throws {
        try db.collection(routinesCollection)
            .document(routine.id)
            .setData(from: routine)
        print("Routine uploaded successfully")
    }
    
    @MainActor
    func fetchRoutines() async throws -> [GymActivity] {
        
        let snapshot = try await db.collection(routinesCollection).getDocuments()
        
        let routines = snapshot.documents.compactMap{ doc -> GymActivity? in
            try? doc.data(as: GymActivity.self)
        }
        print("Fetched routines: \(routines)")
        return routines
    }
    
    @MainActor
    func fetchRoutine(id: String) async throws -> GymActivity {
        let document = try await db.collection(routinesCollection)
            .document(id)
            .getDocument()
        
        guard document.exists else {
            throw NSError(
                domain: "",
                code: 404,
                userInfo : [NSLocalizedDescriptionKey : "Routine not found"]
                )
        }
        
        let routine = try document.data(as : GymActivity.self)
        print("Routine fetched  - \(routine.name)")
        return routine
    }
    
    //MARK: - Updating routines async/await methods
    
    @MainActor
    func updateRoutine(_ routine : GymActivity) async throws {
        var updatedRoutine = routine
        updatedRoutine.updatedAt = Date()
        
        try db.collection(routinesCollection)
            .document(routine.id)
            .setData(from : updatedRoutine, merge: true)
        
        print("Routine updated successfully")
    }
    
    //MARK: - Delete routine async await methods
    
    @MainActor
    func deleteRoutine(id: String) async throws {
        try await db.collection(routinesCollection)
            .document(id)
            .delete()
        print("Routine deleted successfully")
    }
    
    // Obtiene rutinas por categoría usando async/await

    @MainActor
    func fetchRoutines(byCategory category : String) async throws -> [GymActivity] {
        let snapshot = try await db.collection(routinesCollection)
            .whereField("caterogy", isEqualTo: category)
            .getDocuments()
        
        return snapshot.documents.compactMap{doc -> GymActivity? in
            try? doc.data(as: GymActivity.self)
        }
    }
    
    @MainActor
    func fetchRoutines(byCreator creatorID : String) async throws -> [GymActivity]{
        let snapshot = try await db.collection(routinesCollection)
            .whereField("creator", isEqualTo: creatorID)
            .getDocuments()
        
        return snapshot.documents.compactMap{doc -> GymActivity? in
            try? doc.data(as: GymActivity.self)
        }
    }
    
    @MainActor
    func fetchShareableRoutines() async throws -> [GymActivity]{
        let snapshot = try await db.collection(routinesCollection)
            .whereField("shareable", isEqualTo: true)
            .getDocuments()
        
        return snapshot.documents.compactMap{ doc -> GymActivity? in
            try? doc.data(as: GymActivity.self)
        }
    }
    
    
    //Realtime listener for changes in routines
    @MainActor
    func listenRoutines(completion : @escaping(Result<[GymActivity], Error>) -> Void) -> ListenerRegistration{
        
        return db.collection(routinesCollection)
            .addSnapshotListener{snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                let routines = snapshot?.documents.compactMap{ doc -> GymActivity? in
                    try? doc.data(as : GymActivity.self)
                } ?? []
                
                completion(.success(routines))
                print("Routines Updated Successfully - \(routines.count)")
            }
    }
}
