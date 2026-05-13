//
//  PlanCreator+GoalSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 16/10/25.
//

import SwiftUI

extension CreatePlanView{
    
    var PlanCreator_GoalSection: some View {
        
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: "target")
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text("Objetivo")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .padding(.horizontal)
            
            Button {
                showGoalPicker = true
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: vm.plan.goal.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color(vm.plan.goal.color))
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(vm.plan.goal.displayName)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(vm.plan.goal.description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
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
            }
            .padding(.horizontal)
        }
    }
}
