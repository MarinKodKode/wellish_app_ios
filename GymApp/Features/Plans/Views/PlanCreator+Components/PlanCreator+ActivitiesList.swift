//
//  PlanCreator+ActivitiesList.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 17/10/25.
//

import SwiftUI

extension CreatePlanView {
    
    var PlanCreator_ActivitiesList : some View {
        VStack(spacing: 12) {
            ForEach(Array(vm.plan.elements.enumerated()), id: \.element.id) { index, element in
                HStack(spacing: 12) {
                    Image(systemName: element.icon)
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .cornerRadius(10)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Día \(element.day)")
                            .font(.headline)
                        Text(element.displayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button {
                        vm.plan.removeElement(at: index)
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "1E293B").opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                        )
                )
            }
        }
        .padding(.horizontal)
    }
}
