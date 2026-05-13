//
//  PlansHeaderSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 04/09/25.
//

import SwiftUI

extension PlansView {
    
    var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text(StringConstants.plansCustomYourOwnPlan)
                    .font(.system(size : 20))
                    .foregroundColor(.fitnessTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, -5)
                Spacer()
                Button(action: {}) {
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.energyOrange)
                }
                .padding(.top, -4)
            }
            .padding(.horizontal, 20)
        }
    }
}
