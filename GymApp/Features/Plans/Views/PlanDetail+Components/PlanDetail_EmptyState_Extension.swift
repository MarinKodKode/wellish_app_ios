//
//  PlanDetail_EmptyState_Extension.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 29/12/25.
//

import SwiftUI

extension PlanDetailView {
    var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "figure.walk.circle")
                .font(.system(size: 64))
                .foregroundColor(Color(white: 0.3))
            Text("No activities yet")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color(white: 0.5))
            
            Text("Add activities to start your plan")
                .font(.system(size: 14))
                .foregroundColor(Color(white: 0.4))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .background(Color(red: 0.12, green: 0.14, blue: 0.19))
        .cornerRadius(16)
    }
}
