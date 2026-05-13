//
//  TrySomethingNewSectionView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 25/09/25.
//

import SwiftUI

struct TrySomethingNewSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            SectionBarTitle(title: "Intenta algo nuevo", icon : "arrow.right")
            
            ZStack {
                Image("background_4")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                Color.fitnessBackgroundPrimary
                    .opacity(0.8)
                
                VStack(alignment: .center) {
                    Spacer()
                    
                    HStack(alignment: .top) {
                        
                        VStack(alignment: .leading,spacing: 12) {
                            Text("Outdoor Cycling")
                                .font(.system(size: 28, weight: .black))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Text("Be the king of the road, go beyond\nyour limits and enjoy the nature...")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        
                        Spacer()
                        
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 22, weight: .bold))
                        
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    HStack{
                        
                        RedBadge(text: "4.9", icon: "star.fill")
                        Spacer()
                        RedBadge(text: "Beginner")
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
            }
            .frame(height: 200)
            .cornerRadius(16)
            .padding(.horizontal, 12)
        }
        
    }
}

struct RedBadge : View {
    
    var text : String = "4.9"
    var icon : String?
    
    var body: some View {
        
        HStack(alignment: .center){
            Text(text)
                .fontWeight(.bold)
                .frame(alignment: .center)
            
            if let icon = icon {
                Image(systemName: icon)
                    .resizable()
                    .frame(width: 14, height: 14)
            }
        }
        .frame(alignment: .center)
        .padding(.horizontal, 16)
        .padding(.vertical, 2)
        .background(
            LinearGradient(
                colors: [.red.opacity(0.5), .red.opacity(0.7), .red],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(16)
        
        
    }
}

#Preview {
    TrySomethingNewSectionView()
}
