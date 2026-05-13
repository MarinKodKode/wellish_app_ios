import SwiftUI
import GoogleSignInSwift
import AuthenticationServices
import CryptoKit

struct SignUpView: View {
    
    @EnvironmentObject var navigationRouter: NavigationRouter
    
    @StateObject private var viewModel = AuthViewModel()
    @StateObject private var authManager = AuthenticationManager()
    
    @State private var isPasswordVisible: Bool = false
    @State private var isConfirmPasswordVisible: Bool = false
    @State private var showPasswordMismatch: Bool = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image("background_3")
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height * 0.7,
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
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            VStack(spacing: 8) {
                                Text(StringConstants.createAnAccouunt)
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text(StringConstants.signUpSubtitle)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top, 32)
                            
                            VStack(spacing: 16) {
                                // Full Name
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "person")
                                            .foregroundColor(.secondary)
                                            .frame(width: 20)
                                        
                                        TextField(
                                            StringConstants.fullName,
                                            text: $viewModel.fullName
                                        )
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .autocapitalization(.words)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                                }
                                
                                // Email
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "envelope")
                                            .foregroundColor(.secondary)
                                            .frame(width: 20)
                                        
                                        TextField(
                                            StringConstants.emailAddress,
                                            text: $viewModel.email
                                        )
                                            .textFieldStyle(PlainTextFieldStyle())
                                            .keyboardType(.emailAddress)
                                            .autocapitalization(.none)
                                            .autocorrectionDisabled()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "lock")
                                            .foregroundColor(.secondary)
                                            .frame(width: 20)
                                        
                                        if isPasswordVisible {
                                            TextField(
                                                StringConstants.password,
                                                text: $viewModel.password
                                            )
                                                .textFieldStyle(PlainTextFieldStyle())
                                        } else {
                                            SecureField(StringConstants.password, text: $viewModel.password)
                                                .textFieldStyle(PlainTextFieldStyle())
                                        }
                                        
                                        Button(action: {
                                            isPasswordVisible.toggle()
                                        }) {
                                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.1))
                                    )
                                    
                                    if !viewModel.password.isEmpty {
                                        VStack(alignment: .leading, spacing: 4) {
                                            PasswordRequirement(
                                                text: StringConstants.atLeastEightCharacters,
                                                isValid: viewModel.password.count >= 8
                                            )
                                            PasswordRequirement(
                                                text: StringConstants.passwordMustContainUpperAndLowerLetters,
                                                isValid: viewModel.password.rangeOfCharacter(from: .uppercaseLetters) != nil
                                            )
                                            PasswordRequirement(
                                                text: StringConstants.passwordMustContainLettersAndNumbers,
                                                isValid: viewModel.password.rangeOfCharacter(from: .decimalDigits) != nil
                                            )
                                        }
                                        .padding(.leading, 8)
                                    }
                                }
                                
                                // Confirm Password
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Image(systemName: "lock.fill")
                                            .foregroundColor(.secondary)
                                            .frame(width: 20)
                                        
                                        if isConfirmPasswordVisible {
                                            TextField(
                                                StringConstants.confirmPassword,
                                                text: $viewModel.confirmPassword
                                            )
                                                .textFieldStyle(PlainTextFieldStyle())
                                        } else {
                                            SecureField(StringConstants.confirmPassword, text: $viewModel.confirmPassword)
                                                .textFieldStyle(PlainTextFieldStyle())
                                        }
                                        
                                        Button(action: {
                                            isConfirmPasswordVisible.toggle()
                                        }) {
                                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.gray.opacity(0.1))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(showPasswordMismatch ? Color.red : Color.clear, lineWidth: 1)
                                            )
                                    )
                                    
                                    if showPasswordMismatch {
                                        Text(StringConstants.passwordDonotMatch)
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.red)
                                            .padding(.leading, 8)
                                    }
                                }
                            }
                            
                            // Terms and conditions
                            HStack(alignment: .top, spacing: 12) {
                                Button(action: {
                                    viewModel.agreeToTerms.toggle()
                                }) {
                                    Image(systemName: viewModel.agreeToTerms ? "checkmark.square.fill" : "square")
                                        .foregroundColor(viewModel.agreeToTerms ? .blue : .secondary)
                                        .font(.title3)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(
                                        StringConstants.agreeToTermsAndConditions
                                    )
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    Text(StringConstants.byCreatingAnAccountYouAgreeToOurTermsAndConditions)
                                        .font(.system(size: 12, weight: .regular))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            
                            // Create account button
                            Button(action: {
                                Task {
                                    await viewModel.register()
                                }
                            }) {
                                HStack {
                                    if viewModel.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    } else {
                                        Text(StringConstants.createAnAccouunt)
                                            .font(.system(size: 18, weight: .semibold))
                                    }
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(
                                    LinearGradient(
                                        colors: [Color.green, Color.blue],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                            .disabled(viewModel.isLoading || !viewModel.isFormValid)
                            .opacity(viewModel.isFormValid ? 1.0 : 0.6)
                            
                            Button {
                                //authService.startSignInWithAppleFlow()
                            } label: {
                                Image("AppleButton")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300)
                            }
                            
                            if viewModel.showError, let error = viewModel.errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.system(size: 14))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 8)
                            }
                            
                            HStack {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                                
                                Text("Or sign up with")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 4)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                            }
                            
                            HStack(spacing: 12) {
                                Button(action: {
                                    Task {
                                        await signUpWithGoogle()
                                    }
                                }) {
                                    Image("google_ic")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                }
                                
                                Button(action: {
                                    print("Sign up with Apple tapped")
                                }) {
                                    Image(systemName: "apple.logo")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 50)
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                    }
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
        .onChange(of: viewModel.confirmPassword) { _ in
            checkPasswordMatch()
        }
        .onChange(of: viewModel.password) { _ in
            checkPasswordMatch()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func checkPasswordMatch() {
        showPasswordMismatch = !viewModel.confirmPassword.isEmpty && viewModel.password != viewModel.confirmPassword
    }
    
    private func signUpWithGoogle() async {
        do  {
            try await authManager.signInWithGoogle()
        }catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}

// MARK: - Password Requirement View
struct PasswordRequirement: View {
    let text: String
    let isValid: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isValid ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isValid ? .green : .gray)
                .font(.system(size: 12))
            
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isValid ? .green : .gray)
            
            Spacer()
        }
    }
}

// MARK: - Preview
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(NavigationRouter())
    }
}
