//
//  LoadingOverlayView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import CoreFoundation
import Foundation
import UIKit
import SwiftUI

struct LoadingOverlayView : View {
    let loadingText : String
    let useCustomAnimation : Bool
    
    @State private var animationProgress : CGFloat = 0
    
    var body : some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing : 20){
                if useCustomAnimation {
                    LottieLoadingView(animationName : "FitnessLoadingSpinner")
                        .frame(width: 80, height : 80)
                }else {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.black.opacity(0.8))
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
            )
        }
        .onAppear {
            if useCustomAnimation {
                startCustomAnimation()
            }
        }
    }
    
    private func startCustomAnimation() {
        withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
            animationProgress = 1.0
        }
    }
    
    
}
