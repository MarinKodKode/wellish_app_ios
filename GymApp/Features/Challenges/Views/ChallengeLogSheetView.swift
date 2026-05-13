//
//  ChallengeLogSheetView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 20/11/25.
//

import SwiftUI

// MARK: - Challenge Log Sheet

struct ChallengeLogSheet: View {
    
    let challenge: BaseChallenge
    @ObservedObject var viewModel: ChallengesViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var inputValue: Int
    @State private var showHistory = false
    
    init(challenge: BaseChallenge, viewModel: ChallengesViewModel) {
        self.challenge = challenge
        self.viewModel = viewModel
        _inputValue = State(initialValue: challenge.currentValue)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Header Card
                    headerCard
                    
                    // Quick Actions
                    quickActionsSection
                    
                    // Manual Input
                    manualInputSection
                    
                    // History Preview
                    historyPreviewSection
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle(challenge.subtitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showHistory = true
                    } label: {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .sheet(isPresented: $showHistory) {
                ChallengeHistoryView(
                    challenge: challenge,
                    viewModel: viewModel
                )
            }
        }
    }
    
    // MARK: - Header Card
    
    private var headerCard: some View {
        VStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(challenge.color.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                Image(systemName: challenge.icon)
                    .font(.system(size: 36))
                    .foregroundColor(challenge.color)
            }
            
            // Progress
            VStack(spacing: 8) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(inputValue)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                    
                    Text("/ \(challenge.goalValue)")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    
                    Text(challenge.unit)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                // Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 12)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(challenge.color)
                            .frame(
                                width: geometry.size.width * min(Double(inputValue) / Double(challenge.goalValue), 1.0),
                                height: 12
                            )
                            .animation(.spring(), value: inputValue)
                    }
                }
                .frame(height: 12)
                
                Text("\(Int((Double(inputValue) / Double(challenge.goalValue)) * 100))% completado")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Completion Badge
            if inputValue >= challenge.goalValue {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    
                    Text("¡Reto completado!")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.green.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
    }
    
    // MARK: - Quick Actions
    
    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Acciones Rápidas")
                .font(.headline)
            
            HStack(spacing: 12) {
                QuickActionButton(
                    icon: "minus.circle.fill",
                    title: "-1",
                    color: .red
                ) {
                    if inputValue > 0 {
                        inputValue -= 1
                        viewModel.decrementChallenge(challenge, by: 1)
                    }
                }
                
                QuickActionButton(
                    icon: "plus.circle.fill",
                    title: "+1",
                    color: challenge.color
                ) {
                    inputValue += 1
                    viewModel.incrementChallenge(challenge, by: 1)
                }
                
                QuickActionButton(
                    icon: "goforward.plus",
                    title: "+5",
                    color: challenge.color
                ) {
                    inputValue += 5
                    viewModel.incrementChallenge(challenge, by: 5)
                }
                
                QuickActionButton(
                    icon: "arrow.counterclockwise",
                    title: "Reset",
                    color: .orange
                ) {
                    inputValue = 0
                    viewModel.resetChallenge(challenge)
                }
            }
        }
    }
    
    // MARK: - Manual Input
    
    private var manualInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingresar Valor Manual")
                .font(.headline)
            
            VStack(spacing: 16) {
                // Stepper
                Stepper(value: $inputValue, in: 0...(challenge.goalValue * 2)) {
                    HStack {
                        Text("Valor actual:")
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(inputValue) \(challenge.unit)")
                            .font(.headline)
                    }
                }
                
                // Save Button
                Button {
                    viewModel.setChallenge(challenge, value: inputValue)
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Guardar Progreso")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(challenge.color)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
        }
    }
    
    // MARK: - History Preview
    
    private var historyPreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Últimos 7 días")
                    .font(.headline)
                
                Spacer()
                
                Button("Ver todo") {
                    showHistory = true
                }
                .font(.caption)
                .foregroundColor(challenge.color)
            }
            
            let history = viewModel.getHistory(for: challenge, last: 7)
            
            if history.isEmpty {
                Text("Sin historial aún")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(history) { entry in
                            MiniHistoryCard(entry: entry, color: challenge.color)
                        }
                    }
                }
            }
        }
    }
}
