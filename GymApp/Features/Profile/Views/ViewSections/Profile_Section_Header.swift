import Foundation
import SwiftUI

struct ProfileView_Header_Section : View {
    
    @StateObject private var vm = ProfileViewModel()
    @Binding var showAvatarPickerSheet : Bool
    
    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                showAvatarPickerSheet = true
            }) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    vm.profileIconColor,
                                    vm.profileIconColor.opacity(0.7)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 90, height: 90)
                        .overlay(
                            Image(vm.selectedProfileIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 89, height: 89)
                                .cornerRadius(90)
                        )
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "FFD700"),
                                            Color(hex: "FF6B6B"),
                                            Color(hex: "4E73DF")
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                        )
                }
            }
            .padding(.trailing, 16)
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(vm.username)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.fitnessTextPrimary)
                    
                    Spacer()
                }
                
                Text(vm.bio_description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                
                FlowLayouts(spacing: 6) {
                    ForEach(vm.user_tags, id: \.self) { tag in
                        TagView(text: tag)
                    }
                }
            }
        }
        .padding(.top, 40)
    }
}
