//
//  ExerciseDetailView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/10/25.
//

import SwiftUI

import SwiftUI
import AVKit // Necesario para VideoPlayer

struct ExerciseDetailView: View {
    let exercise: Exercise
    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header con imagen/video
                if exercise.videoURL != nil {
                    videoSection
                }
              
                // Contenido principal
                VStack(alignment: .leading, spacing: 24) {
                    // Título y categoría
                    titleSection
                    
                    // Información básica (músculos, equipo)
                    infoCardsSection
                    
//                    // Video de instrucciones (si existe)
//                    if exercise.videoUrl != nil {
//                        videoSection
//                    }
//                    
//                    // Instrucciones escritas
//                    if let instructions = exercise.instructions {
//                        instructionsSection(instructions.first ?? "")
//                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .ignoresSafeArea(edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                }
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            if let thumbnailString = exercise.thumbnailURL,
               let url = URL(string: thumbnailString) {

                AsyncImage(url: url) { phase in
                    switch phase {

                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()

                    case .failure(_):
                        placeholderImage

                    case .empty:
                        placeholderImage

                    @unknown default:
                        placeholderImage
                    }
                }

            } else {
                placeholderImage
            }
            
            // Gradient overlay
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 150)
        }
        .frame(height: 350)
    }
        
    private var placeholderImage: some View {
        ZStack {
            Color(red: 0.15, green: 0.18, blue: 0.25)
            Image(systemName: "figure.run")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))
        }
        .frame(height: 300)
    }
    
    // MARK: - Title Section
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(exercise.name)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                CategoryBadge(
                    category: .fuerza
                )
                
//                if let equipment = exercise.equipment {
//                    Text("• \(equipment)")
//                        .font(.system(size: 14))
//                        .foregroundColor(.gray)
//                }
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: - Info Cards Section
    private var infoCardsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Músculos Trabajados")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
            
            if exercise.primaryMuscles.isEmpty {
                Text("No especificado")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(exercise.primaryMuscles, id: \.self) { muscle in
                        MuscleTag(muscle: muscle.rawValue)
                    }
                }
            }
        }
    }
    
    // MARK: - Video Section
    private var videoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
//            Text("Video Tutorial")
//                .font(.system(size: 18, weight: .semibold))
//                .foregroundColor(.white)
            
            if let player = player {
                VideoPlayer(player: player)
                    .frame(height: 220)
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .padding(.top, 60)
            }
        }
    }
    
    // MARK: - Instructions Section
        private func instructionsSection(_ instructions: String) -> some View {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Image(systemName: "list.bullet.clipboard.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.blue)
                    Text("Cómo Realizar")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    ForEach(parseInstructions(instructions), id: \.number) { step in
                        InstructionStepCard(step: step)
                    }
                }
            }
        }
    private func parseInstructions(_ text: String) -> [InstructionStep] {
            let lines = text.components(separatedBy: .newlines)
            var steps: [InstructionStep] = []
            
            for line in lines {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty { continue }
                
                // Detectar si empieza con número
                if let firstChar = trimmed.first,
                   firstChar.isNumber,
                   let dotIndex = trimmed.firstIndex(of: ".") {
                    let numberStr = String(trimmed[..<dotIndex])
                    if let number = Int(numberStr) {
                        let textStart = trimmed.index(after: dotIndex)
                        let text = String(trimmed[textStart...]).trimmingCharacters(in: .whitespaces)
                        steps.append(InstructionStep(number: number, text: text))
                    }
                } else if !trimmed.isEmpty {
                    // Si no tiene número, agregarlo con el siguiente número
                    let nextNumber = (steps.last?.number ?? 0) + 1
                    steps.append(InstructionStep(number: nextNumber, text: trimmed))
                }
            }
            
            return steps
        }
    
    // MARK: - Helper Functions
    private func setupPlayer() {
        guard let videoUrl = exercise.thumbnailURL else { return }
//        player = AVPlayer(url: videoUrl)
    }
}

// MARK: - Supporting Views

struct CategoryBadge: View {
    let category: ExerciseCategory
    
    var body: some View {
        Text(category.rawValue)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(categoryColor)
            .cornerRadius(8)
    }
    
    private var categoryColor: Color {
        switch category {
        case .fuerza:
            return Color.blue.opacity(0.8)
        case .hiit:
            return Color.orange.opacity(0.8)
        case .cardio:
            return Color.green.opacity(0.8)
        default :
            return Color.blue.opacity(0.6)
        }
    }
}

struct MuscleTag: View {
    let muscle: String
    
    var body: some View {
        Text(muscle)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color.white.opacity(0.1))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}

// MARK: - Instruction Step
struct InstructionStep {
    let number: Int
    let text: String
}

struct InstructionStepCard: View {
    let step: InstructionStep
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Número del paso
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.8), Color.blue.opacity(0.4)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                
                Text("\(step.number)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // Texto de la instrucción
            Text(step.text)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(5)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 8)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.3), Color.blue.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
}
    
