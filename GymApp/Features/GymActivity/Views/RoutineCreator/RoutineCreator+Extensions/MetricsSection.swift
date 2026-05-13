//
//  MetricsSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

extension RoutineCreatorView {
    
    var metricsSection: some View {
        widget.enhancedSectionView(
            title: StringConstants.routineWorkoutMetrics,
            icon: "chart.bar.fill",
            iconColor: .fitnessSuccess
        ) {
            VStack(spacing: 16) {
                widget.metricCard(
                    title: StringConstants.routineStimatedVolume,
                    value: String(format: "%.0f kg", vm.estimatedVolumeKg),
                    icon: "scalemass.fill",
                    color: .fitnessSuccess
                )
                
                HStack(spacing: 16) {
                    widget.metricCard(
                        title: StringConstants.routineTotalRepetitions,
                        value: "\(vm.totalReps)",
                        icon: "repeat",
                        color: .primaryFitnessBlue
                    )
                    
                    widget.metricCard(
                        title: StringConstants.routineTotalSeries,
                        value: "\(vm.gymActivity.totalSeriesCount)",
                        icon: "list.number",
                        color: .energyFitnessOrange
                    )
                }
            }
        }
    }
    
}
