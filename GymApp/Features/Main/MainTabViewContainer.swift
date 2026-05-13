//
//  MainTabViewContainer.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI

struct MainTabViewContainer: View {
    
    @Binding var navigationPath : NavigationPath
    @State private var selectedTab = 0
    @State private var showWorkoutTimer = false
    @State private var showWorkoutTimer_true = true
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var vm = MainHomeViewModel()
    
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            MainHomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            MetricsView(showWorkoutTimer: $showWorkoutTimer)
                .tabItem {
                    Label("Activity", systemImage: "figure.walk")
                }
                .tag(1)

            PlansView(vm: GymActivityViewModel(), plansVM: PlansViewViewModel())
                .tabItem {
                    Label("Plans", systemImage: "clipboard")
                }
                .tag(2)

            ProfileView(showWorkoutTimer: $showWorkoutTimer_true)
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .environmentObject(vm)
        .accentColor(.blue)
    }
}


