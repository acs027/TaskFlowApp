//
//  LoginView.swift
//  TaskFlow
//
//  Created by ali cihan on 22.10.2025.
//

import SwiftUI

struct SigninView: View {
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
                }
            }
            .frame(height: 300)
            signinButton
            googleSigninButton
            switchToSignupButton
                .padding()
        }
    }
    
    private var signinButton: some View {
        Button {
            signin()
        } label: {
            Label {
                Text("Sign in with Email")
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
    
    private var switchToSignupButton: some View {
        HStack {
            Text("Don't have an account? ")
            Button("Register now") {
                viewModel.toggleFlow()
            }
        }
    }
    
    private var googleSigninButton: some View {
        Button {
            googleSignin()
        } label: {
            Label {
                Text("Sign in with Google")
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
    
    private func signin() {
        viewModel.signin()
    }
    
    private func googleSignin() {
        Task {
            await viewModel.signInWithGoogle()
        }
    }
}

//#Preview {
//    @Previewable @State var viewModel = AuthViewModel()
//    SigninView()
//        .environment(viewModel)
//}
