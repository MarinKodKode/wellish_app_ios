//
//  GymLiveTracker+StatBox.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_StatBox: View {
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(Color(red: 0.15, green: 0.17, blue: 0.25))
        .cornerRadius(12)
    }
}

#Preview {
    GymLiveTracker_StatBox(
        value: "750",
        label: "Calories",
        color: Color.fitnessSuccess
    )
}
