//
//  LottieLoadingView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI
import Lottie

struct LottieLoadingView: UIViewRepresentable {
    let animationName: String
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {}
}

#Preview {
    LottieLoadingView(animationName: "FitnessLoadingSpinner")
}
