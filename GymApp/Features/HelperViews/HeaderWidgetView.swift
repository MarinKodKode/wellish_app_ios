//
//  HeaderWidgetView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 31/10/25.
//

import SwiftUI

struct HeaderWidgetView: View {
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(StringConstants.plansCustomYourOwnPlan)
                    .font(.system(size : 20))
                    .foregroundColor(.fitnessTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, -5)
                Spacer()
//                Button(action: {}) {
//                    Image(systemName: "questionmark.circle.fill")
//                        .font(.system(size: 22))
//                        .foregroundColor(.fitnessInfo)
//                }
//                .padding(.top, -4)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    HeaderWidgetView()
}
