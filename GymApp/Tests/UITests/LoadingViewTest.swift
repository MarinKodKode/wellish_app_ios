//
//  LoadingViewtest.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import Foundation
import SwiftUI

struct LoadingTestView: View {
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                
                VStack(spacing: 20) {
                    Button("Test Loading (2 seconds)") {
                        simulateLoading()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
                    Button("Test Custom Animation") {
                        simulateLoadingWithCustomText()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                    
                    Button("Test Simple ProgressView") {
                        simulateLoadingWithSimpleProgress()
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Loading Demo")
        }
        .showLoadingView(isLoading: isLoading)
    }
    
    private func simulateLoading() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
    
    private func simulateLoadingWithCustomText() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
    
    private func simulateLoadingWithSimpleProgress() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }
}

// MARK: - Preview
struct LoadingTestView_Previews: PreviewProvider {
    static var previews: some View {
        MainHomeViewTest()
            .preferredColorScheme(.dark)
    }
}


// MARK: - Main Home View
struct MainHomeViewTest: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerView
                        
                        // Challenge Card
                        challengeCardView
                        
                        // Today Workouts
                        todayWorkoutsView
                        
                        // Try Something New
                        trySomethingNewView
                        
                        // Categories (Popular Exercises)
                        categoriesView
                        
                        // Popular Workouts (Our Collection)
                        popularWorkoutsView
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
        HStack {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=100&h=100&fit=crop&crop=faces")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Welcome Back")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.gray)
                    Text("Alina")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        }
        .padding(.top, 10)
    }
    
    private var challengeCardView: some View {
        VStack(spacing: 12) {
            TabView {
                // Challenge 1 - Steps Challenge
                challengeCard(
                    title: "Step Into Fitness!",
                    subtitle: "Daily Steps Challenge",
                    mainNumber: "10,000",
                    unit: "Steps",
                    progress: 0.65,
                    progressText: "6,500 / 10,000",
                    buttonText: "Continue Walking",
                    colors: [Color(red: 1.0, green: 0.4, blue: 0.4), Color(red: 1.0, green: 0.2, blue: 0.6)], // Vibrant coral to hot pink
                    imageUrl: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=200&fit=crop&crop=faces",
                    icon: "figure.walk"
                )
                
                // Challenge 2 - Water Challenge
                challengeCard(
                    title: "Hydration Hero",
                    subtitle: "Daily Water Challenge",
                    mainNumber: "8",
                    unit: "Glasses",
                    progress: 0.375,
                    progressText: "3 / 8 glasses",
                    buttonText: "Log Water",
                    colors: [Color(red: 0.2, green: 0.7, blue: 1.0), Color(red: 0.0, green: 0.5, blue: 0.8)], // Bright blue gradient
                    imageUrl: "https://images.unsplash.com/photo-1559827260-dc66d52bef19?w=200&h=200&fit=crop",
                    icon: "drop.fill"
                )
                
                // Challenge 3 - Workout Streak
                challengeCard(
                    title: "Streak Master",
                    subtitle: "7-Day Workout Streak",
                    mainNumber: "5",
                    unit: "Days",
                    progress: 0.714,
                    progressText: "5 / 7 days",
                    buttonText: "Keep Going",
                    colors: [Color(red: 0.9, green: 0.5, blue: 0.1), Color(red: 1.0, green: 0.8, blue: 0.0)], // Orange to golden yellow
                    imageUrl: "https://images.unsplash.com/photo-1534258936925-c58bed479fcb?w=200&h=200&fit=crop",
                    icon: "flame.fill"
                )
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 170)
            
            // Custom dots indicator
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(index == 0 ? Color.white : Color.white.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .animation(.easeInOut, value: index)
                }
            }
        }
    }
    
    private func challengeCard(
        title: String,
        subtitle: String,
        mainNumber: String,
        unit: String,
        progress: Double,
        progressText: String,
        buttonText: String,
        colors: [Color],
        imageUrl: String,
        icon: String
    ) -> some View {
        ZStack {
            // Main gradient background
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: colors),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Decorative circles
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 60, height: 60)
                        .offset(x: 20, y: -20)
                }
                Spacer()
                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 40, height: 40)
                        .offset(x: -10, y: 15)
                    Spacer()
                }
            }
            
            HStack(spacing: 16) {
                // Left content
                VStack(alignment: .leading, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Image(systemName: icon)
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .medium))
                            Text(subtitle)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.9))
                        }
                        
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    // Main number and progress
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .bottom, spacing: 6) {
                            Text(mainNumber)
                                .font(.system(size: 36, weight: .heavy))
                                .foregroundColor(.white)
                            Text(unit)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.bottom, 6)
                        }
                        
                        // Progress bar
                        VStack(alignment: .leading, spacing: 4) {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 6)
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.white)
                                    .frame(width: 120 * progress, height: 6)
                            }
                            .frame(width: 120)
                            
                            Text(progressText)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        HStack(spacing: 6) {
                            Text(buttonText)
                                .font(.system(size: 13, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(.black)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                }
                
                Spacer()
                
                // Right image with overlay
                ZStack {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                    }
                    .frame(width: 90, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    // Subtle overlay gradient
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.1)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 90, height: 120)
                }
            }
            .padding(20)
        }
        .frame(height: 170)
    }
    
    // MARK: - Today Workouts
    private var todayWorkoutsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Today Workouts")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                
                Text("(17)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.fitnessTextSecondary)
                
                Spacer()
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primaryFitnessBlue, Color.primaryFitnessBlue.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                HStack(spacing: 0) {
                    // Left content - 2/3 of the card
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 16) {
                            HStack(spacing: 4) {
                                Image(systemName: "clock")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                Text("90min")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            
                            HStack(spacing: 4) {
                                Image(systemName: "flame")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                Text("1,200kcal")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Text("Upper Body\nWorkout")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    
                    // Right image - 1/3 of the card, full height
                    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=150&h=150&fit=crop&crop=faces")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.25) // 1/3 of card width
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 0,
                            bottomTrailingRadius: 20,
                            topTrailingRadius: 20
                        )
                    )
                }
            }
            .frame(height: 150)
        }
    }
    
    // MARK: - Try Something New
    private var trySomethingNewView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Try Something New")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                
                Spacer()
                
                Button(action: {}) {
                    Text("See more")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.fitnessSuccess)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.fitnessSuccess)
                }
            }
            
            VStack(spacing: 12) {
                // Yoga Class
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.premiumFitnessPurple, Color.premiumFitnessPurple.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                Text("5.0")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.errorFitnessRed)
                                    .cornerRadius(12)
                            }
                            
                            Text("Yoga Class")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("06:00 am – 8:00 am")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 8) {
                                Text("Large hall")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(16)
                                
                                Text("Beginner")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(16)
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 40, height: 40)
                                    .background(Color.errorFitnessRed)
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                        
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1506629905607-21d00c92e5bb?w=120&h=100&fit=crop")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                    }
                    .padding(16)
                }
                .frame(height: 120)
                
                // Cardio
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.infoFitnessCyan, Color.infoFitnessCyan.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12))
                                Text("4.7")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.errorFitnessRed)
                                    .cornerRadius(12)
                            }
                            
                            Text("Cardio")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("09:00 am – 09:45 am")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            
                            HStack(spacing: 8) {
                                Text("Central hall")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(16)
                                
                                Text("Beginner")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(16)
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            Button(action: {}) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(width: 40, height: 40)
                                    .background(Color.errorFitnessRed)
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                        
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=120&h=100&fit=crop")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                    }
                    .padding(16)
                }
                .frame(height: 120)
            }
        }
    }
    
    // MARK: - Categories (Popular Exercises)
    private var categoriesView: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Categories")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                
                Spacer()
                
                Button(action: {}) {
                    Text("See more")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.fitnessSuccess)
                    Image(systemName: "arrow.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.fitnessSuccess)
                }
            }
            
            HStack(spacing: 12) {
                // Home Workout
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.energyFitnessOrange, Color.energyFitnessOrange.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Home\nWorkout")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                        
                        Text("12 Exercise")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "plus")
                                .foregroundColor(.black)
                                .font(.system(size: 10, weight: .bold))
                                .frame(width: 20, height: 20)
                                .background(Color.fitnessSuccess)
                                .clipShape(Circle())
                            
                            Text("4.9")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }
                    .padding(16)
                    
                    // Add woman silhouette
                    VStack {
                        HStack {
                            Spacer()
                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=80&h=120&fit=crop&crop=faces")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.clear)
                            }
                            .frame(width: 60, height: 90)
                            .cornerRadius(8)
                        }
                        Spacer()
                    }
                    .padding(8)
                }
                .frame(width: 160, height: 140)
                
                // Hand Exercise
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.fitnessBackgroundSecondary)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Hand\nExercise")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.fitnessTextPrimary)
                            .multilineTextAlignment(.leading)
                        
                        Text("12 Exercise")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.fitnessSuccess)
                                .font(.system(size: 10))
                            
                            Text("4.9")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.fitnessTextPrimary)
                            
                            Spacer()
                        }
                    }
                    .padding(16)
                    
                    // Add person silhouette
                    VStack {
                        HStack {
                            Spacer()
                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=80&h=120&fit=crop&crop=faces")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.clear)
                            }
                            .frame(width: 60, height: 90)
                            .cornerRadius(8)
                        }
                        Spacer()
                    }
                    .padding(8)
                }
                .frame(width: 160, height: 140)
            }
        }
