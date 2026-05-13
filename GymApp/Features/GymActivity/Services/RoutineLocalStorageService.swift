

import Foundation

class RoutineLocalStorageService {
    
    private let fileManager = FileManager.default
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    //Route for saved routines
    private var routinesDirectory : URL {
        let documentsPath = fileManager.urls(for : .documentDirectory, in: .userDomainMask)[0]
        let routinesPath = documentsPath.appendingPathComponent("Routines", isDirectory : true)
        
        if !fileManager.fileExists(atPath: routinesPath.path){
            try? fileManager
                .createDirectory(at: routinesPath, withIntermediateDirectories: true)
        }
        
        return routinesPath
    }
    
    // Index files that contains IDs for all routines
    private var indexFileURL : URL {
        routinesDirectory.appendingPathComponent("routines_index.json")
    }
    
    init(){
        //Configure encoder / decoder for dates
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
        
        //Configure JSON for reading and debug
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        print("Routines directory - \(routinesDirectory.path)")
    }
    
    //MARK: - Create and update routines
    
    ///Save routines in a JSON file
    @MainActor
    func  ssaveRoutine(_ routine : GymActivity) async throws {
        
        let fileURL = routineFileURL(for : routine.id)
        
        do {
            let data = try encoder.encode(routine)
            try data.write(to: fileURL, options : .atomic)
            
            //Update index
            
            try await updateIndex(addingRoutineID : routine.id)
            
            print("Routine saved locally: \(routine.name) [\(routine.id)]")
            print("Location: \(fileURL.path)")
        }catch{
            print("Could not save routine locally: \(error.localizedDescription)")
            throw LocalStorageError.saveFailed(error)
        }
    }
    
    ///Save multiple routines at once
    @MainActor
    func saveRoutines(_ routines : [GymActivity]) async throws {
        for routine in routines {
//            try await saveRoutine(routine)
            print("\(routines.count) saved successfully.")
        }
        print("\(routines.count) saved successfully.")
    }
    
    //MARK: - Read routines methods
    
