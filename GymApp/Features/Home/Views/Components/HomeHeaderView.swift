//
//  HomeHeaderView.swift
//  Wellish
//

import SwiftUI

struct HomeHeaderView: View {

    @StateObject var vm = MainHomeViewModel()
    @StateObject var planVM = PlanTrackerCurrentDayViewModel()

    var hasNewStory: Bool = false

    var body: some View {
        HStack(alignment: .center, spacing: 12) {

            // MARK: - Avatar con ring (listo para stories)
            Button(action: {}) {
                ZStack {
                    Circle()
                        .strokeBorder(
                            hasNewStory
                                ? LinearGradient(
                                    colors: [.orange, .pink, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                  )
                                : LinearGradient(
                                    colors: [Color.white.opacity(0.15), Color.white.opacity(0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                  ),
                            lineWidth: hasNewStory ? 2.5 : 1.5
                        )
                        .frame(width: 52, height: 52)

                    if let photoURL = vm.profilePhotoURL {
                        AsyncImage(url: photoURL) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            } else {
                                placeholderAvatar
                            }
                        }
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                    } else {
                        placeholderAvatar
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    }
                }
            }
            .buttonStyle(.plain)

            // MARK: - Pills distribuidas en el ancho disponible
            HStack(spacing: 8) {

                // Racha
                PillStat(icon: "🔥", value: planVM.streakDays == 1 ? "\(planVM.streakDays) día" : "\(planVM.streakDays) días", isEmoji: true)

                // Nivel
                PillStat(systemIcon: "bolt.fill", iconColor: .yellow, value: "Rookie")
            }
            .frame(maxWidth: .infinity)

            // MARK: - Bell
            Button(action: {}) {
                Image(systemName: "person.2.circle.fill")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                    .frame(width: 48, height: 48)
                    .background(Color.white.opacity(0.07))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                    )
            }
            
            Button(action: {}) {
                Image(systemName: "bell")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
                    .frame(width: 48, height: 48)
                    .background(Color.white.opacity(0.07))
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.1), lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 52)
        .padding(.bottom, 16)
        .task {
            await planVM.initView()
        }
    }

    private var placeholderAvatar: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue.opacity(0.7), .purple.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text(vm.userName.prefix(1).uppercased())
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

// MARK: - PillStat

struct PillStat: View {
    var icon: String? = nil
    var systemIcon: String? = nil
    var iconColor: Color = .white
    var value: String
    var isEmoji: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            if let emoji = icon, isEmoji {
                Text(emoji)
                    .font(.system(size: 14))
            } else if let sys = systemIcon {
                Image(systemName: sys)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(iconColor)
            }

            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(height: 24)
        .frame( maxWidth: .infinity)
        .padding(.vertical, 9)
        .background(Color.white.opacity(0.08))
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(Color.white.opacity(0.12), lineWidth: 1)
        )
    }
}

#Preview {
    ZStack {
        Color(red: 0.07, green: 0.09, blue: 0.14).ignoresSafeArea()
        VStack {
            HomeHeaderView()
            Spacer()
        }
    }
}
