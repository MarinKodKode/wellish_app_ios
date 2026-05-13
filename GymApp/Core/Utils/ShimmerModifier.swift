//
//  ShimmerModifier.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 21/11/25.
//

import Foundation
import SwiftUI

struct ShimmerModifier: ViewModifier {
    let isAnimating: Bool
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [
                            .clear,
                            .white.opacity(0.4),
                            .clear
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    .frame(width: geo.size.width * 0.6)
                    .offset(x: isAnimating ? geo.size.width : -geo.size.width)
                }
                .mask(content)
            )
            .clipped()
    }
}
