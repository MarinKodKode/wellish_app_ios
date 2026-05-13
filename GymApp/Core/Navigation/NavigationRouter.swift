//
//  NavigationRouter.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/07/25.
//

import Foundation
import SwiftUI

/// A centralized navigation controller for SwiftUI navigation.
/// It replaces imperative NavigationLink usage and supports
/// clean, testable, scalable navigation across the entire app.
@MainActor
final class NavigationRouter: ObservableObject {
    
    /// Shared navigation path that drives the current navigation stack
    @Published var path = NavigationPath()
    
    /// Push a new route onto the navigation stack
    func push(_ route: AppRoute) {
        path.append(route)
    }
    
    /// Push a new route onto the navigation stack
    func goTo(_ route: AppRoute) {
        path.append(route)
    }
    
    /// Pop the last route off the navigation stack
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func goBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Clear all navigation and return to the root view
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Replace the current stack with a single route
    func setRoot(to route: AppRoute) {
        path = NavigationPath()
        path.append(route)
    }
    
    /// Handle deep links from external sources
    func handleDeepLink(_ url: URL) {
        // Add your logic here
        // Example: wellish://workout/UUID
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if let host = components?.host, host == "workout",
           let idString = components?.path.split(separator: "/").last,
           let _ = UUID(uuidString: String(idString)) {
            push(.workoutDetail)
        }
    }
}
