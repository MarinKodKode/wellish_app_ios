import Foundation
import SwiftUI

struct AddNewChallenge : View {
    
    var body : some View {
        VStack {
            Image("strong_arm")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 100)
                .padding(.top)
                .foregroundStyle(.white)
            
            Text("¡Añade retos, desafía tus límites!")
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .padding()
                .padding(.bottom, 12)
        }
        .background(Color.backgroundPrimary.opacity(0.9))
        .cornerRadius(16)
        Spacer()
    }
}

#Preview {
    AddNewChallenge()
}

