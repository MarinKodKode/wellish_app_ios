//
//  UserProfileService.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/11/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    private let collection = "users"
    
    private init() {}
    
    // MARK: - Fetching
    
    func fetchCurrentUser() async -> UserProfile? {
        guard let uid = Auth.auth().currentUser?.uid else {
            return nil
        }
        let docRef = db.collection(collection).document(uid)
        do {
            let snapshot = try await docRef.getDocument()
            guard let profile = try? snapshot.data(as: UserProfile.self) else {
                return nil
            }
            return profile
        }catch{
            return nil
        }
    }
    
    // MARK: - Creation (Sign Up)
    
    /// Creates the initial database document for a new user
    func createInitialProfile(user: User, username: String) async throws {
        let uid = user.uid
        
        let newProfile = UserProfile(
            username: username,
            email: user.email ?? "",
            bio: nil,
            photoURL: nil,
            createdDate: currentDateTime(),
            lastActiveDate: Date(),
            fcmTokens: [],
            isPremium: false,
            onboardingCompleted: false,
            version: "1.0",
            physicalProfile: PhysicalProfile(gender: .preferNotToSay, birthDate: nil, height: 170, currentWeight: 70, bodyFatPercentage: nil),
            preferences: UserPreferences(unitSystem: .metric, workoutReminderTime: nil, allowNotifications: false, restTimerDuration: 60),
            goals: FitnessGoal(primaryGoal: .keepFit, targetWeight: nil, weeklyWorkoutDays: 3, experienceLevel: .beginner),
            stats: UserStats(routinesCompleted: 0, workoutsCompleted: 0, currentStreak: 0, highestStreak: 0, totalLiftedWeight: 0, totalWorkoutMinutes: 0)
        )
        
        try db.collection(collection).document(uid).setData(from: newProfile)
    }
    
    func updateProfileData(_ data: [String: Any]) async {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        do {
            try await db.collection(collection).document(uid).updateData(data)
        }catch{
            return
        }
        
    }
    
    func fetchUserData() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        
        let name = user.displayName ?? "Name not available"
        let email = user.email ?? "Not available email"
        let urlPhoto = user.photoURL
        
        if let url = urlPhoto {
            print("Profile picture - \(url)")
        }
        
    }
    
    func createOrVerifyUserDocument(user : FirebaseAuth.User) async throws {
        
        let uid = user.uid
        let userDocRef = db.collection("users").document(uid)
        
        do {
            let document = try await userDocRef.getDocument()
            
            if document.exists {
                print("User already logged.")
                return
            }
        } catch let error as NSError where error.code == FirestoreErrorCode.notFound.rawValue {
            print("Document not found. Creating user...")
        } catch {
            print("Error getting user docuemtn \(error.localizedDescription)")
            throw error
        }
        
        
        let initialname = user.displayName ?? "User"
        let initialEmail = user.email ?? ""
        let defaulImageProfile = ""
        
        let newUser = UserProfile(
            id : uid,
            username: initialname,
            email: initialEmail,
            photoURL : "d01bfa64-6c54-43d2-9d7f-c95c65e20421",
            createdDate: currentDateTime()
        )
        
        do {
            try userDocRef.setData(from : newUser) { error in
                if let error = error {
                    print("Error at creating user.")
                } else {
                    print("User created successfully.")
                }
            }
        } catch let error  {
            print("Error at creating user _ \(error)")
        }
    }
    
}
