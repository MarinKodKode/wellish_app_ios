//
//  LiveAnimationView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 20/10/25.
//

import SwiftUI

struct LiveAnimationView : View {
    @State private var animationProgress: CGFloat = 0
    @State private var overlayOpacity: Double = 0
    @State private var scale: CGFloat = 0.8
    
    var animationName : String = "success_animation"
    var displayLabel : Bool = false
    var label : String = "!Vamos si se puede!"
    var onComplete : (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                LottieView(animationName: animationName, loopMode: .playOnce)
                    .frame(width: 300, height: 300)
                    .onAppear {
                        animationProgress = 1
                    }
                if displayLabel {
                    Text(label)
                        .font(.system(size: 35, weight: .bold))
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                overlayOpacity = 1
                scale = 1.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.6)) {
                    overlayOpacity = 0
                    scale = 1.1
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    onComplete?()
                }
            }
        }
    }
}

#Preview {
    LiveAnimationView()
}