//    } {
//                                Rectangle()
//                                    .fill(Color.clear)
//                            }
//                            .frame(width: 60, height: 90)
//                            .cornerRadius(8)
//                        }
//                        Spacer()
//                    }
//                    .padding(8)
//                }
//                .frame(width: 160, height: 140)
//            }
//        }
    }
    
    // MARK: - Popular Workouts (Our Collection)
    private var popularWorkoutsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Popular Workouts")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.fitnessTextPrimary)
            
            VStack(spacing: 12) {
                // Chest & abdominal exercises
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.energyFitnessOrange, Color.energyFitnessOrange.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Chest & abdominal\nexercises")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "dumbbell")
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.system(size: 12))
                                Text("12 Exercise")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=100&h=100&fit=crop&crop=faces")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                    }
                    .padding(16)
                }
                .frame(height: 100)
                
                // Back & shoulder exercises
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.premiumFitnessPurple, Color.premiumFitnessPurple.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Back & shoulder\nexercises")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.leading)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "dumbbell")
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.system(size: 12))
                                Text("12 Exercise")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        
                        Spacer()
                        
                        AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=100&h=100&fit=crop&crop=faces")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                    }
                    .padding(16)
                }
                .frame(height: 100)
            }
        }
    }
}

#Preview {
    MainHomeViewTest()
}


