//
//  ExercisePickerView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

struct ExercisePickerView: View {
    var onSelect: (Exercise) -> Void

    @StateObject private var vm = GymActivityViewModel()
    
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary.ignoresSafeArea()
                
                List(vm.exerciseLibrary) { ex in
                    Button(action: {
                        onSelect(ex)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack(spacing: 16) {
                            Image(systemName: "dumbbell")
                                .font(.title2)
                                .foregroundColor(.primaryFitnessBlue)
                                .frame(width: 40, height: 40)
                                .background(Color.primaryFitnessBlue.opacity(0.1))
                                .cornerRadius(10)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(ex.name)
                                    .font(.headline)
                                    .foregroundColor(.fitnessTextPrimary)
                                
//                                if let category = ex.category {
//                                    Text(category.rawValue)
//                                        .font(.caption)
//                                        .foregroundColor(.fitnessTextSecondary)
//                                }
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.fitnessTextSecondary)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal , 8)
                    }
                    .listRowBackground(Color.fitnessBackgroundSecondary)
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal , 8)
            }
            .navigationTitle("Elige tu ejercicio")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.primaryFitnessBlue)
                }
            }
            .task {
                await vm.fetchExerciseLibrary()
                print(vm.exerciseLibrary)
            }
        }
    }
}

#Preview {
    
    var showingExercisePicker = true
    let vm = GymActivityViewModel()
    
    ExercisePickerView { exercise in
        showingExercisePicker = true
        vm.addSet(with: exercise)
    }
}
