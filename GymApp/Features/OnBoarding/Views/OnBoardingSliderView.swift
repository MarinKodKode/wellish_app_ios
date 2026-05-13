//
//  WelcomeView.swift
//  GymApp
//
//  Created by Manuel Alejandro Hernandez Marín on 18/07/25.
//

import SwiftUI
import SwiftUI

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
    }
}

struct OnboardingView: View {
    @State private var currentPage = 0
    @EnvironmentObject private var onboardingService : OnboardingService
    @EnvironmentObject var navigationRouter: NavigationRouter

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(0..<slides.count, id: \.self) { index in
                    OnboardingSlideView(slide: slides[index])
                        .tag(index)
                }
                .ignoresSafeArea(.all)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .ignoresSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? slides[currentPage].accentColor : Color.gray.opacity(0.5))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentPage)
                    }
                }
                .padding(.bottom, 30)
                
                Button(action: {
                    withAnimation(.spring()) {
                        onboardingService.completeOnboarding()
                    }
                }) {
                    Text("Get Started")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(slides[currentPage].accentColor)
                        .cornerRadius(28)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
            .ignoresSafeArea(.all)
        }
    }
}

struct OnboardingSlideView: View {
    let slide: OnboardingSlide
    
    var body: some View {
        ZStack {
            
            AsyncImage(url: URL(string: slide.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            
            LinearGradient(
                colors: [Color.clear, Color.black.opacity(0.8)],
                startPoint: .center,
                endPoint: .bottom
            )
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(slide.title)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(slide.subtitle.components(separatedBy: " ")[0])
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                    
                    Text(slide.subtitle.components(separatedBy: " ").dropFirst().joined(separator: " "))
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(slide.accentColor)
                        .multilineTextAlignment(.leading)
                    
                    Text(slide.quote)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.leading)
                        .padding(.top, 20)
                        .padding(.trailing, 24)
                }
                .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: 200)
            }
        }
    }
}




