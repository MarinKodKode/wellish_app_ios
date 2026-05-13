//
//  GymLiveTracker+SetCompleteAnimation.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 05/11/25.
//

import SwiftUI

struct GymLiveTracker_SetCompleteAnimation : View {
    @State private var overlayOpacity: Double = 0
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                LottieView(animationName: "success_animation", loopMode: .playOnce)
                    .frame(width: 300, height: 300)
                
                Text("¡Vamos si se puede!")
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(scale)
            .opacity(overlayOpacity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                overlayOpacity = 1
                scale = 1.0
            }
        }
    }
}


#Preview {
    GymLiveTracker_SetCompleteAnimation()
}
