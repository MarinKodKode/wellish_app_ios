//
//  SingInView.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 28/07/25.
//

import SwiftUI


struct SignInView: View {
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    @StateObject var viewModel = AuthViewModel()
    @StateObject var authManager = AuthenticationManager()
    
    @State var email: String = ""
    @State var password: String = ""
    @State var isPasswordVisible: Bool = false
    @State var isLoading: Bool = false
    @State var savePassword: Bool = false
    @State var showError = false
    @State var errorMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background_4")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.999,
                        alignment: .top
                    )
                    .overlay(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.3),
                                Color.black.opacity(0.1),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                
                VStack(spacing: 0) {
                    VStack {
                        HStack {
                            CustomBackButton(action: {
                                navigationRouter.goBack()
                            })
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        
                    }
                    .frame(height: geometry.size.height * 0.25)
                    
                    VStack(spacing: 24) {
                        
                        Signin_Header
                        
                        Signin_TextFields
                        
                        Signin_RememberPasswordCheckBox
                        
                        Signin_LoginButtons
                        
                        Signin_ThirdPartyButtons
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(.systemBackground))
                            .ignoresSafeArea(.all, edges: .bottom)
                    )
                    .frame(maxHeight: .infinity)
                }
            }
        }
        .ignoresSafeArea()
        .hideKeyboardOnTap()
        .enableNativeSwipeBack()
        .navigationBarBackButtonHidden(true)
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
