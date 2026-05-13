//
//  StickyTImer.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 15/08/25.
//

import SwiftUI

struct StickyTImer: View {
    
    @Binding var curentTime : Double
    @Binding var isPlaying : Bool
    @Binding var calories : Int
    
    var body: some View {
        HStack(spacing: 16) {
            
            Image(systemName: "clock.fill")
                .font(.system(size: 26))
                .foregroundColor(.primary)
            VStack (alignment: .center){
                
                Text(String(format: "%.1f", curentTime))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text("min")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(alignment: .center)
            }
            
            Spacer()
            
            Image(systemName: "flame.fill")
                .font(.system(size: 26))
                .foregroundColor(.primary)
            VStack (alignment: .center){
                Text("\($calories)")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.primary)
                Text("Kcal")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .frame(alignment: .center)
            }
            Spacer()

            Button(action: {}) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            .padding(.trailing, 8)
        }
        .padding(.horizontal, 16)
        .frame(height: 100)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .zIndex(1)
        .transition(.move(edge: .top))
        .animation(.easeOut(duration: 0.3), value: true)
    }
}

#Preview {
    
    @Previewable @State var currentTime : Double = 25.09
    @Previewable @State var isPlaying : Bool = true
    @Previewable @State var calories : Int = 278
    
    StickyTImer(curentTime: $currentTime, isPlaying: $isPlaying, calories: $calories)
   
}
