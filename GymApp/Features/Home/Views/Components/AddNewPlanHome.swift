import Foundation
import SwiftUI

struct EmptyRoutineView: View {
    
    @EnvironmentObject var vm : MainHomeViewModel
    @EnvironmentObject var navigationRouter: NavigationRouter 
    
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.18, green: 0.25, blue: 0.45),
                                Color(red: 0.12, green: 0.18, blue: 0.35)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(
                                Color.white.opacity(0.1),
                                lineWidth: 1
                            )
                    )

                VStack(spacing: 14) {
                    // Icono con círculo
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.2))
                            .frame(width: 64, height: 64)

                        Image(systemName: "figure.run.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 34, height: 34)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color(red: 0.3, green: 0.7, blue: 1.0), Color.blue],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    }

                    VStack(spacing: 6) {
                        Text("Sin rutina asignada")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)

                        Text("Añade un plan para iniciar\ntu entrenamiento de hoy")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundColor(.white.opacity(0.55))
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                    }

                    // Botón CTA
                    Button(action: {
                        vm.selectedTab = 2
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 14))
                            Text("Explorar planes")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [Color.blue, Color(red: 0.3, green: 0.5, blue: 1.0)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                    }
                }
                .padding(.vertical, 28)
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

#Preview {
    ZStack {
        Color(red: 0.07, green: 0.10, blue: 0.18)
            .ignoresSafeArea()

        VStack(alignment: .leading, spacing: 0) {
            Text("La rutina de hoy 🔥")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

            EmptyRoutineView()
        }
    }
}
