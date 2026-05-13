//
//  WorkoutTimerView.swift
//  GymApp
//
//  Created by Manuel Alejandro Hernandez Marín on 23/07/25.
//

import SwiftUI

struct WorkoutTimerView: View {
    @Binding var showWorkoutTimer: Bool
    @State private var selectedTimeframe = "Weekly"
    @State private var currentTime: Double = 25.10
    @State private var isPlaying = false
    @State private var timer: Timer?
    @State private var calories: Int = 90
    @State private var completedSets = 0
    @State private var idealSets = 4
    @State private var enteredWeight: Double = 0.0
    @State private var showingWeightAlert = false
    @State private var setWeight = false
    @State private var showStickyBar = false // Controls sticky bar visibility

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                Color.fitnessBackgroundPrimary.ignoresSafeArea()
                VStack {
                    headerView
                    
                    if showStickyBar {
                        StickyTImer(
                            curentTime: $currentTime,
                            isPlaying: $isPlaying,
                            calories: $calories
                        )
                    }
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            Color.clear
                                .frame(height: 1)
                                .background(GeometryReader { proxy in
                                    let minY = proxy.frame(in: .global).minY
                                    Color.clear
                                        .onAppear {
                                            showStickyBar = minY < 100
                                        }
                                        .onChange(of: minY) { newValue in
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                showStickyBar = newValue < 100
                                            }
                                        }
                                })
                            
                            // Show full timer only when sticky bar is NOT shown
                            if !showStickyBar {
                                timerCircleView
                                    .transition(.opacity)
                                    .animation(.easeOut(duration: 0.3), value: showStickyBar)
                            }
                            
                            // Stats Row
                            statsRowView
                            