//MARK: - Routine Creator
public struct RoutineCreatorTestView: View {
    @ObservedObject var vm: GymActivityViewModel

    // Small local UI state
    @State private var showingExercisePicker = false
    @State private var selectedSetIndex: Int? = nil
    @State private var newTagText: String = ""
    @State private var showRoutineCreator: Bool = false

    public init(viewModel: GymActivityViewModel) {
        _vm = ObservedObject(wrappedValue: viewModel)
    }

    public var body: some View {
        NavigationView {
            ZStack {
                // ✅ Adaptive background (light/dark)
                Color(.systemBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        sectionView(title: "Routine") {
                            VStack(spacing: 16) {
                                TextField("Routine name", text: $vm.gymActivity.name)
                                    .inputFieldStyle()

                                TextField("Description (optional)", text:.constant(
                                    "Some logical description"))
                            }
                        }

                        sectionView(title: "Exercises & Sets") {
                            if vm.gymActivity.sets.isEmpty {
                                Text("No sets yet. Add an exercise to begin.")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                            }

                            VStack(spacing: 12) {
                                ForEach(Array(vm.gymActivity.sets.enumerated()), id: \.element.id) { index, _ in
                                    RoutineSetRowView(
                                        set: $vm.gymActivity.sets[index],
                                        onAddSerie: { vm.addSerie(toSetAt: index) },
                                        onRemove: { vm.removeSet(at: index) },
                                        onEditSeria: { serieIndex, serie in
                                            vm.updateSerie(serie, at: serieIndex, inSet: index)
                                        }
                                    )
                                }
                            }

                            Button(action: { showingExercisePicker = true }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add exercise / set")
                                }
                                .foregroundColor(.blue)
                            }
                        }

                        sectionView(title: "Tags & Category") {
                            VStack(spacing: 12) {
                                HStack {
                                    TextField("Add tag", text: $newTagText)
                                        .inputFieldStyle()

                                    Button("Add") {
                                        vm.addTag(newTagText)
                                        newTagText = ""
                                    }
                                    .disabled(newTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                                    .foregroundColor(newTagText.isEmpty ? .secondary : .blue)
                                }

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(vm.gymActivity.tags, id: \.self) { tag in
                                            TagChip(tag: tag) { vm.removeTag(tag) }
                                        }
                                    }
                                }

                                TextField("Category (e.g., Strength)", text: .constant(
                                    "some some "
                                ))
                            }
                        }

                        sectionView(title: "Metrics") {
                            VStack(spacing: 12) {
                                metricRow(title: "Estimated volume", value: String(format: "%.0f kg", vm.estimatedVolumeKg))
                                metricRow(title: "Total reps", value: "\(vm.totalReps)")
                                metricRow(title: "Total series", value: "\(vm.gymActivity.totalSeriesCount)")
                            }
                        }

                        Button(action: {
                            Task {
//                                let ok = await vm.save()
//                                if ok {
//                                    // Success feedback can be added later
//                                }
                            }
                        }) {
                            if vm.isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                Text("Save Routine")
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(16)
                            }
                        }
                        .disabled(!vm.canSave)
                        .padding(.top)
                    }
                    .padding(20)
                }
            }
            .navigationBarTitle("Create Routine", displayMode: .large)
            .sheet(isPresented: $showingExercisePicker) {
                ExercisePickerView { exercise in
                    showingExercisePicker = false
                    vm.addSet(with: exercise)
                }
            }
            .sheet(isPresented: $showRoutineCreator) {
                RoutineCreatorSheet(isPresented: $showRoutineCreator)
            }
            .alert(item: $vm.error) { err in
                Alert(title: Text("Error"), message: Text(err.message), dismissButton: .default(Text("OK")))
            }
        }
    }

    // MARK: - Section View (Adaptive)

    @ViewBuilder
    private func sectionView<Content: View>(title: some View, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            title
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)

            content()
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.separator), lineWidth: 0.5)
                )
        }
    }

    private func sectionView(title: String, @ViewBuilder content: () -> some View) -> some View {
        sectionView(title: Text(title), content: content)
    }

    private func metricRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Subviews (Theme-Safe)

