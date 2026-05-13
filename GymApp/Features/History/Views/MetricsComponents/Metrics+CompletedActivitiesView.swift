//
//  Metrics+CompletedActivitiesView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 31/10/25.
//

import SwiftUI

struct Metrics_CompletedActivitiesView : View {
    
    @EnvironmentObject  var navigatorRouter : NavigationRouter
    @ObservedObject var vm = MetricsHistoryViewModel()
    
    @State private var selectedFilter = "Semana"
    let options = ["Semana", "Mes", "Año"]
    
    let title : String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        Group {
            if !vm.completedActivitiesLoaded {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        HStack(spacing: 8) {
                            Text(title)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.fitnessTextPrimary)
                        }
                        Spacer()
                    }
                    .padding(.top, 16)
                    
                    ForEach(0..<3 , id : \.self){ _ in
                        CompletedActivityCardSkeleton()
                    }
                }
                .padding(.horizontal, 16)
            }else {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
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
                            }
                            .frame(
                                width: UIScreen.screenWidth * 0.20 ,
                                alignment: .trailing
                            )
                        }
                        Spacer()
                    }
                    VStack(spacing: 16) {
                        ForEach(vm.completedActivities) { activity  in
                            CompletedActivityCard(activity: activity)
                                .onTapGesture {
                                    navigatorRouter.goTo(.summaryDay)
                                }
                        }
                    }
                    .padding(.top, 12)
                }
                .padding(.horizontal, 16)
            }
        }
        .task {
            await vm.initView()
        }
    }
    
}

