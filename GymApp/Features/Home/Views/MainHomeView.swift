import SwiftUI

struct MainHomeView: View {
    @EnvironmentObject var navigationRouter: NavigationRouter
    let vm = PlanTrackerCurrentDayViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Color.backgroundDark.ignoresSafeArea()
                
                ScrollView(.vertical) {
                    
                    HomeHeaderView()
                    
                    ChallengesSection()
                    
                    TodayWorkoutView()
                    
                    Spacer()
                    
//                    CategoriesSectionView()                    
                    
                    PopularWorkoutSectionView()
                        .padding(.top, 24)
                    
//                    TrySomethingNewSectionView()
                        
                }
                .scrollIndicators(.hidden)
                .simultaneousGesture(DragGesture().onChanged({ _ in }))
            }
        }
        .navigationBarHidden(true)
        .statusBarHidden(false)
    }
}

#Preview {
    MainHomeView()
}
