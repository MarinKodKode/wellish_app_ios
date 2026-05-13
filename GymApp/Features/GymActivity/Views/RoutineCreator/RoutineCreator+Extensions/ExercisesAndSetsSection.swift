//
//  ExercisesAndSetsSection.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

extension RoutineCreatorView {
    
    var exercisesAndSetsSection: some View {
        widget.enhancedSectionView(
            title: StringConstants.routineExercisesAndSets,
            icon: "figure.strengthtraining.traditional",
            iconColor: .energyFitnessOrange
        ) {
            VStack(spacing: 16) {
                if vm.gymActivity.sets.isEmpty {
                    EmptyStateView()
                } else {
                    ForEach(Array(vm.gymActivity.sets.enumerated()), id: \.element.id) { index, _ in
                        EnhancedRoutineSetRowView(
                            set: $vm.gymActivity.sets[index],
                            onAddSerie: { vm.addSerie(toSetAt: index) },
                            onRemove: { vm.removeSet(at: index) },
                            onEditSeria: { serieIndex, serie in
                                vm.updateSerie(serie, at: serieIndex, inSet: index)
                            }
                            
                        )
                    }
                    
                }
                Button(action: { showingExercisePicker = true }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(StringConstants.routineAddAnExercise)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text(
                                StringConstants.routineChooseExerciseFromLibrary
                            )
                                .font(.caption)
                                .opacity(0.8)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .font(.caption)
                            .opacity(0.6)
                    }
                    .foregroundColor(.white)
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [.primaryFitnessBlue, .primaryFitnessBlue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }
}
