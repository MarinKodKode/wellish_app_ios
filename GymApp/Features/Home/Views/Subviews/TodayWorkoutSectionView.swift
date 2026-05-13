import SwiftUI
 
struct TodayWorkoutView: View {
 
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var vm = PlanTrackerCurrentDayViewModel()
 
    private var dateToday: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.dateFormat = "EEEE d 'de' MMMM"
        return formatter.string(from: Date()).localizedCapitalized
    }
    
    var body: some View {
        Group {
            if vm.isLoading {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.fitnessBackgroundSecondary)
                    .frame(height: UIScreen.screenHeight * 0.25)
                    .padding(.horizontal, 16)
                    .redacted(reason: .placeholder)
 
            } else if vm.hasTodayActivities {
                VStack {
                    SectionBarTitle(dateToday )
                        .padding(.top, 24)
 
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center) {
                            ForEach(vm.todayActivities) { activity in
                                ZStack {
                                    BackgroundCardImage(image: activity.image)
                                    Color.black.opacity(0.4)
                                    VStack(spacing: 12) {
                                        TodayWorkoutTitleCard(title: activity.title)
                                        RoutineStatisticsRowView(
                                            calories: "\(activity.calories) KCAL",
                                            time: "\(activity.time) mins",
                                            exercises: "\(activity.element.activity.tags.count) tags"
                                        )
                                    }
                                }
                                .frame(
                                    width: UIScreen.screenWidth * 0.95,
                                    height: UIScreen.screenHeight * 0.25
                                )
                                .cornerRadius(12)
                                .padding(.horizontal, 16)
                                .onTapGesture {
                                    navigationRouter.goTo(.todayWorkout(plan: activity.parentPlan))
                                }
                            }
                        }
                    }
                    .frame(height: UIScreen.screenHeight * 0.25)
                }
 
            } else {
                // Sin plan activo — empty state
                EmptyRoutineView()
            }
        }
        .task {
            await vm.initView()
        }
    }
}
struct BackgroundCardImage : View {
    
    var image : String
    
    init(image: String) {
        self.image = image
    }
    
    var body: some View {
        AsyncImage(url: URL(string: image)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else if phase.error != nil {
                Image("background_5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            } else {
                Image("background_5")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
        }
    }
}

struct TodayWorkoutTitleCard : View {
    
    let title : String?
    
    init(title: String?) {
        self.title = title
    }
    
    var body: some View {
        Text(title ?? "Today's challenge")
            .lineLimit(2)
            .font(.custom("Lemon", size: 40))
            .foregroundColor(.fitnessTextPrimary)
            .multilineTextAlignment(.center)
    }
}
