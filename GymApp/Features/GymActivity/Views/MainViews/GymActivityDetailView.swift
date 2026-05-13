//
//  GymActivityDetailView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/10/25.
//

import SwiftUI

struct GymActivityDetailView: View {
    
    let activity: GymActivity
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.09, green: 0.11, blue: 0.16)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header Section
                    headerSection
                    
                    // Stats Overview
                    statsOverviewSection
                    
                    // Muscle Groups
                    if activity.primaryMusclesDisplay.isEmpty == false {
                        muscleGroupsSection
                    }
                    
                    // Exercise Sets
                    exerciseSetsSection
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle(activity.name)
        .navigationBarTitleDisplayMode(.large)
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category Badge
            HStack(spacing: 8) {
                Image(systemName: activity.icon)
                    .font(.system(size: 14))
                    .foregroundColor(.blue)
                Text(activity.category?.rawValue ?? "Gym Workout")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
            
            // Description
            if let description = activity.description {
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(Color(white: 0.7))
                    .multilineTextAlignment(.leading)
            }
            
            // Tags
            if !activity.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(activity.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(white: 0.15))
                                .cornerRadius(6)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Stats Overview
    private var statsOverviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.orange)
                Text("Workout Stats")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                // Duration
                if let duration = activity.estimatedDurationMinutes {
                    StatCardd(
                        icon: "clock.fill",
                        title: "Duration",
                        value: "\(duration)",
                        unit: "min",
                        color: .blue
                    )
                }
                
                // Calories
                if let calories = activity.estimatedCaloriesValue {
                    StatCardd(
                        icon: "flame.fill",
                        title: "Calories",
                        value: "\(calories)",
                        unit: "kcal",
                        color: .orange
                    )
                }
                
                // Volume
                StatCardd(
                    icon: "scalemass.fill",
                    title: "Volume",
                    value: String(format: "%.1f", activity.estimatedVolumeKg),
                    unit: "kg",
                    color: .purple
                )
                
                // Total Sets
                StatCardd(
                    icon: "repeat",
                    title: "Total Sets",
                    value: "\(activity.totalSeriesCount)",
                    unit: "sets",
                    color: .green
                )
            }
        }
    }
    
    // MARK: - Muscle Groups
    private var muscleGroupsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.system(size: 18))
                    .foregroundColor(.red)
                Text("Muscle Groups")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Primary Muscle
                if !activity.primaryMusclesDisplay.isEmpty {
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                        Text("Primary:")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(white: 0.6))
                        Text(activity.primaryMusclesDisplay)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(12)
                    .background(Color(red: 0.12, green: 0.14, blue: 0.19))
                    .cornerRadius(12)
                }
                
                // Secondary Muscles
                if !activity.primaryMuscles.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 8, height: 8)
                            Text("Secondary:")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(white: 0.6))
                        }
                        
                        FlowLayout(spacing: 8) {
                            ForEach(activity.primaryMuscles, id: \.self) { muscle in
                                Text("muscle")
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(red: 0.12, green: 0.14, blue: 0.19))
                    .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - Exercise Sets
    private var exerciseSetsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "list.bullet.clipboard.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                Text("Exercise Sets")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                
                Text("\(activity.sets.count) exercises")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(white: 0.6))
            }
            
            if activity.sets.isEmpty {
                emptyStateView
            } else {
                ForEach(Array(activity.sets.enumerated()), id: \.element.id) { index, set in
                    ExerciseSetCard(set: set, index: index + 1)
                }
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "dumbbell")
                .font(.system(size: 64))
                .foregroundColor(Color(white: 0.3))
            
            Text("No exercises yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(white: 0.5))
            
            Text("Add exercises to this workout")
                .font(.system(size: 14))
                .foregroundColor(Color(white: 0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .background(Color(red: 0.12, green: 0.14, blue: 0.19))
        .cornerRadius(16)
    }
}

// MARK: - Stat Card Component
struct StatCardd: View {
    let icon: String
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                HStack(alignment: .lastTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Text(unit)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(white: 0.6))
                }
                
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(Color(white: 0.6))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(red: 0.12, green: 0.14, blue: 0.19))
        .cornerRadius(16)
    }
}


// MARK: - Flow Layout for Tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.positions[index].x,
                                     y: bounds.minY + result.positions[index].y),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0
            
            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)
                
                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }
                
                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }
            
            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}
