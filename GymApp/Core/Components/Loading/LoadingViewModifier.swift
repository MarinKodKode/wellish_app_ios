//
//  LoadingViewModifier.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import SwiftUI

struct LoadingViewModifier : ViewModifier {
    
    let isLoading : Bool
    let loadingText : String
    let useCustomAnimation : Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isLoading)
            
            if isLoading {
                LoadingOverlayView(
                    loadingText : loadingText,
                    useCustomAnimation : useCustomAnimation
                )
            }
        }
    }
}
