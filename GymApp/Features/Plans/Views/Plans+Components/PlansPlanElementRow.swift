//
//  PlansPlanElementRow.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 27/10/25.
//

import SwiftUI

struct PlansPlanElementRow : View {
    let plan : Plan

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(.title2)
                .foregroundColor(.primaryFitnessBlue)

            VStack(alignment: .leading, spacing: 4) {
                Text(plan.name)
                    .font(.headline)
                    .foregroundColor(.fitnessTextPrimary)
                Text("\(self.plan.elements.count) routines · \(plan.goal)")
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.fitnessTextSecondary)
        }
        .padding(.horizontal)
        .frame(height: 60)
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(12)
        .padding(.horizontal, 4)
    }
}
