
import SwiftUI

struct PlansRoutineDetailView: View {
    let routine: GymActivity

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(routine.name)
                    .font(.title.bold())
                    .foregroundColor(.fitnessTextPrimary)

                if let category = routine.category?.displayName, !category.isEmpty {
                    Text(category)
                        .font(.headline)
                        .foregroundColor(.primaryFitnessBlue)
                }

                if let description = routine.description, !description.isEmpty {
                    Text(description)
                        .foregroundColor(.fitnessTextSecondary)
                }

                // Metrics
                HStack {
                    VStack {
                        Text("\(routine.totalSeriesCount)")
                            .foregroundColor(.fitnessTextPrimary)
                        Text("Sets")
                            .font(.caption)
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    Spacer()
                    VStack {
                        Text("\(routine.totalReps)")
                            .foregroundColor(.fitnessTextPrimary)
                        Text("Reps")
                            .font(.caption)
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    Spacer()
                    VStack {
                        Text(String(format: "%.0fkg", routine.estimatedVolumeKg))
                            .foregroundColor(.fitnessTextPrimary)
                        Text("Volume")
                            .font(.caption)
                            .foregroundColor(.fitnessTextSecondary)
                    }
                }
                .padding()
                .background(Color.fitnessBackgroundSecondary)
                .cornerRadius(12)

                // Tags
                if !routine.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(routine.tags, id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.primaryFitnessBlue.opacity(0.1))
                                    .foregroundColor(.primaryFitnessBlue)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Exercises
                Text("Exercises")
                    .font(.title3.bold())
                    .foregroundColor(.fitnessTextPrimary)
                    .padding(.top)

                ForEach(routine.sets) { set in
                    VStack(alignment: .leading) {
                        Text(set.exerciseName)
                            .font(.headline)
                            .foregroundColor(.fitnessTextPrimary)
                        Text("\(set.series.count) series")
                            .font(.caption)
                            .foregroundColor(.fitnessTextSecondary)
                    }
                    .padding()
                    .background(Color.fitnessBackgroundSecondary)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .padding()
        }
        .background(Color.fitnessBackgroundPrimary)
        .navigationTitle("Routine")
    }
}
