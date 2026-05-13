//
//  GymLiveTracker+ProgressCardView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_ProgressCardView: View {
        let completedSets: Int
        let totalSets: Int
        let progress: Double
        
        var body: some View {
            VStack(spacing: 12) {
                HStack {
                    HStack(spacing: 6) {
                        Image(systemName: "target")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.6, green: 0.4, blue: 0.9))
                        Text("Progreso total")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(completedSets)/\(totalSets) sets")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(red: 0.2, green: 0.22, blue: 0.3))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 6)
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.9, green: 0.3, blue: 0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geometry.size.width * progress, height: 8)
                            .animation(.spring(), value: progress)
                    }
                }
                .frame(height: 8)
            }
            .padding(16)
            .background(Color(red: 0.12, green: 0.14, blue: 0.22))
            .cornerRadius(20)
        }
    }

#Preview {
    GymLiveTracker_ProgressCardView(completedSets: 12, totalSets: 15, progress: 0.8)
}
