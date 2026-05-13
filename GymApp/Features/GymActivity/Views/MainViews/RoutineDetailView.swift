//
//  RoutineDetailView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//


import SwiftUI
import UIKit

struct RoutineDetailView_Stack: View {
    @ObservedObject var vm: GymActivityViewModel
    var routine: GymActivity

    @State private var isEditingRoutine = false
    @State private var isSharing = false
    @State private var showDeleteConfirm = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Header: Name & Actions
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(routine.name)
                                    .font(.title.bold())
                                    .lineLimit(2)

                                Spacer()

                                // Edit Button (only for user routines)
                                if isUserRoutine {
                                    Button(action: { isEditingRoutine.toggle() }) {
                                        Image(systemName: "pencil")
                                    }
                                    .foregroundColor(.blue)
                                }
                            }

                            if ((routine.category?.rawValue.isEmpty) == nil) {
                                Text(routine.category?.rawValue ?? "Some category")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }

                            if let description = routine.description, !description.isEmpty {
                                Text(description)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(.horizontal)

                        // Metrics
                        HStack(spacing: 16) {
                            MetricView(value: "\(routine.totalSeriesCount)", label: "Sets")
                            MetricView(value: "\(routine.totalReps)", label: "Reps")
                            MetricView(value: String(format: "%.0f", routine.estimatedVolumeKg), label: "Volume (kg)")
                            MetricView(
                                value: "\(Int(routine.estimatedDurationMinutes ?? 0))",
                                label: "Est. Time (min)"
                            )
                        }
                        .padding(.horizontal)

                        // Tags
                        if !routine.tags.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(routine.tags, id: \.self) { tag in
                                        ChipView(text: "#\(tag)")
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }

                        // Exercises List
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Exercises")
                                .font(.title3.bold())
                                .padding(.horizontal)

                            ForEach(routine.sets) { set in
                                ExerciseCard(set: set, isEditing: isEditingRoutine) {
                                    // Tap to edit in creator (if editing)
                                    if isEditingRoutine {
                                        // Open RoutineCreator with this routine
                                        // You'd pass via coordinator or binding
                                    }
                                }
                            }
                        }

                        // Delete Button (only for user routines)
                        if isUserRoutine {
                            Button("Delete Routine", role: .destructive) {
                                showDeleteConfirm = true
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                            .padding(.horizontal)
                            .padding(.bottom)
                            .alert("Delete Routine?", isPresented: $showDeleteConfirm) {
                                Button("Delete", role: .destructive) {
//                                    $vm.deleteRoutine(routine)
                                    // Navigate back
                                }
                                Button("Cancel", role: .cancel) { }
                            }
                        }

                        Spacer()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Share") {
                        isSharing = true
                    }
                    .imageScale(.large)
                    .foregroundColor(.blue)
                }
            }
            .sheet(isPresented: $isSharing) {
                ActivityViewController(
                    activityItems: [routine.shareText()],
                    applicationActivities: nil
                )
            }
            .sheet(isPresented: $isEditingRoutine) {
                // Reopen in editor
                RoutineCreatorView(viewModel: GymActivityViewModel())
            }
        }
    }

    // Helper: Determine if routine is user-made
    private var isUserRoutine: Bool {
        // You could use a flag like `routine.isCustom`, or check source
        // For now, assume all are user routines unless marked otherwise
        true
    }
}

// MARK: - Subviews

private struct MetricView: View {
    let value: String
    let label: String

    var body: some View {
        VStack {
            Text(value)
                .font(.title3.bold())
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ChipView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(12)
    }
}

private struct ExerciseCard: View {
    let set: RoutineSet
    let isEditing: Bool
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "figure.strengthtraining.functional")
                    .foregroundColor(.blue)

                Text(set.exerciseName)
                    .font(.headline)

                Spacer()

                Text("\(set.series.count) sets")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            // Equipment
//            if let equipment = set.exercise.equipment, !equipment.isEmpty {
//                Text(equipment)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//            }

            // Series Preview
            HStack {
                ForEach(set.series.prefix(5), id: \.id) { serie in
                    SeriesChip(
                        reps: "\(serie.repetitions)",
                        weight: serie.idealWeightKg.map { String(format: "%.0fkg", $0) } ?? "—"
                    )
                }
                if set.series.count > 5 {
                    Text("+\(set.series.count - 5)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal, 4)
        .onTapGesture(perform: isEditing ? onTap : {})
    }
}

private struct SeriesChip: View {
    let reps: String
    let weight: String

    var body: some View {
        VStack(spacing: 2) {
            Text(reps)
                .font(.caption2)
                .bold()
            Text(weight)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(6)
    }
}

// MARK: - Activity View Controller (for sharing)

struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Shareable Text Extension

extension GymActivity {
    func shareText() -> String {
        let exercises = sets.map { "\($0.exerciseName): \($0.series.count) sets" }.joined(
            separator: ", "
        )
        return """
        Workout Routine: \(name)
        Category: \(category?.rawValue ?? "—")
        Exercises: \(exercises)
        Total Volume: \(String(format: "%.0f", estimatedVolumeKg)) kg
        Generated with Wellish 🏋️‍♂️
        """
    }
}
