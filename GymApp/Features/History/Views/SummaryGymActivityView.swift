//
//  TrackingHistoryView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/11/25.
//

import Foundation
import SwiftUI

struct SummaryDayView: View {
    
    // MARK: - Properties
    
    private let date: Date = Date()
    private let performances: [GymActivityPerformance] = [MetricsDataSet.performanceDay]
    
    @State private var selectedPerformance: GymActivityPerformance?
    @State private var showDetailSheet = false
    
    // MARK: - Computed Properties
    
    private var totalWorkouts: Int {
        performances.filter { $0.isCompleted }.count
    }
    
    private var totalDuration: Int {
        performances.compactMap { $0.actualDurationMinutes }.reduce(0, +)
    }
    
    private var totalCalories: Int {
        performances.compactMap { $0.actualCalories }.reduce(0, +)
    }
    
    private var totalVolume: Double {
        performances.reduce(0) { $0 + $1.totalVolumeKg }
    }
    
    private var averageRPE: Double {
        let rpes = performances.compactMap { $0.rpe }
        guard !rpes.isEmpty else { return 0 }
        return Double(rpes.reduce(0, +)) / Double(rpes.count)
    }
    
    private var totalSets: Int {
        performances.reduce(0) { $0 + $1.totalSetsCompleted }
    }
    
    private var totalReps: Int {
        performances.reduce(0) { $0 + $1.totalRepsCompleted }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        
        if Calendar.current.isDateInToday(date) {
            return "Hoy"
        } else if Calendar.current.isDateInYesterday(date) {
            return "Ayer"
        } else {
            formatter.dateFormat = "EEEE, d 'de' MMMM"
            return formatter.string(from: date).capitalized
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // Header
                headerSection
                
                // Stats Cards
                statsCardsSection
                
                // Workouts List
                if !performances.isEmpty {
                    workoutsListSection
                }
                
                // Empty State
                if performances.isEmpty {
                    emptyStateSection
                }
            }
            .padding()
        }
        .background(Color.fitnessBackgroundPrimary)
        .navigationTitle("Resumen del Día")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showDetailSheet) {
            if let performance = selectedPerformance {
                WorkoutDetailView(performance: performance)
            }
        }
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text(formattedDate)
                .font(.title2)
                .fontWeight(.bold)
            
            if totalWorkouts > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(totalWorkouts) \(totalWorkouts == 1 ? "sesión" : "sesiones") completada\(totalWorkouts == 1 ? "" : "s")")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
    }
    
    // MARK: - Stats Cards Section
    
    private var statsCardsSection: some View {
        VStack(spacing: 12) {
            // Primera fila
            HStack(spacing: 12) {
                StatCardSef(
                    icon: "dumbbell.fill",
                    iconColor: .blue,
                    title: "Volumen",
                    value: String(format: "%.1f", totalVolume),
                    unit: "kg"
                )
                
                StatCardSef(
                    icon: "clock.fill",
                    iconColor: .green,
                    title: "Tiempo",
                    value: "\(totalDuration)",
                    unit: "min"
                )
            }
            
            // Segunda fila
            HStack(spacing: 12) {
                StatCardSef(
                    icon: "flame.fill",
                    iconColor: .orange,
                    title: "Calorías",
                    value: "\(totalCalories)",
                    unit: "kcal"
                )
                
                StatCardSef(
                    icon: "chart.line.uptrend.xyaxis",
                    iconColor: .purple,
                    title: "RPE Prom.",
                    value: String(format: "%.1f", averageRPE),
                    unit: "/10"
                )
            }
            
            // Tercera fila
            HStack(spacing: 12) {
                StatCardSef(
                    icon: "square.stack.3d.up.fill",
                    iconColor: .indigo,
                    title: "Series",
                    value: "\(totalSets)",
                    unit: "sets"
                )
                
                StatCardSef(
                    icon: "repeat",
                    iconColor: .pink,
                    title: "Reps",
                    value: "\(totalReps)",
                    unit: "reps"
                )
            }
        }
    }
    
    // MARK: - Workouts List Section
    
    private var workoutsListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sesiones de Entrenamiento")
                .font(.headline)
                .padding(.horizontal, 4)
            
            ForEach(performances) { performance in
                WorkoutCard(performance: performance)
                    .onTapGesture {
                        selectedPerformance = performance
                        showDetailSheet = true
                    }
            }
        }
    }
    
    // MARK: - Empty State
    
    private var emptyStateSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.run.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Sin entrenamientos")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("No hay sesiones registradas para este día")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
    }
}

