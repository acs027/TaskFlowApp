//
//  SignupView.swift
//  TaskFlow
//
//  Created by ali cihan on 22.10.2025.
//

import SwiftUI

struct SignupView: View {
    @Environment(AuthViewModel.self) var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            Form {
                Section("Email") {
                    TextField("Email", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                }
                Section("Pasword") {
                    SecureField("Password", text: $viewModel.password)
                    SecureField("Password", text: $viewModel.confirmationPassword)
                }
            }
            .frame(height: 300)
            signupButton
            googleSignupButton
            switchToSigninButton
                .padding()
        }
    }
    
    private var signupButton: some View {
        Button {
            signup()
        } label: {
            Label {
                Text("Sign up with Email")
                    .font(.headline)
            } icon: {
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
            }
            .padding()
        }
        .glassEffect()
    }
    
    private var switchToSigninButton: some View {
        HStack {
            Text("Already have an account? ")
            Button("Sign in now") {
                viewModel.toggleFlow()
            }
        }
    }
    
    private var googleSignupButton: some View {
        Button {
            googleSignup()
        } label: {
            Label {
                Text("Sign up with Google")
                    .font(.headline)
            } icon: {
                Image("google")
                    .resizable()
                    .frame(width: 25, height: 25, alignment: .center)
            }
            .padding()
        }
        .glassEffect()
    }
    
    private func signup() {
        viewModel.signup()
    }
    
    private func googleSignup() {
        Task {
            await viewModel.signInWithGoogle()
        }
    }
    
}

//#Preview {
//    @Previewable @State var viewModel = AuthViewModel()
//    SignupView()
//        .environment(viewModel)
//}
