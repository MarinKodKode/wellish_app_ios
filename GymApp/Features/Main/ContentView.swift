import SwiftUI
import FirebaseAuth
import ActivityKit

struct ContentView: View {
    @StateObject private var onboardingService = OnboardingService()
    @StateObject private var authenticationService = AuthenticationService()
    @State private var navigationPath = NavigationPath()
    @State private var showWorkoutTimer = true
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        AlertManagerView()
        NavigationStack(path: $navigationRouter.path) {
            Group {
                if onboardingService.shouldShowOnboarding {
                    OnboardingView()
                        .environmentObject(onboardingService)
                } else {
                    authenticationFlow
                }
            }
            .animation(.easeInOut(duration: 0.3), value: onboardingService.shouldShowOnboarding)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .signup:
                    SignUpView()
                        .environmentObject(navigationRouter)
                case .signin:
                    SignInView()
                        .environmentObject(navigationRouter)
                case .createRoutine :
                    RoutineCreatorView(viewModel: GymActivityViewModel())
                        .environmentObject(navigationRouter)
                case .workoutTimer :
                    WorkoutTimerView(showWorkoutTimer: $showWorkoutTimer)
                        .environmentObject(navigationRouter)
                case .todayWorkout(let plan) :
                    LiveTrackerActivity(plan : plan)
                        .environmentObject(navigationRouter)
                case .createPlan :
                    CreatePlanView()
                        .environmentObject(navigationRouter)
                case .adminConsole :
                    AdminConsole()
                        .environmentObject(navigationRouter)
                case .gymActivityDetail(let activity) :
                    GymActivityDetailView(activity: activity)
                        .environmentObject(navigationRouter)
                case .planDetail(let plan) :
                    PlanDetailView(plan: plan, vm: PlanDetailViewModel())
                        .environmentObject(navigationRouter)
                case .exerciseDetail(let exercise) :
                    ExerciseDetailView(exercise: exercise)
                case .summaryDay :
                    SummaryDayView()
                default :
                    SignInView()
                }
            }
        }
    }
    
    @ViewBuilder
    private var authenticationFlow: some View {

            switch authenticationService.authenticationState {
            case .loading:
                LoadingView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
            case .authenticated:
                MainTabViewContainer(navigationPath: $navigationPath)
                    .environmentObject(authenticationService)
                
            case .unauthenticated:
                WelcomeView()
                    .environmentObject(navigationRouter)
                    .environmentObject(authenticationService)
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