// MARK: - Stat Card Component

struct StatCardSef: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    let unit: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .font(.title3)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(12)
    }
}

// MARK: - Workout Card Component

struct WorkoutCard: View {
    let performance: GymActivityPerformance
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: performance.startedAt)
    }
    
    private var durationString: String {
        guard let duration = performance.actualDurationMinutes else { return "N/A" }
        return "\(duration) min"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Entrenamiento de Gym")
                        .font(.headline)
                    
                    Text(timeString)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let rpe = performance.rpe {
                    RPEBadge(rpe: rpe)
                }
            }
            
            Divider()
            
            // Stats Grid
            HStack(spacing: 16) {
                QuickStat(
                    icon: "dumbbell.fill",
                    value: String(format: "%.1f kg", performance.totalVolumeKg),
                    color: .blue
                )
                
                QuickStat(
                    icon: "square.stack.3d.up.fill",
                    value: "\(performance.totalSetsCompleted) sets",
                    color: .indigo
                )
                
                QuickStat(
                    icon: "clock.fill",
                    value: durationString,
                    color: .green
                )
            }
            
            // Progress Indicator
            if performance.isCompleted {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                    
                    Text("Completado")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(12)
    }
}

// MARK: - Quick Stat Component

struct QuickStat: View {
    let icon: String
    let value: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.caption)
            
            Text(value)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - RPE Badge Component

struct RPEBadge: View {
    let rpe: Int
    
    private var badgeColor: Color {
        switch rpe {
        case 1...3: return .green
        case 4...6: return .yellow
        case 7...8: return .orange
        case 9...10: return .red
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "bolt.fill")
                .font(.caption2)
            
            Text("RPE \(rpe)")
                .font(.caption)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(badgeColor)
        .cornerRadius(8)
    }
}

// MARK: - Workout Detail View (Modal)

struct WorkoutDetailView: View {
    let performance: GymActivityPerformance
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Stats
                    VStack(spacing: 12) {
                        HStack {
                            StatDetailCard(
                                title: "Volumen Total",
                                value: String(format: "%.1f kg", performance.totalVolumeKg),
                                icon: "dumbbell.fill",
                                color: .blue
                            )
                            
                            StatDetailCard(
                                title: "Duración",
                                value: performance.formattedDuration,
                                icon: "clock.fill",
                                color: .green
                            )
                        }
                        
                        HStack {
                            StatDetailCard(
                                title: "Series",
                                value: "\(performance.totalSetsCompleted)",
                                icon: "square.stack.3d.up.fill",
                                color: .indigo
                            )
                            
                            StatDetailCard(
                                title: "Repeticiones",
                                value: "\(performance.totalRepsCompleted)",
                                icon: "repeat",
                                color: .pink
                            )
                        }
                    }
                    .padding()
                    
                    // Sets Breakdown
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Desglose de Sets")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(performance.performedSets) { set in
                            SetDetailCard(set: set)
                                .padding(.horizontal)
                        }
                    }
                    
                    // Notes
                    if let notes = performance.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notas")
                                .font(.headline)
                            
                            Text(notes)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Detalle del Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Stat Detail Card

struct StatDetailCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Set Detail Card

struct SetDetailCard: View {
    let set: PerformedRoutineSet
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(set.name)
                    .font(.headline)
                
                Spacer()
                
                Text("\(set.completedSeries.count) series")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
            }
            
            // Series
            ForEach(Array(set.completedSeries.enumerated()), id: \.element.id) { index, series in
                HStack {
                    Text("Serie \(index + 1)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(String(format: "%.1f", series.weightKg)) kg × \(series.reps)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    if series.wasSuccessful {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }
            }
            
            // Volume Summary
            Divider()
            
            HStack {
                Text("Volumen del set:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(String(format: "%.1f kg", set.totalVolumeKg))
                    .font(.caption)
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        SummaryDayView()
    }
}
