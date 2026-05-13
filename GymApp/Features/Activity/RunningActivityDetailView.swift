//
//  RunningActivityDetailView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/10/25.
//

import SwiftUI

struct RunningActivityDetailView: View {
    let activity: RunningActivity
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
                    
                    // Running Details
                    runningDetailsSection
                    
//                    // Intervals (if applicable)
//                    if let intervals = activity.intervals, !intervals.isEmpty {
//                        intervalsSection(intervals: intervals)
//                    }
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
            // Running Type Badge
            HStack(spacing: 8) {
                Image(systemName: activity.icon)
                    .font(.system(size: 14))
                    .foregroundColor(.red)
                Text(activity.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.red.opacity(0.2))
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
                                .foregroundColor(.red)
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
                Text("Run Stats")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                // Distance
                if let distance = activity.targetDistanceKm {
                    RunStatCard(
                        icon: "figure.run",
                        title: "Distance",
                        value: String(format: "%.1f", distance),
                        unit: "km",
                        color: .red
                    )
                }
                
                // Duration
                if let duration = activity.targetDurationMinutes {
                    RunStatCard(
                        icon: "clock.fill",
                        title: "Duration",
                        value: "\(duration)",
                        unit: "min",
                        color: .blue
                    )
                }
                
                // Pace
                if let pace = activity.targetPaceMinPerKm {
                    RunStatCard(
                        icon: "speedometer",
                        title: "Target Pace",
                        value: pace,
                        unit: "min/km",
                        color: .green
                    )
                }
                
                // Calories
                if let calories = activity.estimatedCaloriesValue {
                    RunStatCard(
                        icon: "flame.fill",
                        title: "Calories",
                        value: "\(calories)",
                        unit: "kcal",
                        color: .orange
                    )
                }
            }
        }
    }
    
    // MARK: - Running Details
    private var runningDetailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.blue)
                Text("Run Details")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Intensity
                if let intensity = activity.intensity {
                    DetailRow(
                        icon: "heart.fill",
                        label: "Intensity",
                        value: intensity.rawValue,
                        color: intensityColor(intensity)
                    )
                }
                
                // Terrain
                if let terrain = activity.terrain {
                    DetailRow(
                        icon: "mountain.2.fill",
                        label: "Terrain",
                        value: terrain.rawValue,
                        color: .green
                    )
                }
                
                // Elevation Gain
                if let elevation = activity.elevationGainMeters {
                    DetailRow(
                        icon: "arrow.up.right",
                        label: "Elevation Gain",
                        value: "\(elevation) m",
                        color: .purple
                    )
                }
                
                // Running Type Description
                DetailRow(
                    icon: "figure.run.circle.fill",
                    label: "Type",
                    value: activity.description ?? "",
                    color: .red
                )
            }
        }
    }
//    
//    // MARK: - Intervals Section
//    private func intervalsSection(intervals: [RunningInterval]) -> some View {
//        VStack(alignment: .leading, spacing: 16) {
//            HStack {
//                Image(systemName: "timer")
//                    .font(.system(size: 18))
//                    .foregroundColor(.yellow)
//                Text("Intervals")
//                    .font(.system(size: 20, weight: .bold))
//                    .foregroundColor(.white)
//                Spacer()
//                
//                Text("\(intervals.count) intervals")
//                    .font(.system(size: 14, weight: .medium))
//                    .foregroundColor(Color(white: 0.6))
//            }
//            
//            VStack(spacing: 12) {
//                ForEach(Array(intervals.enumerated()), id: \.element.id) { index, interval in
//                    IntervalCard(interval: interval, index: index + 1)
//                }
//            }
//        }
//    }
    
    private func intensityColor(_ intensity: CardioIntensity) -> Color {
        switch intensity {
        case .low:
            return .green
        case .moderate:
            return .yellow
        case .high:
            return .orange
        case .interval:
            return .red
        }
    }
}

// MARK: - Run Stat Card Component
struct RunStatCard: View {
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

// MARK: - Detail Row Component
struct DetailRow: View {
    let icon: String
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.system(size: 13))
                    .foregroundColor(Color(white: 0.6))
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color(red: 0.12, green: 0.14, blue: 0.19))
        .cornerRadius(12)
    }
}

// MARK: - Interval Card Component
public struct IntervalCard: View {
    public let interval: RunningInterval
    public let index: Int
    
    public var body: some View {
        HStack(spacing: 16) {
            // Index Circle
            ZStack {
                Circle()
                    .fill(intervalColor.opacity(0.2))
                    .frame(width: 50, height: 50)
                Text("\(index)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(intervalColor)
            }
            
            // Interval Details
            VStack(alignment: .leading, spacing: 8) {
                Text("Done it well")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                            .foregroundColor(Color(white: 0.6))
                        Text("\(interval.durationMinutes) min")
                            .font(.system(size: 13))
                            .foregroundColor(Color(white: 0.6))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "ruler")
                            .font(.system(size: 12))
                            .foregroundColor(Color(white: 0.6))
                        Text(String(format: "%.1f km", interval.paceMinPerKm))
                            .font(.system(size: 13))
                            .foregroundColor(Color(white: 0.6))
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "speedometer")
                            .font(.system(size: 12))
                            .foregroundColor(Color(white: 0.6))
                        Text(interval.paceMinPerKm)
                            .font(.system(size: 13))
                            .foregroundColor(Color(white: 0.6))
                    }
                }
            }
            
            Spacer()
            
            // Intensity Badge
            Text("Intensidad")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(intervalColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(intervalColor.opacity(0.2))
                .cornerRadius(6)
        }
        .padding(12)
        .background(Color(red: 0.12, green: 0.14, blue: 0.19))
        .cornerRadius(16)
    }
    
    private var intervalColor: Color = .red
}


public enum IntervalType: String, Codable {
    case warmup
    case work
    case recovery
    case cooldown
    
    var displayName: String {
        switch self {
        case .warmup: return "Warm Up"
        case .work: return "Work Interval"
        case .recovery: return "Recovery"
        case .cooldown: return "Cool Down"
        }
    }
}

// MARK: - Timestamp for Firestore compatibility
public struct Timestamp: Codable {
    let date: Date
    
    init(date: Date) {
        self.date = date
    }
}
//
//
//#Preview {
//    RunningActivityDetailView(activity: ActivityDataset.runningActivities[0])
//}
