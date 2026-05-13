//
//  PlanCreator+ConfigurationSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import SwiftUI


extension CreatePlanView {
    
    var PlanCreator_ConfigurationSection : some View {
        
        VStack(alignment: .leading, spacing: 16) {
//            HStack(spacing: 12) {
//                Image(systemName: "clock.fill")
//                    .font(.title2)
//                    .foregroundColor(.green)
//
//                Text("Configuración")
//                    .font(.title2)
//                    .fontWeight(.semibold)
//            }
//            .padding(.horizontal)
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Duración (semanas)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Button {
                            if vm.plan.durationWeeks > 1 {
                                vm.plan.durationWeeks -= 1
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                        
                        Text("\(vm.plan.durationWeeks)")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            vm.plan.durationWeeks += 1
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title2)
                                .foregroundColor(.green)
                        }
                    }
                }
                
//                Divider()
//                    .background(Color.white.opacity(0.1))
//                
//                // Activities per week
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Actividades por semana")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                    
//                    HStack {
//                        Button {
//                            if vm.plan.activitiesPerWeek > 1 {
//                                vm.plan.activitiesPerWeek -= 1
//                            }
//                        } label: {
//                            Image(systemName: "minus.circle.fill")
//                                .font(.title2)
//                                .foregroundColor(.green)
//                        }
//                        
//                        Text("\(vm.plan.activitiesPerWeek)")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .frame(maxWidth: .infinity)
//                        
//                        Button {
//                            vm.plan.activitiesPerWeek += 1
//                        } label: {
//                            Image(systemName: "plus.circle.fill")
//                                .font(.title2)
//                                .foregroundColor(.green)
//                        }
//                    }
//                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "1E293B").opacity(0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
            .padding(.horizontal)
        }
    }
}
