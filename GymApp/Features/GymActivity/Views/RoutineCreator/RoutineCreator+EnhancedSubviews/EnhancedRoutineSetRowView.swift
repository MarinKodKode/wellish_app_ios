import SwiftUI

struct EnhancedRoutineSetRowView: View {
    @Binding var set: RoutineSet
    var onAddSerie: () -> Void
    var onRemove: () -> Void
    var onEditSeria: (_ serieIndex: Int, _ serie: Serie) -> Void
    
    @State private var expanded = false
    @State private var dropSetEnabled = false
    @State private var dropSetPercentage: Double = 20.0
    @State private var numberOfSeries: Int = 3

    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    expanded.toggle()
                }
            }) {
                HStack(spacing: 16) {
                    // Exercise Icon & Info
                    VStack(spacing: 8) {
                        Image(systemName: "dumbbell")
                            .font(.title2)
                            .foregroundColor(.energyFitnessOrange)
                            .frame(width: 40, height: 40)
                            .background(Color.energyFitnessOrange.opacity(0.1))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(set.exerciseName)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.fitnessTextPrimary)
                        
//                        if let equipment = set.exercise.equipment, !equipment.isEmpty {
//                            Text(equipment)
//                                .font(.caption)
//                                .foregroundColor(.fitnessTextSecondary)
//                        }
                    }
                    
                    Spacer()
                    
                    // Stats
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(set.series.count) series")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.fitnessTextPrimary)
                        
                        Text(String(format: "%.0f kg", set.estimatedVolumeKg))
                            .font(.caption)
                            .foregroundColor(.fitnessSuccess)
                    }
                    
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.fitnessTextSecondary)
                        .font(.subheadline)
                        .rotationEffect(.degrees(expanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: expanded)
                }
                .padding(.vertical, 20)
            }
            .buttonStyle(PlainButtonStyle())

            if expanded {
                VStack(spacing: 16) {
                    Divider()
                        .background(Color.fitnessTextSecondary.opacity(0.2))
                    
                    // Enhanced Series Configuration
                    VStack(spacing: 20) {
                        // Number of Series Selector
                        HStack(spacing: 16) {
                            Image(systemName: "list.number")
                                .font(.title2)
                                .foregroundColor(.primaryFitnessBlue)
                                .frame(width: 30)
                            
                            HStack(alignment: .center, spacing: 4) {
                                Text("Series")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.fitnessTextPrimary)
                                Spacer()
                                HStack(spacing: 12) {
                                    Button(action: {
                                        withAnimation(.bouncy(duration: 0.3)) {
                                            if numberOfSeries > 1 { numberOfSeries -= 1 }
                                        }
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.errorFitnessRed)
                                    }
                                    .disabled(numberOfSeries <= 1)
                                    
                                    Text("\(numberOfSeries)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.fitnessTextPrimary)
                                        .frame(minWidth: 30)
                                    
                                    Button(action: {
                                        withAnimation(.bouncy(duration: 0.3)) {
                                            numberOfSeries += 1
                                        }
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.fitnessSuccess)
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(12)
                        .background(Color.fitnessBackgroundPrimary)
                        .cornerRadius(12)
                        
                        // Drop Set Configuration
                        HStack(spacing: 16) {
                            Image(systemName: "arrow.down.circle")
                                .font(.title2)
                                .foregroundColor(dropSetEnabled ? .energyFitnessOrange : .fitnessTextSecondary)
                                .frame(width: 30)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Drop Set")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.fitnessTextPrimary)
                                    
                                    Spacer()
                                    
                                    Toggle("", isOn: $dropSetEnabled)
                                        .toggleStyle(SwitchToggleStyle(tint: .energyFitnessOrange))
                                }
                                
                                if dropSetEnabled {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Weight reduction: \(Int(dropSetPercentage))%")
                                            .font(.caption)
                                            .foregroundColor(.fitnessTextSecondary)
                                        
                                        Slider(value: $dropSetPercentage, in: 10...50, step: 5)
                                            .tint(.energyFitnessOrange)
                                    }
                                    .transition(.asymmetric(
                                        insertion: .opacity.combined(with: .move(edge: .top)).combined(with: .scale(scale: 0.95)),
                                        removal: .opacity.combined(with: .move(edge: .top)).combined(with: .scale(scale: 0.95))
                                    ))
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.fitnessBackgroundPrimary)
                        .cornerRadius(12)
                        .animation(.easeInOut(duration: 0.3), value: dropSetEnabled)
                    }
                    
                    VStack(spacing: 12) {
                        ForEach($set.series) { $serie in
                            EnhancedSerieRowView(serie: $serie) {
                                if let index = set.series.firstIndex(where: { $0.id == serie.id }) {
                                    set.series.remove(at: index)
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: onRemove) {
                            HStack(spacing: 8) {
                                Image(systemName: "trash")
                                Text("Remove")
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.errorFitnessRed)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.errorFitnessRed.opacity(0.1))
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                expanded = false
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle")
                                Text("Done")
                            }
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.fitnessSuccess)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.fitnessSuccess.opacity(0.1))
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.bottom, 16)
//                .transition(.asymmetric(
//                    insertion: .opacity.combined(with: .move(edge: .top)).combined(with: .scale(scale: 0.95)),
//                    removal: .opacity.combined(with: .move(edge: .top)).combined(with: .scale(scale: 0.95))
//                ))
                .transition(.opacity)
            }
        }
        .background(Color.fitnessBackgroundSecondary)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: 2)
        .animation(.easeInOut(duration: 0.3), value: expanded)
    }
}
