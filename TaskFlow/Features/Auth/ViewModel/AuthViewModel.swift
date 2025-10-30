//
//  AuthViewModel.swift
//  TaskFlow
//
//  Created by ali cihan on 22.10.2025.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore


enum AuthState: Equatable {
    case unauthenticated
    case authenticating
    case authenticated
    case error(String)
    
    static func == (lhs: AuthState, rhs: AuthState) -> Bool {
           switch (lhs, rhs) {
           case (.unauthenticated, .unauthenticated),
                (.authenticating, .authenticating),
                (.authenticated, .authenticated):
               return true
           case let (.error(l), .error(r)):
               return l == r
           default:
               return false
           }
       }
}

enum AuthFlow {
    case signin
    case signup
}

@Observable
class AuthViewModel {
    var email: String = ""
    var password: String = ""
    var confirmationPassword: String = ""
    
    var alertMessage: String?
    
    var authState: AuthState = .unauthenticated
    var authFlow: AuthFlow = .signin
    
    init() {
        if Auth.auth().currentUser != nil {
            authState = .authenticated
        }
    }
    
    private func clearFields() {
        email = ""
        password = ""
        confirmationPassword = ""
    }
    
    
    private func validateSignupFields() -> Bool {
        guard !email.isEmpty, !password.isEmpty, !confirmationPassword.isEmpty else {
            let errorMessage = "Please fill in all fields."
            authState = .error(errorMessage)
            return false
        }
        
        guard isValidEmail(email) else {
            let errorMessage = "Invalid email address."
            authState = .error(errorMessage)
            return false
        }
        
        guard password.count >= 6 else {
            let errorMessage = "Password must be at least 6 characters."
            authState = .error(errorMessage)
            return false
        }
        
        guard password == confirmationPassword else {
            let errorMessage = "Passwords do not match."
            authState = .error(errorMessage)
            return false
        }
        
        return true
    }
    
    private func validateSigninFields() -> Bool {
        
        guard !email.isEmpty, !password.isEmpty else {
            let errorMessage = "Please fill in all fields."
            authState = .error(errorMessage)
            return false
        }
        
        guard isValidEmail(email) else {
            let errorMessage = "Invalid email address."
            authState = .error(errorMessage)
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            authState = .unauthenticated
            print("Logout success")
        } catch {
            print("Error occured while logout.")
        }
        
    }
    
    func signup() {
        guard validateSignupFields() else { return }
        authState = .authenticating
        if password == confirmationPassword {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error {
                    self.authState = .error(error.localizedDescription)
                } else {
                    self.authState = .authenticated
                    self.clearFields()
                }
            }
        } else {
            authState = .error("Passwords should be same.")
        }
    }
    
    func signin() {
        guard validateSigninFields() else { return }
        authState = .authenticating
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error {
                self.authState = .error(error.localizedDescription)
            } else {
                self.authState = .authenticated
                self.clearFields()
            }
        }
    }
    
    func toggleFlow() {
        if authFlow == .signin {
            authFlow = .signup
        } else {
            authFlow = .signin
        }
    }
}

extension AuthViewModel {
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No Client ID found in Firebase configuration")}
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller")
            return false
        }
        
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                fatalError("ID Token missing")
            }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unl")")
            return true
        } catch {
            print(error.localizedDescription)
            authState = .error(error.localizedDescription)
        }
        return false
    }
}
