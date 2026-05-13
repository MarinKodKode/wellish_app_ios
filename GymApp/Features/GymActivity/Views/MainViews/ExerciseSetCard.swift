//
//  ExerciseSetCard.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/10/25.
//

import SwiftUI

struct ExerciseSetCard: View {
    let set: RoutineSet
    let index: Int
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Button(action: {
                    navigationRouter
                        .goTo(.exerciseDetail(Exercise.example))
                }, label: {
                    Text(set.exerciseName)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                })
                
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "timer")
                        .font(.system(size: 12))
                        .foregroundColor(.orange)
                    Text("\(set.restBetweenSeriesSeconds)s rest")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.2))
                .cornerRadius(6)
            }
            
            // Series - **USO DE LA VISTA SEPARADA**
            VStack(spacing: 8) {
                ForEach(Array(set.series.enumerated()), id: \.element.id) { seriesIndex, series in
                    SeriesRowView(series: series, seriesIndex: seriesIndex) // ¡Simplificación aquí!
                }
            }
            
            // Set Stats
            HStack(spacing: 16) {
                HStack(spacing: 4) {
                    Image(systemName: "number")
                        .font(.system(size: 11))
                        .foregroundColor(Color(white: 0.5))
                    Text("\(set.series.count) sets")
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.6))
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 11))
                        .foregroundColor(Color(white: 0.5))
                    Text("\(set.totalReps) total reps")
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.6))
                }
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "scalemass.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.purple)
                    Text("\(String(format: "%.1f", set.estimatedVolumeKg)) kg")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.purple)
                }
            }
        }
        .padding(16)
        .background(Color(red: 0.12, green: 0.14, blue: 0.19))
        .cornerRadius(16)
    }
}

struct SeriesRowView: View {
    let series: Serie
    let seriesIndex: Int // El índice de la serie
    
    var body: some View {
        HStack(spacing: 12) {
            // Número de Serie
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 32, height: 32)
                Text("\(seriesIndex + 1)")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
            }
            
            // Repeticiones (Reps)
            HStack(spacing: 4) {
                Image(systemName: "repeat")
                    .font(.system(size: 12))
                    .foregroundColor(Color(white: 0.6))
                Text("\(series.repetitions) reps")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Peso (Weight) - Condicional
            if let weight = series.idealWeightKg {
                HStack(spacing: 4) {
                    Image(systemName: "scalemass")
                        .font(.system(size: 12))
                        .foregroundColor(Color(white: 0.6))
                    Text("\(String(format: "%.1f", weight)) kg")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Volumen
            Text("\(String(format: "%.1f", series.estimatedVolumeKg)) kg")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.purple)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.purple.opacity(0.2))
                .cornerRadius(6)
        }
        .padding(10)
        .background(Color(white: 0.08))
        .cornerRadius(10)
    }
}
