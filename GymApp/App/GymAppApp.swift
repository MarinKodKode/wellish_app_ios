//
//  GymAppApp.swift
//  GymApp
//
//  Created by Manuel Alejandro Hernandez Marín on 18/07/25.
//

import SwiftUI
import FirebaseCore

@main
struct GymAppApp: App {
    
    @StateObject private var navigationRouter = NavigationRouter()
    @StateObject private var mainHomeView = MainHomeViewModel()
    let alertManager = AlertViewModel.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationRouter)
                .environmentObject(alertManager)
                .environmentObject(mainHomeView)
        }
    }
}
