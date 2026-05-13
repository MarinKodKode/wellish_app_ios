//
//  RestoreSwipeGesture.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 06/08/25.
//

import Foundation
import SwiftUI
import UIKit

struct RestoreSwipeGesture: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if let navigationController = uiView.findNavigationController() {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
                navigationController.interactivePopGestureRecognizer?.delegate = nil
            }
        }
    }
}

extension UIView {
    func findNavigationController() -> UINavigationController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let navigationController = responder as? UINavigationController {
                return navigationController
            }
            responder = responder?.next
        }
        return nil
    }
}