    ///Gets a routine given an specific ID
    func fetchRoutine(id : String) async throws -> GymActivity {
        let fileURL = routineFileURL(for: id)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw LocalStorageError.activityNotFound(id)
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let routine = try decoder.decode(GymActivity.self, from: data)
            print("Routine loaded : \(routine.name)")
            return routine
        }catch {
            print("Error reading routine")
            throw LocalStorageError.readFailed(error)
        }
    }
    
    /// Gets all routines saved locally
    @MainActor
    func fetchRoutines() async throws -> [GymActivity] {
        let routineIDs = try await loadIndex()
        var routines : [GymActivity] = []
        
        for id in routineIDs {
            do {
                let routine = try await fetchRoutine(id: id)
                routines.append(routine)
            }catch{
                print("Error fetching routine \(id), moving to next routine.")
            }
        }
        print("\(routines.count) routines loaded from local storage.")
        return routines
    }
    
    //MARK: - Delete routine
    
    ///Deletes a routine from local storage using its ID
    @MainActor
    func deleteRoutine(_ id : String) async throws {
        let fileURL = routineFileURL(for: id)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw LocalStorageError.activityNotFound(id)
        }
        
        do {
            try fileManager.removeItem(at: fileURL)
            
            try await updateIndex(removingRoutineID : id)
        }
    }
    
    
    //Delete all routines at once
    @MainActor
    func deleteAllRoutines() async throws {
        let routineIDs = try await loadIndex()
        
        for id in routineIDs {
            try? await deleteRoutine(id)
        }
        
        //Clean index
        try saveIndex([])
        print("All routines have been deleted.")
    }
    
    //MARK: - Queries
    
    ///Gets routines by category
    @MainActor
    func fetchRoutines(byCategory category : String) async throws -> [GymActivity]{
        let allRoutines = try await fetchRoutines()
        return allRoutines.filter{ $0.category?.rawValue == category }
    }
    
    ///Fetch routines by creatorID
    @MainActor
    func fetchRoutines(byCreator creatorID  : String ) async throws -> [GymActivity] {
        let allRoutines = try await fetchRoutines()
        return allRoutines.filter{ $0.creator == creatorID }
    }
    
    ///Fetch shareable routines
    @MainActor
    func fetchShareableRoutines() async throws -> [GymActivity] {
        let allRoutines = try await fetchRoutines()
        return allRoutines.filter{ $0.shareable == true }
    }
    
    @MainActor
    func searchRoutines(query : String) async throws -> [GymActivity] {
        let allRoutines = try await fetchRoutines()
        let lowercasedQuery = query.lowercased()
        
        return allRoutines.filter { routine in
            routine.name.lowercased().contains(lowercasedQuery) ||
            routine.description?.lowercased().contains(lowercasedQuery) == true ||
            routine.tags.contains{ $0.lowercased().contains(lowercasedQuery) }
        }
    }
    
    //MARK: - Utilities
    
    ///Verifies if there ir a routine locally
    func routineExists(id : String) -> Bool {
        let fileURL = routineFileURL(for: id)
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    func getStorageSize() throws -> Int64 {
        var totalSize : Int64 = 0
        
        let files = try fileManager.contentsOfDirectory(at : routinesDirectory, includingPropertiesForKeys: [.fileSizeKey])
        
        for file in files {
            let attributes = try fileManager.attributesOfItem(atPath: file.path)
            if let size = attributes[.size] as? Int64 {
                totalSize+=size
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
        func getStatistics() async throws -> LocalStorageStatistics {
            let routines = try await fetchRoutines()
            let storageSize = try getStorageSize()
            
            let totalExercises = routines.reduce(0) { $0 + $1.sets.count }
            let totalVolume = routines.reduce(0.0) { $0 + $1.estimatedVolumeKg }
            
            return LocalStorageStatistics(
                totalRoutines: routines.count,
                totalExercises: totalExercises,
                totalVolume: totalVolume,
                storageSize: storageSize,
                formattedSize: ByteCountFormatter.string(fromByteCount: storageSize, countStyle: .file)
            )
        }
    
    //MARK: - Index management
    
    ///Loads routines' ID index
    private func loadIndex() async throws -> [String] {
        guard fileManager.fileExists(atPath: indexFileURL.path) else {
            return []
        }
        
        do{
            let data = try Data(contentsOf: indexFileURL)
            let index = try decoder.decode([String].self, from: data)
            return index
            
        }catch{
            print("Error loading index")
            return []
        }
    }
    
    /// Saves routines' ID index
    private func saveIndex(_ ids : [String]) throws {
        let data = try encoder.encode(ids)
        try data.write(to: indexFileURL, options: .atomic)
    }
    
    /// Updates index adding the last routine ID
    private func updateIndex(addingRoutineID id : String) async throws {
        var ids = try await loadIndex()
        
        if !ids.contains(id){
            ids.append(id)
            try saveIndex(ids)
        }
    }
    
    /// Updates index removing an ID
    private func updateIndex(removingRoutineID id : String) async throws {
        var ids = try await loadIndex()
        ids.removeAll {$0 == id}
        try saveIndex(ids)
    }
    
    ///Rebuilds index scanning all files
    @MainActor
    private func rebuildIndex() async throws {
        let files = try fileManager.contentsOfDirectory(
            at: routinesDirectory,
            includingPropertiesForKeys : nil
        )
        
        let routineFiles = files.filter {
            $0.pathExtension == "json" &&
            $0.lastPathComponent != "routines_index.json"
        }
        
        var ids : [String] = []
        
        for file in routineFiles {
            let id = file.deletingPathExtension().lastPathComponent
            ids.append(id)
        }
        
        try saveIndex(ids)
        print("Index rebuilt")
    }
    
    //MARK: - Private helpers
    
    /// Generates file URL for specific routine
    private func routineFileURL(for id : String) -> URL {
        routinesDirectory.appendingPathComponent("\(id).json")
    }
}


struct LocalStorageStatistics {
    let totalRoutines : Int
    let totalExercises : Int
    let totalVolume : Double
    let storageSize : Int64
    let formattedSize : String
    
    var formattedVolume : String {
        String(format : "%.1f KG", totalVolume)
    }
}
