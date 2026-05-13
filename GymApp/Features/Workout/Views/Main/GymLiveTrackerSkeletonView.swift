//
//  GymLiveTrackerSkeletonView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 21/11/25.
//

import SwiftUI

struct GymLiveTrackerSkeletonView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Color.fitnessBackgroundPrimary.ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    // Header Skeleton
                    VStack(spacing: 8) {
                        SkeletonBox(width: 200, height: 24)
                        SkeletonBox(width: 80, height: 16)
                    }
                    .padding(.vertical, 12)
                    
                    // Progress Card Skeleton
                    VStack(spacing: 12) {
                        HStack {
                            SkeletonBox(width: 100, height: 14)
                            Spacer()
                            SkeletonBox(width: 60, height: 14)
                        }
                        SkeletonBox(height: 8)
                            .clipShape(Capsule())
                    }
                    .padding()
                    .background(Color(red: 0.15, green: 0.17, blue: 0.25))
                    .cornerRadius(16)
                    
                    // Metrics Skeleton
                    HStack(spacing: 12) {
                        ForEach(0..<3) { _ in
                            VStack(spacing: 8) {
                                SkeletonBox(width: 40, height: 40)
                                    .clipShape(Circle())
                                SkeletonBox(width: 50, height: 12)
                                SkeletonBox(width: 70, height: 10)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.15, green: 0.17, blue: 0.25))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Current Exercise Card Skeleton
                    VStack(spacing: 16) {
                        HStack {
                            SkeletonBox(width: 60, height: 60)
                                .cornerRadius(12)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                SkeletonBox(width: 150, height: 18)
                                SkeletonBox(width: 100, height: 14)
                            }
                            Spacer()
                        }
                        
                        HStack(spacing: 16) {
                            ForEach(0..<3) { _ in
                                SkeletonBox(width: 60, height: 36)
                                    .cornerRadius(8)
                            }
                        }
                        
                        SkeletonBox(height: 50)
                            .cornerRadius(12)
                    }
                    .padding()
                    .background(Color(red: 0.15, green: 0.17, blue: 0.25))
                    .cornerRadius(16)
                    
                    // Exercise List Skeleton
                    VStack(spacing: 12) {
                        ForEach(0..<3) { _ in
                            HStack(spacing: 12) {
                                SkeletonBox(width: 50, height: 50)
                                    .cornerRadius(8)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    SkeletonBox(width: 120, height: 14)
                                    SkeletonBox(width: 80, height: 12)
                                }
                                Spacer()
                                
                                SkeletonBox(width: 24, height: 24)
                                    .clipShape(Circle())
                            }
                            .padding()
                            .background(Color(red: 0.15, green: 0.17, blue: 0.25))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Skeleton Box Component
struct SkeletonBox: View {
    var width: CGFloat? = nil
    var height: CGFloat = 20
    
    @State private var isAnimating = false
    
    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.gray.opacity(0.3),
                        Color.gray.opacity(0.5),
                        Color.gray.opacity(0.3)
                    ]),
                    startPoint: isAnimating ? .leading : .trailing,
                    endPoint: isAnimating ? .trailing : .leading
                )
            )
            .frame(width: width, height: height)
            .frame(maxWidth: width == nil ? .infinity : nil)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true)
                ) {
                    isAnimating = true
                }
            }
    }
}

