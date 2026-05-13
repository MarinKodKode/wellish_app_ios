// OnboardingService.swift
import SwiftUI
import Combine

final class OnboardingService: ObservableObject {
    @Published private(set) var shouldShowOnboarding: Bool
    
    private let repository: OnboardingRepositoryProtocol
    private let appVersion: String
    
    init(
        repository: OnboardingRepositoryProtocol = OnboardingRepository(),
        appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    ) {
        self.repository = repository
        self.appVersion = appVersion
        
        let state = repository.getOnboardingState()
        // Initialize shouldShowOnboarding first
        self.shouldShowOnboarding = !state.hasCompleted
        
        // Then check for version updates
        if let completedVersion = state.completedVersion {
            self.shouldShowOnboarding = self.shouldShowOnboarding || (completedVersion != appVersion)
        } else if state.hasCompleted {
            self.shouldShowOnboarding = true
        }
    }
    
    // MARK: - Public Methods
    
    func completeOnboarding() {
        repository.saveOnboardingCompleted()
        shouldShowOnboarding = false
    }
    
    func resetOnboarding() {
        repository.clearOnboardingState()
        shouldShowOnboarding = true
    }
    
    // MARK: - Private Methods
    
    private func shouldShowForNewVersion(_ state: OnboardingState) -> Bool {
        guard let completedVersion = state.completedVersion else { return true }
        return completedVersion != appVersion
    }
}
