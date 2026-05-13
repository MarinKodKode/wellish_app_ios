//
//  RoutinePlans.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 12/08/25.
//

import SwiftUI

struct PlansView: View {
    
    @StateObject var vm: GymActivityViewModel
    @StateObject var plansVM: PlansViewViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        
                        headerSection
                        
                        PopularPlansSection(plans: plansVM.globalPlans)
                            .onAppear{
                                Task {
                                    print("Planes : \(plansVM.globalPlans)")
                                }
                            }

                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(StringConstants.plansMyPlans)
                                    .font(.title2.bold())
                                    .foregroundColor(.fitnessTextPrimary)
                                Spacer()
                                Button(action: {
                                    navigationRouter.goTo(.createPlan)
                                }){
                                    Text(StringConstants.plansAddNewPlan)
                                }
                            }
                            .padding(.horizontal)

                            if plansVM.myPlans.isEmpty  {
                                Text("Aún no tienes planes")
                                    .foregroundColor(.fitnessTextSecondary)
                                    .italic()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                ForEach(self.plansVM.myPlans) { plan in
                                    Button(action: {
                                        navigationRouter.goTo(.planDetail(plan))
                                    }, label: {
                                        InformationComponentRow(plan : plan)
                                    })
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.bottom)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(StringConstants.plansMyRoutines)
                                    .font(.title2.bold())
                                    .foregroundColor(.fitnessTextPrimary)
                                Spacer()
                                Button(action: {
                                    navigationRouter.goTo(.createRoutine)
                                }){
                                    Text(StringConstants.createRoutine)
                                }
                            }
                            .padding(.horizontal)

                            if $plansVM.myRoutines.isEmpty {
                                Text("Aún no tienes rutinas")
                                    .foregroundColor(.fitnessTextSecondary)
                                    .italic()
                                    .frame(maxWidth: .infinity)
                                    .padding()
                            } else {
                                ForEach(self.plansVM.myRoutines) { routine in
                                    Button(action: {
                                        navigationRouter.goTo(.gymActivityDetail(routine))
                                    }, label: {
                                        InformationRoutineRowView(routine: routine)
                                    })
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.bottom)
                    }
                    .padding(.top)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarTitle("Planes")
            .onAppear{
                plansVM.initView()
            }
        }
    }
}
