//
//  PopularWorkoutSectionView.swift
//  Wellish
//

import SwiftUI
import Firebase


struct PopularWorkoutSectionView: View {

    @StateObject private var vm = PopularWorkoutViewModel()
    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            SectionBarTitle(title: "Rutinas Populares")

            if vm.isLoading {
                // Skeleton
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.fitnessBackgroundSecondary)
                    .frame(height: 150)
                    .padding(.horizontal, 14)
                    .padding(.top, 16)
                    .redacted(reason: .placeholder)

            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(vm.routines) { routine in
                            PopularRoutineCard(routine: routine)
                                .onTapGesture {
                                    navigationRouter.goTo(.gymActivityDetail(routine))
                                }
                        }
                    }
                    .padding(.horizontal, 14)
                    .padding(.top, 16)
                }
            }
        }
        .task {
            await vm.loadRoutines()
        }
    }
}

// MARK: - Popular Routine Card

struct PopularRoutineCard: View {

    let routine: GymActivity

    var body: some View {
        ZStack {
            // Background image
            if let imageURL = routine.imageURL {
                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        image.resizable().aspectRatio(contentMode: .fill)
                    } else {
                        Image("background_2")
                            .resizable().aspectRatio(contentMode: .fill)
                    }
                }
            } else {
                Image("background_2")
                    .resizable().aspectRatio(contentMode: .fill)
            }

            Color.fitnessBackgroundPrimary.opacity(0.75)

            VStack(alignment: .leading, spacing: 8) {
                Text(routine.name)
                    .font(.custom("Lemon", size: 28))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                    .lineLimit(2)

                HStack(alignment: .center) {
                    RoutineStatisticsRowView(
                        calories: "\(routine.estimatedCalories ?? 0) KCAL",
                        time: "\(routine.estimatedDurationMinutes ?? 0) mins",
                        exercises: "\(routine.sets.count) ejercicios"
                    )
                    Spacer()
                    if let difficulty = routine.difficulty {
                        Badge(label: difficulty.rawValue)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(height: 150)
        .clipped()
        .contentShape(Rectangle())
        .cornerRadius(16)
    }
}

// MARK: - ViewModel

@MainActor
class PopularWorkoutViewModel: ObservableObject {

    @Published var routines: [GymActivity] = []
    @Published var isLoading: Bool = false

    private let activityService = ActivityService()

    func loadRoutines() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let snapshot = try await Firestore.firestore()
                .collection("activities")
                .whereField("activityType", isEqualTo: "gym")
                .getDocuments()

            await MainActor.run {
                routines = snapshot.documents.compactMap { doc -> GymActivity? in
                    do {
                        return try doc.data(as: GymActivity.self)
                    } catch {
                        print("🔥 GymActivity decode error: \(error)")
                        return nil
                    }
                }
                print("🏋️ Routines loaded: \(routines.count)")
                snapshot.documents.forEach { doc in
                    print("🔥 Doc ID: \(doc.documentID), data: \(doc.data())")
                }
            }
        } catch {
            print("🔥 Error: \(error.localizedDescription)")
        }

        isLoading = false
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color(red: 0.07, green: 0.09, blue: 0.14).ignoresSafeArea()
        PopularWorkoutSectionView()
            .environmentObject(NavigationRouter())
    }
}
