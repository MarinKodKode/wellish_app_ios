//
//  PlanLocalStorageService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import Foundation

final class PlanLocalStorageService {
    
    private let fileManager = FileManager.default
    
    private let encoder = JSONEncoder()
    
    private let decoder = JSONDecoder()
    
    private var plansDirectory : URL {
        
        let documentsPath = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        
        let plansPath = documentsPath.appendingPathComponent(
            "Plans",
            isDirectory: true
        )
        
        if !fileManager.fileExists(atPath: plansPath.path){
            try? fileManager
                .createDirectory(
                    at: plansPath,
                    withIntermediateDirectories: true
                )
        }
        
        return plansPath
    }
    
    private var indexFileURL : URL {
        plansDirectory.appendingPathExtension("plans_index.json")
    }
    
    
    init(){
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
    }
    
    //MARK: - Create and update plans
    
    @MainActor
    func savePlan(_ plan : Plan) async throws {
        
        let fileURL = planFileURL(for: plan.id)
        
        do {
            let data = try encoder.encode(plan)
            try data.write(to: fileURL, options: .atomic)
            
            try await updateIndex(addingPlanID: plan.id)
        }catch{
            throw LocalStorageError.saveFailed(error)
        }
    }
    
    @MainActor
    func savePlans(_ plans : [Plan]) async throws {
        for plan in plans {
            try await savePlan(plan)
        }
    }
    
    /**
     Actualiza un Plan existente en el almacenamiento local.
     
     Reutiliza la lógica de `savePlan` ya que sobrescribe el archivo JSON
     existente y asegura que el ID del plan esté en el índice.
     
     - Parameter updatedPlan: La instancia de Plan con los datos actualizados.
     */
    
    @MainActor
    func updatePlan(_ updatedPlan: Plan) async throws {
        try await savePlan(updatedPlan)
    }
    
    
    //MARK: - Fetch plans
    
    func fetchPlan(id : String) async throws -> Plan {
        
        let fileURL = planFileURL(for: id)
        
        guard fileManager.fileExists(atPath: fileURL.path) else{
            throw LocalStorageError.planNotFound(id)
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let plan = try decoder.decode(Plan.self, from: data)
            return plan
        }catch{
            throw LocalStorageError.readFailed(error)
        }
        
    }
    
    func fetchPlans() async throws -> [Plan] {
        
        let plansIDs = try await loadIndex()
        
        var plans : [Plan] = []
        
        for id in plansIDs {
            do {
                let plan = try await fetchPlan(id: id)
                plans.append(plan)
            }catch{
                print("Error fetching plan with ID : \(id)")
            }
        }
        return plans
    }
    
    
    //MARK: - Private Helpers
    
    private func planFileURL(for id : String) -> URL {
        plansDirectory.appendingPathComponent("\(id).json")
    }
    
    //MARK: - Index Management
    
    private func updateIndex(addingPlanID id : String) async throws {
        var ids = try await loadIndex()
        
        if !ids.contains(id){
            ids.append(id)
            try saveIndex(ids)
        }
    }
    
    private func loadIndex() async throws -> [String] {
        
        guard fileManager.fileExists(atPath: indexFileURL.path) else {
            return []
        }
        
        do {
            let data = try Data(contentsOf: indexFileURL)
            let index = try decoder.decode([String].self, from: data)
            return index
        }catch{
            return[]
        }
    }
    
    private func saveIndex(_ ids : [String]) throws {
        let data = try encoder.encode(ids)
        try data.write(to: indexFileURL, options: .atomic)
    }
    
    @MainActor
    private func rebuildIndex() async throws {
        
        let files = try fileManager.contentsOfDirectory(
            at : plansDirectory,
            includingPropertiesForKeys: nil
        )
        
        let planFiles = files.filter{
            $0.pathExtension == "json" &&
            $0.lastPathComponent != "plans_index.json"
        }
        
        var ids : [String] = []
        
        for file in planFiles {
            let id = file.deletingPathExtension().lastPathComponent
            ids.append(id)
        }
        
        try saveIndex(ids)
    }
    
    private func updateIndex(removingPlanID id : String) async throws {
        var ids = try await loadIndex()
        ids.removeAll{$0 == id}
        try saveIndex(ids)
    }
    
    @MainActor
    func deleteAllPlans() async throws {
        let planIDs = try await loadIndex()
        for id in planIDs {
            let fileURL = planFileURL(for: id)
            try? fileManager.removeItem(at: fileURL)
        }
        try saveIndex([])
        print("✅ All plans deleted from local storage")
    }
}