                            // Activity History
                            activityHistoryView
                        }
                        .padding(.top, 100)
                        .padding(.horizontal, 20)
                    }
                    
                    
                }
            }
        }
        .navigationBarHidden(true)
        .onDisappear {
            timer?.invalidate()
        }
    }

    // MARK: - Header
    private var headerView: some View {
        HStack {
            Button(action: {
                showWorkoutTimer = false
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.fitnessTextPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.fitnessBackgroundSecondary)
                    .clipShape(Circle())
            }

            Spacer()

            Text("Routine")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.fitnessTextPrimary)

            Spacer()

            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.fitnessTextPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.fitnessBackgroundSecondary)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    // MARK: - Timer Circle
    private var timerCircleView: some View {
        ZStack {
            // Background Circle
            Circle()
                .stroke(Color.fitnessTextSecondary.opacity(0.3), lineWidth: 8)
                .frame(width: 280, height: 280)

            // Progress Circle
            Circle()
                .trim(from: 0, to: currentTime / workoutSession.totalTime)
                .stroke(
                    LinearGradient(
                        colors: [Color.fitnessPrimary.opacity(0.8), Color.fitnessPrimary],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .frame(width: 280, height: 280)
                .rotationEffect(.degrees(-90))

            // Center Content
            VStack(spacing: 8) {
                Button(action: toggleTimer) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.fitnessPrimary)
                        .clipShape(Circle())
                }

                Text(String(format: "%.1f", currentTime))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)

                Text("Minutes")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.fitnessTextSecondary)
            }
        }
    }

    // MARK: - Stats Row
    private var statsRowView: some View {
        HStack(spacing: 16) {
            StatCardComponent(icon: "flame", label: "\(workoutSession.calories) Kcal")
            StatCardComponent(icon: "clock", label: "\(workoutSession.duration) Min")
            // StatCardComponent(icon: "dumbbell", label: workoutSession.reps)
        }
    }

    // MARK: - Activity History
    private var activityHistoryView: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Uncommented section with fitness colors
            HStack {
                Text("Exercises")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)

                Spacer()

                Menu {
                    Button("Daily") { selectedTimeframe = "Daily" }
                    Button("Weekly") { selectedTimeframe = "Weekly" }
                    Button("Monthly") { selectedTimeframe = "Monthly" }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedTimeframe)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.fitnessTextSecondary)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.fitnessBackgroundSecondary)
                    .cornerRadius(8)
                }
            }

            VStack(spacing: 12) {
                ForEach(activityHistory, id: \.id) { activity in
                    activityHistoryRow(activity: activity)
                    activityHistoryRow(activity: activity)
                    activityHistoryRow(activity: activity)
                    activityHistoryRow(activity: activity)
                    activityHistoryRow(activity: activity)
                }
            }
        }
    }

    // MARK: - Activity History Row
    private func activityHistoryRow(activity: ActivityHistoryItem) -> some View {
        HStack(spacing: 12) {
            // 🖼️ Exercise Thumbnail
            AsyncImage(url: URL(string: "https://example.com/dumbbell-curl.jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.fitnessTextSecondary.opacity(0.2))
                    .overlay(
                        Image(systemName: "dumbbell")
                            .foregroundColor(.fitnessTextSecondary)
                            .font(.title2)
                    )
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.fitnessTextSecondary.opacity(0.2), lineWidth: 1)
            )

            // Text & Controls
            VStack(alignment: .leading, spacing: 6) {
                // Exercise Name & Action Buttons
                HStack {
                    Text(activity.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.fitnessTextPrimary)
                        .lineLimit(1)

                    Spacer()

                    // ✅ Set Counter Button
                    Button(action: {
                        if completedSets < idealSets {
                            completedSets += 1
                        }
                        self.setWeight.toggle()
                    }) {
                        Image(systemName: completedSets == idealSets ? "checkmark.circle.fill" : "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(completedSets == idealSets ? .fitnessSuccess : .fitnessPrimary)
                    }

                    // ✅ Weight Entry Button
                    Button(action: {
                        showingWeightAlert = true
                    }) {
                        Image(systemName: enteredWeight > 0 ? "scalemass.fill" : "scalemass")
                            .font(.title3)
                            .foregroundColor(enteredWeight > 0 ? .fitnessWarning : .fitnessTextSecondary)
                    }
                    .disabled(!setWeight)
                }

                // Metrics (Sets and Weight)
                HStack(spacing: 16) {
                    // Sets counter with color coding
                    HStack(spacing: 4) {
                        Image(systemName: "dumbbell")
                            .font(.system(size: 14))
                            .foregroundColor(.fitnessTextSecondary)
                        Text("\(completedSets)/\(idealSets) sets")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(completedSets == idealSets ? .fitnessSuccess : .fitnessTextSecondary)
                    }
                    
                    // Weight display (if entered)
                    if enteredWeight > 0 {
                        HStack(spacing: 4) {
                            Image(systemName: "scalemass")
                                .font(.system(size: 14))
                                .foregroundColor(.fitnessWarning)
                            Text("\(String(format: "%.1f", enteredWeight)) kg")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.fitnessWarning)
                        }
                    }
                }
            }
            .lineLimit(1)
        }
        .padding(12)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(completedSets == idealSets ? Color.fitnessSuccess.opacity(0.3) : Color.clear, lineWidth: 2)
        )
        .alert("Log Weight \n Set \(completedSets)", isPresented: $showingWeightAlert) {
            TextField("Weight (kg)", value: $enteredWeight, formatter: NumberFormatter())
            Button("Cancel", role: .cancel) {
                // Reset button styling
            }
            Button("Save") {
                print("Logged weight: \(enteredWeight) kg")
            }
        } message: {
            Text("Enter the weight used for this set")
                .foregroundColor(.fitnessTextSecondary)
        }
    }
    
    // MARK: - Timer Control
    private func toggleTimer() {
        isPlaying.toggle()

        if isPlaying {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if currentTime > 0 {
                    currentTime -= 0.1
                } else {
                    timer?.invalidate()
                    isPlaying = false
                }
            }
        } else {
            timer?.invalidate()
        }
    }
}

// MARK: - Preview
#Preview {
    @State var showWorkoutTimer = true
    WorkoutTimerView(showWorkoutTimer: $showWorkoutTimer)
        .preferredColorScheme(.dark)
        .previewDevice("iPhone 15 Pro")
        .previewDisplayName("Workout Timer")
}
