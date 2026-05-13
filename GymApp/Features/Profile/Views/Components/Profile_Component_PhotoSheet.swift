//
//  ProfileView_Component_PhotoSheet.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 01/12/25.
//

import Foundation
import SwiftUI

struct ProfilePhotoSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedIcon: String
    @Binding var selectedColor: Color
    @State private var showImagePicker = false
    
    let avatars = SystemImages.avatars
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(avatars, id: \.imageID) { option in
                            Button(action: {
                                selectedIcon = option.imageID
                                selectedColor = option.color
                                vm.updateProfilePicture(picture: option.imageID)
                                dismiss()
                            }) {
                                VStack(spacing: 8) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        option.color,
                                                        option.color.opacity(0.7)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 70, height: 70)
                                            .overlay(
                                                Circle()
                                                    .stroke(
                                                        selectedIcon == option.imageID ? Color.white : Color.clear,
                                                        lineWidth: 3
                                                    )
                                            )
                                            .shadow(color: option.color.opacity(0.4), radius: 10, x: 0, y: 5)
                                        
                                        Image(option.imageID)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 68, height: 68)
                                            .cornerRadius(45)
                                    }
                                    
                                    Text(option.label)
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        // Custom Upload Button
                        Button(action: {
                            showImagePicker = true
                        }) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color(hex: "252836"),
                                                    Color(hex: "1E222E")
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 70, height: 70)
                                        .overlay(
                                            Circle()
                                                .stroke(
                                                    Color(hex: "4E73DF"),
                                                    style: StrokeStyle(lineWidth: 2, dash: [5])
                                                )
                                        )
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 32, weight: .semibold))
                                        .foregroundColor(Color(hex: "4E73DF"))
                                }
                                
                                Text("Custom")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
                
            }
            .navigationTitle("Elige tu avatar")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(hex: "1A1D29"))
            .sheet(isPresented: $showImagePicker) {
                Text("Image Picker")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(hex: "1A1D29"))
            }
        }
    }
}
