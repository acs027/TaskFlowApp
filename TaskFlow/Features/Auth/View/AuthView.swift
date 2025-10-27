//
//  AuthView.swift
//  TaskFlow
//
//  Created by ali cihan on 22.10.2025.
//

import SwiftUI

struct AuthView: View {
    @State var viewModel = AuthViewModel()
    
    var body: some View {
        Group {
            switch viewModel.authState {
            case .unauthenticated, .error(_):
                VStack {
                    Spacer()
                    HStack {
                        Text("Task Flow")
                            .bold()
                            .font(.largeTitle)
                        Image(systemName: "suitcase.cart.fill")
                            .resizable()
                            .frame(width: 100)
                            .scaledToFit()
                            .rotationEffect(Angle(degrees: 45))
                    }
                    .offset(y: -50)
                    switch viewModel.authFlow {
                    case .signin:
                        SigninView()
                            .environment(viewModel)
                            .transition(.slide)
                    case .signup:
                        SignupView()
                            .environment(viewModel)
                            .transition(.slide)
                    }
                }
                .padding()
                .animation(.easeInOut, value: viewModel.authFlow)
                .background(
                    Color(uiColor: UIColor.systemGroupedBackground)
                )
            case .authenticating:
                ProgressView()
            case .authenticated:
                TaskFlowTabBar()
            }
        }
        .onChange(of: viewModel.authState) { oldValue, newValue in
            if case let .error(message) = newValue {
                viewModel.alertMessage = message
            }
        }
        .alert("Authentication Error", isPresented: Binding<Bool>(
            get: { viewModel.alertMessage != nil },
            set: { newValue in
                if !newValue { viewModel.alertMessage = nil }
            }
        )) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage ?? "Unexpected Error")
        }
        }
}

#Preview {
    AuthView()
}
