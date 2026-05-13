//
//  OnBoardingRepository.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import Foundation


protocol OnboardingRepositoryProtocol {
    func getOnboardingState() -> OnboardingState
    func saveOnboardingCompleted()
    func clearOnboardingState()
}

final class OnboardingRepository: OnboardingRepositoryProtocol {
    private enum Keys {
        static let hasCompleted = "app.onboarding.completed"
        static let completedDate = "app.onboarding.date"
        static let completedVersion = "app.onboarding.version"
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func getOnboardingState() -> OnboardingState {
        return OnboardingState(
            hasCompleted: userDefaults.bool(forKey: Keys.hasCompleted),
            completedDate: userDefaults.object(forKey: Keys.completedDate) as? Date,
            completedVersion: userDefaults.string(forKey: Keys.completedVersion)
        )
    }
    
    func saveOnboardingCompleted() {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        
        userDefaults.set(true, forKey: Keys.hasCompleted)
        userDefaults.set(Date(), forKey: Keys.completedDate)
        userDefaults.set(currentVersion, forKey: Keys.completedVersion)
    }
    
    func clearOnboardingState() {
        userDefaults.removeObject(forKey: Keys.hasCompleted)
        userDefaults.removeObject(forKey: Keys.completedDate)
        userDefaults.removeObject(forKey: Keys.completedVersion)
    }
}
