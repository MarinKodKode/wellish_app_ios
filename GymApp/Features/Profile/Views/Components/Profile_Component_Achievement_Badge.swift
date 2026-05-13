import Foundation
import SwiftUI

struct AchievementBadge: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                LinearGradient(
                    colors: [
                        color,
                        color,
                        Color.white.opacity(0.65)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(20)
                ZStack(alignment: .trailing) {
                    HStack(spacing: 0) {
                        Image(systemName: icon)
                            .font(.system(size: geometry.size.width * 0.9))
                            .foregroundColor(.white.opacity(0.2))
                            .frame(
                                width: geometry.size.width * 0.5)
                            .offset(x: -geometry.size.width * 0.15)
                        
                        Spacer()
                        
                    }
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)
                            
                        
                        Text(subtitle)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.9))
                            .multilineTextAlignment(.trailing)
                            .padding(.top, 12)
                    }
                    .frame(width: UIScreen.screenWidth * 0.25)
                    .padding(.vertical, 8)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(Color.black.opacity(0.15))
                .cornerRadius(20)
                .clipped()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.30, height: UIScreen.main.bounds.height * 0.15)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1).ignoresSafeArea()
        
        VStack(spacing: 30) {
            AchievementBadge(
                icon: "flame.fill",
                title: "Streak Month",
                subtitle: "30 días",
                color: .orange
            )
        }
    }
}
