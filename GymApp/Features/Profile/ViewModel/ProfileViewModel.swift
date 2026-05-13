//
//  ProfileViewModel.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/11/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    
    @Published var user: UserProfile?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var username = "Manuel Marin"
    @Published var email = "zayn.pradipta@example.com"
    @Published var bio = "Lifting weights & chasing progress 🏋️‍♂️"
    @Published var routinesCompleted = 42
    @Published var currentStreak = 14
    @Published var totalWorkoutTimeHours = 32
    
    //MARK: UI reactive variables
    
    @Published var displayAvatarPickerSheet : Bool = false
    @Published var profileIconColor = Color.blue
    @Published var selectedProfileIcon : String
    @Published var bio_description = "Lifting weights & chasing progress."
    @Published var user_tags : [String] = ["Fitness", "Strength", "Cardio"]
    @Published var showEditSheet : Bool = false
    @Published var showPhotoSheet : Bool = false

    
    private let alertVM = AlertViewModel.shared
    private let userService = UserService.shared
    private let sessionData = SessionDataManager.shared
    
    init() {
        selectedProfileIcon = sessionData.photoIdentifier
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
//            self.user = try await userService.fetchCurrentUserProfile()
        } catch {
            self.errorMessage = "Failed to load profile: \(error.localizedDescription)"
            print("Error loading Firebase data: \(error)")
        }
        
        self.isLoading = false
    }
    
    func signOut() {
        do {
//            try userService.signOut()
            // Here you would typically update an AppState or Router to switch to the Login Screen
        } catch {
            self.errorMessage = "Error signing out."
        }
    }
    
    
    func onTap_CloseSession(){
        alertVM.showWarningAlert(
                alertType: .confirmLogout,
                alertMessage: StringConstants.warningLoginOut,
                action: {
                    Task {
                        try await AuthenticationService().signOut()
                    }
                })
    }
    
    func updateProfilePicture(picture : String) {
        selectedProfileIcon = picture
        sessionData.photoIdentifier = selectedProfileIcon
        
    }
    
    // MARK: - Computed Helpers for UI
    // These prevent logic from cluttering the View
    
    var usernameDisplay: String {
        user?.username ?? "Guest User"
    }
    
    var bioDisplay: String {
        user?.bio ?? "Ready to start the journey!"
    }
    
    var emailDisplay: String {
        user?.email ?? ""
    }
    
    var routinesCount: String {
        "\(user?.stats?.routinesCompleted ?? 0)"
    }
    
    var streakCount: String {
        "\(user?.stats?.currentStreak ?? 0)d"
    }
    
    var hoursCount: String {
        "\(user?.stats?.formattedHours ?? 0)h"
    }
}
