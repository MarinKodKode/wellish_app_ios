//
//  WelcomeView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 29/07/25.
//

import Foundation
import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    var body: some View {
            ZStack {
                Image("background_1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()
                
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(alignment : .leading) {
                    HStack(alignment: .top) {
                        Image("appicon_bg")
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 20)
                    .padding(.horizontal, 70)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Wellish")
                                .foregroundColor(.white)
                                .font(.system(size: 56, weight: .bold))
                            
                            Text("Exercise is the cure for everything")
                                .foregroundColor(.white.opacity(0.8))
                                .font(.system(size: 24, weight: .medium))
                      
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: {
                                navigationRouter.goTo(.signup)
                            }) {
                                Text("Join Us")
                                    .foregroundColor(.black)
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(width: 120, height: 50)
                                    .background(Color.white)
                                    .cornerRadius(25)
                            }
                            
                            Button(action: {
                                navigationRouter.goTo(.signin)
                            }) {
                                Text("Sign In")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .semibold))
                                    .frame(width: 120, height: 50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 70)
                    .padding(.bottom, 40)
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
    }
}

struct NikeRunClubView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
