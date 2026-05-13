import SwiftUI
import Lottie

struct GymLiveTrackerView: View {

    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var tracker = GymLiveTrackerViewModel.shared
    let planDetailViewModel = PlanDetailViewModel()
    let planElement: PlanElement
    let plan : Plan
    
    var body: some View {
        ZStack {
            Color.fitnessBackgroundPrimary.ignoresSafeArea()

            if tracker.showWorkoutComplete {
                GymLiveTracker_WorkoutCompleteView(
                    totalTime: tracker.elapsedTime,
                    caloriesBurned: tracker.caloriesBurned,
                    onDismiss: {
                        dismiss()
                        Task {
                            await planDetailViewModel
                                .markElementAsCompleted(
                                    plan,
                                    planElement
                                )
                        }
//                        tracker.reset()
                    }
                )
            } else if let gymActivity = tracker.currentGymActivity {
                ScrollView {
                    VStack(spacing: 16) {
                        GymLiveTracker_HeaderView(
                            workoutName: gymActivity.name,
                            elapsedTime: tracker.elapsedTime
                        )
                        
                        GymLiveTracker_ProgressCardView(
                            completedSets: tracker.completedSetsCount,
                            totalSets: tracker.totalSets,
                            progress: tracker.progress
                        )
                        
                        GymLiveTracker_MetricsViewLocal(
                            elapsedTime: tracker.elapsedTime,
                            caloriesBurned: tracker.caloriesBurned,
                            currentExercise: tracker.currentExerciseIndex + 1,
                            totalExercises: gymActivity.sets.count
                        )
                        
                        if tracker.isResting {
                            GymLiveTracker_RestTimer(
                                restTimer: tracker.restTimer,
                                onSkip: {
                                    tracker.skipRest()
                                }
                            )
                        }
                        
                        if let currentSet = tracker.currentRoutineSet {
                            GymLiveTracker_CurrentExerciseCard(
                                routineSet: currentSet,
                                currentSet: tracker.currentSet,
                                property: $tracker.currentSet,
                                currentExerciseIndex: tracker.currentExerciseIndex,
                                totalExercises: gymActivity.sets.count,
                                completedSets: tracker.completedSets[tracker.currentExerciseIndex] ?? [],
                                totalSetsInExercise: currentSet.series.count,
                                isTimerRunning: tracker.isTimerRunning,
                                isResting: tracker.isResting,
                                onStart: {
                                    tracker.startWorkout(with: planElement)
                                },
                                onPause: tracker.pauseWorkout,
                                onResume: tracker.resumeWorkout,
                                onCompleteSet: tracker.completeSet
                            )
                            
                        }
                        
                        GymLiveTracker_ExerciseListView(
                            sets: gymActivity.sets,
                            currentIndex: tracker.currentExerciseIndex
                        )
                        
                        if tracker.isTimerRunning {
                            Button("Saltar ejercicio") {
                                tracker.skipExercise()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.15, green: 0.17, blue: 0.25))
                            .foregroundColor(.gray)
                            .cornerRadius(16)
                        }
                    }
                    .padding()
                    .padding(.bottom, 40)
                }
            }
            
            if tracker.showSetComplete {
                GymLiveTracker_SetCompleteAnimation()
            }
        }
        .navigationBarBackButtonHidden(tracker.isTimerRunning)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {

                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
    }
    
    private func showExitConfirmation() {
        tracker.pauseWorkout()
        dismiss()
    }
}
