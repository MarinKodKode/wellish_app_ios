import Foundation
import Combine
import SwiftUI

@MainActor

public final class GymActivityViewModel : ObservableObject {
    
    @Published public var gymActivity : GymActivity
    
    //UI State
    @Published public var isSaving : Bool = false
    @Published public var isLoading : Bool = false
    @Published public var errorMessage : String?
    @Published var error : ErrorWrapper?
    @Published var savedRoutines : [GymActivity] = []
    @Published var exerciseLibrary : [Exercise] = []
    @Published var tagsInput : String = ""
    @Published var savedSuccess : Bool = false
    
    //Connection Status
    @Published public var isOnline : Bool = true
    @Published public var lastSyncDate : Date?
    
    let repository : RoutineRepositoryProtocol
    let firestoreService = RoutineFirestoreService()
    let localStorageService = RoutineLocalStorageService()
    let activityService = ActivityService()
    let service = RoutineService()
    let exerciseService = ExerciseFirebaseService()
    
    public init(
        gymActivity : GymActivity = GymActivity(
            name : StringConstants.routineNewRoutine
        ),
        repository : RoutineRepositoryProtocol = MockRoutineRepository()
    ){
        self.gymActivity = gymActivity
        self.repository = repository
    }
}
