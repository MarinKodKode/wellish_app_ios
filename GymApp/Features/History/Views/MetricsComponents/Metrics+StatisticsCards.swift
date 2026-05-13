
import SwiftUI

struct Metrics_StatisticsCard : View {
    
    @ObservedObject var vm = MetricsHistoryViewModel()
    let title : String
    
    @State private var selectedFilter = "Semana"
    let options = ["Semana", "Mes", "Año"]
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.fitnessTextPrimary)
                Spacer()
                Menu {
                    Picker("Periodo",selection : $selectedFilter){
                        ForEach(options, id : \.self){ option in
                            Text(option).tag(option)
                        }
                    }
                } label: {
                    Label("\(selectedFilter)", systemImage: "calendar")
                        .frame(
                            width: UIScreen.screenWidth * 0.24,
                            alignment: .trailing
                        )
                        .padding(.trailing, 8)
                }
                .frame(
                    width: UIScreen.screenWidth * 0.20 ,
                    alignment: .trailing
                )
            }
            .padding(.horizontal, 16)
            
            if vm.completedActivitiesLoaded {
                Metrics_StatisticsCardSkeleton()
            }else{
                VStack(alignment: .trailing){
                    
                    statistics
                        .padding(.top, 12)
                }
            }
        }
    }
    
    var statistics : some View {
        VStack{
            HStack {
                StatisticCardWidget(
                    icon: "flame",
                    label: "Rutinas",
                    unit: "completadas",
                    statisticValue: "\(vm.completedSessions)",
                    color: .energyFitnessOrange
                )
                
                Spacer()
                
                StatisticCardWidget(
                    icon: "clock",
                    label: "Tiempo",
                    unit: "Horas",
                    statisticValue: "\(vm.totalTimeTraining)",
                    color: .primaryBlue
                )
            }
            .padding(.horizontal, 16)
            
            
            HStack {
                StatisticCardWidget(
                    icon: "flame",
                    label: "Calorias",
                    unit: "quemadas",
                    statisticValue: "\(vm.completedSessions)",
                    color: .fitnessInfo
                )
                
                Spacer()
                
                StatisticCardWidget(
                    icon: "clock",
                    label: "Ejercicios",
                    unit: "realizados",
                    statisticValue: "\(vm.totalTimeTraining)",
                    color: .fitnessSuccess
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
        
    }
}



