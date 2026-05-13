
import SwiftUI

struct MetricsView: View {
    
    @ObservedObject var vm = MetricsHistoryViewModel()
    
    @Binding var showWorkoutTimer: Bool

    let plans = PlanDataset().getPlans()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
//                        HeaderWidgetView()
//                            .padding(.top, 20)
                        
                        Metrics_StatisticsCard(title: "Resumen")
                            .padding(.top, 20)
                        
//                        Metrics_CaloriesChartView(tapped: false , title: "Estadisticas")
                        
                        Metrics_CompletedActivitiesView(title : "Actividades completadas")
                            .padding(.top, 24)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitle(StringConstants.metricsTitle)
        }
        .navigationBarHidden(true)
    }
}
