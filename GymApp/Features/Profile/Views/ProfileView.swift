
import SwiftUI

struct ProfileView: View {
    
    @Binding var showWorkoutTimer: Bool
    @State var showAvatarPickerSheet : Bool = false
    @State var showEditSheet : Bool = false
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.fitnessBackgroundPrimary
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 24) {
                        
                        ProfileView_Header_Section(showAvatarPickerSheet: $showAvatarPickerSheet)
                            .padding(.horizontal, 20)
                        
                        Profile_Achievements()
                            .padding(.top, 24)
                        
                        SummarySectionView()
                        
                        Profile_Section_QuickActions()
                            .padding(.horizontal, 20)

                        Spacer(minLength: 30)
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarTitle("Perfil")
            .toolbarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    
                    Menu("", systemImage: "ellipsis"){
                        Button("Editar", systemImage: "pencil"){
                            showEditSheet = true
                        }
                        Button("Compartir", systemImage: "square.and.arrow.up"){
                        }
                    }
                }
            }
            .sheet(isPresented: $showEditSheet) {
                EditProfileSheet(bio: $vm.bio_description, tags: $vm.user_tags)
            }
            .sheet(isPresented: $showAvatarPickerSheet) {
                ProfilePhotoSheet(
                    selectedIcon: $vm.selectedProfileIcon,
                    selectedColor: $vm.profileIconColor
                )
                .presentationDetents([.height(UIScreen.screenHeight * 0.6)])
                .presentationDragIndicator(.visible)
            }
        }
        .navigationBarHidden(true)
    }
}
