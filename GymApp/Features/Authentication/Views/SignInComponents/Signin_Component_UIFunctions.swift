//
//  Signin_Component_UIFunctions.swift
//  Wellish
//
//  Created by Manuel Alejandro Hernandez Marín on 26/11/25.
//

import Foundation

extension SignInView {
//    func checkPasswordMatch() {
//        showPasswordMismatch = !viewModel.confirmPassword.isEmpty && viewModel.password != viewModel.confirmPassword
//    }
    
    func signUpWithGoogle() async {
        do  {
            try await authManager.signInWithGoogle()
        }catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
