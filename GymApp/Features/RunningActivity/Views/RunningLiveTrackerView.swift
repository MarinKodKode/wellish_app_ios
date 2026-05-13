//
//  RunningLiveTrackerView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 11/12/25.
//

import Foundation
import SwiftUI
import MapKit

struct RunningTrackerView: View {
    @State private var isRunning = false
    @State private var isPaused = false
    @State private var isTreadmill = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var distance: Double = 0
    @State private var calories: Int = 0
    @State private var showDetails = false
    
    @State private var comments = ""
    @State private var weather = "Soleado"
    @State private var terrain = "Asfalto"
    @State private var difficulty = "Moderado"
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.0414, longitude: -98.2063),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    let weatherOptions = ["Soleado", "Nublado", "Lluvia", "Viento", "Caluroso", "Frío"]
    let terrainOptions = ["Asfalto", "Tierra", "Pista", "Montaña", "Parque", "Playa"]
    let difficultyOptions = ["Fácil", "Moderado", "Difícil", "Muy Difícil"]
    
    var pace: String {
        guard distance > 0 else { return "0:00" }
        let paceSeconds = (elapsedTime / 60) / distance
        let minutes = Int(paceSeconds)
        let seconds = Int((paceSeconds - Double(minutes)) * 60)
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    var body: some View {
        ZStack {
            Color(.backgroundPrimary)
            
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Text("Seguimiento de Carrera")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        Spacer()
                        Button(action: { showDetails.toggle() }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 24))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Modo: Exterior / Caminadora
                    HStack(spacing: 12) {
                        ModeButton(
                            title: "Exterior",
                            icon: "figure.run",
                            isSelected: !isTreadmill,
                            action: { isTreadmill = false }
                        )
                        ModeButton(
                            title: "Caminadora",
                            icon: "figure.indoor.walk",
                            isSelected: isTreadmill,
                            action: { isTreadmill = true }
                        )
                    }
                    .padding(.horizontal, 20)
                    
                    // Mapa (solo si es exterior)
                    if !isTreadmill {
                        Map(coordinateRegion: $region, showsUserLocation: true)
                            .frame(height: 300)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                    }
                    
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            StatCardex(
                                icon: "timer",
                                title: "Tiempo",
                                value: formatTime(elapsedTime),
                                color: .blue
                            )
                            StatCardex(
                                icon: "location.fill",
                                title: "Distancia",
                                value: String(format: "%.2f km", distance),
                                color: .green
                            )
                        }
                        
                        HStack(spacing: 12) {
                            StatCardex(
                                icon: "speedometer",
                                title: "Pace",
                                value: "\(pace) /km",
                                color: .orange
                            )
                            StatCardex(
                                icon: "flame.fill",
                                title: "Calorías",
                                value: "\(calories) kcal",
                                color: .red
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Controles
                    HStack(spacing: 20) {
                        if !isRunning {
                            Button(action: startRun) {
                                HStack {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 20))
                                    Text("Iniciar")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [Color.green, Color.green.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                            }
                        } else {
                            Button(action: togglePause) {
                                HStack {
                                    Image(systemName: isPaused ? "play.fill" : "pause.fill")
                                        .font(.system(size: 20))
                                    Text(isPaused ? "Reanudar" : "Pausar")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [Color.orange, Color.orange.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                            }
                            
                            Button(action: stopRun) {
                                HStack {
                                    Image(systemName: "stop.fill")
                                        .font(.system(size: 20))
                                    Text("Finalizar")
                                        .font(.system(size: 18, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [Color.red, Color.red.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Detalles adicionales
                    if showDetails {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Detalles de la Carrera")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.top, 8)
                            
                            // Clima
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Clima")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(weatherOptions, id: \.self) { option in
                                            ChipButton(
                                                title: option,
                                                isSelected: weather == option,
                                                action: { weather = option }
                                            )
                                        }
                                    }
                                }
                            }
                            
                            // Tipo de suelo
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tipo de Suelo")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 10) {
                                        ForEach(terrainOptions, id: \.self) { option in
                                            ChipButton(
                                                title: option,
                                                isSelected: terrain == option,
                                                action: { terrain = option }
                                            )
                                        }
                                    }
                                }
                            }
                            
                            // Dificultad
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Dificultad")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                                HStack(spacing: 10) {
                                    ForEach(difficultyOptions, id: \.self) { option in
                                        ChipButton(
                                            title: option,
                                            isSelected: difficulty == option,
                                            action: { difficulty = option }
                                        )
                                    }
                                }
                            }
                            
                            // Comentarios
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comentarios")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.secondary)
                                TextEditor(text: $comments)
                                    .frame(height: 100)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        }
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func startRun() {
        isRunning = true
        // Aquí iría la lógica para iniciar el tracking
        // Timer, GPS, etc.
        simulateRun()
    }
    
    func togglePause() {
        isPaused.toggle()
    }
    
    func stopRun() {
        isRunning = false
        isPaused = false
        // Aquí iría la lógica para guardar la carrera
    }
    
    func simulateRun() {
        // Simulación para el preview
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if isRunning && !isPaused {
                elapsedTime += 1
                distance += 0.002 // ~7.2 km/h
                calories = Int(distance * 60) // Aproximación
            }
            if !isRunning {
                timer.invalidate()
            }
        }
    }
}

struct ModeButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                isSelected
                    ? LinearGradient(
                        colors: [Color.blue, Color.blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                : LinearGradient(
                    colors: [Color.backgroundPrimary, Color.backgroundPrimary.opacity(0.4)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(isSelected ? 0.1 : 0.05), radius: 4, x: 0, y: 2)
        }
    }
}

struct StatCardex: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundSecondary)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

struct ChipButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.15))
                .cornerRadius(20)
        }
    }
}

#Preview {
    RunningTrackerView()
}
