//
//  Metrics+CaloriesChartView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 31/10/25.
//

import SwiftUI

struct Metrics_CaloriesChartView: View {
    
    @ObservedObject var vm = MetricsHistoryViewModel()
    @State var tapped : Bool = false
    let title : String
    
    init(tapped: Bool, title: String) {
        self.tapped = tapped
        self.title = title
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    HStack(spacing: 8) {
                        Text(title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.fitnessTextPrimary)
                    }
                    Spacer()
                }
                
                VStack(spacing: 16) {
                    HStack(alignment: .bottom, spacing: 8) {
                        //                        ForEach(Array(activityData.caloriesData.enumerated()), id: \.offset) { index, data in
                        ForEach(1..<8){_ in
//                            MetricBarWidgetView(
//                                label: "Mon",
//                                value: 450,
//                                highlighted: $tapped
//                            )
//                            MonthCaloriesCard_Widget()
                        }
                    }
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                            Text("\(vm.totalCaloriesBurned)")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(
                                colors: [.fitnessWarning, .fitnessWarning.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(12)
                        Spacer()
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [ .backgroundPrimary.opacity(0.5), .fitnessInfo.opacity(0.2), .backgroundPrimary.opacity(0.7)]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.fitnessTextSecondary.opacity(0.1), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    Metrics_CaloriesChartView(tapped: true, title : "Estadisticas")
}


struct MetricBarWidgetView : View {
    
    let label : String
    let value : CGFloat
    
    @Binding var highlighted : Bool
        
    init(label: String, value: CGFloat, highlighted: Binding<Bool>) {
        self.label = label
        self.value = value
        self._highlighted = highlighted
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.fitnessTextSecondary.opacity(0.2))
                    .frame(height: 120)

                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .fill(highlighted ?
                              LinearGradient(colors: [.fitnessWarning, .fitnessWarning.opacity(0.8)], startPoint: .top, endPoint: .bottom) :
                              LinearGradient(colors: [.fitnessPrimary, .fitnessPrimary.opacity(0.6)], startPoint: .top, endPoint: .bottom))
                        .frame(height: value / 10)
                }
            }
            .frame(width: 32)

            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(
                    highlighted ? .fitnessWarning : .fitnessTextSecondary
                )
        }
    }
}