private struct TagChip: View {
    let tag: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(tag)
                .font(.caption)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(16)

            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding(4)
    }
}

private struct RoutineSetRowView: View {
    @Binding var set: RoutineSet
    var onAddSerie: () -> Void
    var onRemove: () -> Void
    var onEditSeria: (_ serieIndex: Int, _ serie: Serie) -> Void

    @State private var expanded = false

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(set.exerciseName)
                        .font(.headline)
//                    if let equipment = set.exercise.equipment, !equipment.isEmpty {
//                        Text(equipment)
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("\(set.series.count) series")
                        .foregroundColor(.primary)
                    Text(String(format: "%.0f kg", set.estimatedVolumeKg))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Button(action: { expanded.toggle() }) {
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                }
            }

            if expanded {
                VStack(spacing: 8) {
                    ForEach($set.series) { $serie in
                        SerieRowView(serie: $serie) {
                            // Remove serie
                            if let index = set.series.firstIndex(where: { $0.id == serie.id }) {
                                set.series.remove(at: index)
                            }
                        }
                    }

                    HStack {
                        Button(action: onAddSerie) {
                            Label("Add serie", systemImage: "plus.circle")
                        }
                        Spacer()
                        Button("Remove set", role: .destructive, action: onRemove)
                    }
                }
                .padding(.top, 6)
            }
        }
        .padding(.vertical, 8)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(12)
    }
}

private struct SerieRowViewTest: View {
    @Binding var serie: Serie
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading) {
                HStack {
                    Text("Reps:")
                        .foregroundColor(.primary)
                    TextField("Reps", value: $serie.repetitions, formatter: NumberFormatter.integer)
                        .keyboardType(.numberPad)
                        .frame(width: 60)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Weight (kg):")
                        .foregroundColor(.primary)
                    TextField("kg", value: Binding(
                        get: { serie.idealWeightKg ?? 0.0 },
                        set: { serie.idealWeightKg = $0 > 0 ? $0 : nil }
                    ), formatter: NumberFormatter.decimal)
                        .keyboardType(.decimalPad)
                        .frame(width: 80)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            Spacer()
            Text(String(format: "%.0f kg", serie.estimatedVolumeKg))
                .font(.caption)
                .foregroundColor(.secondary)

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
        }
        .padding(8)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}

// MARK: - Input Field Style

private extension View {
    func inputFieldStyle() -> some View {
        self
            .padding(12)
            .background(Color(.tertiarySystemBackground))
            .cornerRadius(12)
//            .textInputStyle(.plain) // Remove iOS 17 inset
    }
}


// MARK: - Preview

#Preview {
    RoutineCreatorTestView(viewModel: GymActivityViewModel())
        .preferredColorScheme(.light)
}

#Preview {
    RoutineCreatorTestView(viewModel: GymActivityViewModel())
        .preferredColorScheme(.dark)
}

