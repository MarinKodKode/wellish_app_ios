//
//  View+Extensions.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/07/25.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    func showLoadingView(
        isLoading: Bool,
        loadingText: String = "",
        useCustomAnimation: Bool = true
    ) -> some View {
        self.modifier(
            LoadingViewModifier(
                isLoading: isLoading,
                loadingText: loadingText,
                useCustomAnimation: useCustomAnimation
            )
        )
    }
    
    func showLoadingView(when condition: Bool) -> some View {
        return self
            .disabled(condition)
            .overlay(
                ZStack {
                    if condition { LoadingView() } else { EmptyView() }
                }
                , alignment: .center)
    }
    
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func dismissKeyboardOnTap() -> some View {
        self.modifier(DismissKeyboardOnTap())
    }
    
    func keyboardAware() -> some View {
        self.modifier(KeyboardAwareModifier())
    }
    
    func enableNativeSwipeBack() -> some View {
        self.modifier(EnableSwipeBack())
    }
    
    func hideBackButtonText() -> some View {
        self.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("")
                }
            }
    }
    
    func shimmer(isAnimating: Bool) -> some View {
        modifier(ShimmerModifier(isAnimating: isAnimating))
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}


// MARK: - UIApplication Extension for Keyboard Dismissal
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct EnableSwipeBack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(RestoreSwipeGesture())
    }
}
