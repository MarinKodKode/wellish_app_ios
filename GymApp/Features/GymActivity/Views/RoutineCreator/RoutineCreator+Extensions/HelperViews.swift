//
//  Functions.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/09/25.
//

import SwiftUI

public class  WidgetHelpers {
    
    @ViewBuilder
    func enhancedSectionView<Content: View>(
        title: String,
        icon: String,
        iconColor: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.fitnessTextPrimary)
            }
            .padding(.horizontal, 16)

            content()
                .padding(24)
                .background(Color.fitnessBackgroundSecondary)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.05), radius: 10, y: 2)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .frame(maxWidth: .infinity)
        }
    }

    func customTextField(
        placeholder: String,
        text: Binding<String>,
        icon: String,
        iconColor: Color
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 20)

            TextField(placeholder, text: text)
                .font(.system(size: 16))
                .foregroundColor(.fitnessTextPrimary)
        }
        .padding(16)
        .background(Color.fitnessBackgroundPrimary)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(iconColor.opacity(0.2), lineWidth: 1)
        )
    }

    func metricCard(title: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.fitnessTextSecondary)
                Text(value)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.fitnessTextPrimary)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.fitnessBackgroundPrimary)
        .cornerRadius(12)
    }
}
