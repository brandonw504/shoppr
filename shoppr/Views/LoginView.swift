//
//  LoginView.swift
//  shoppr
//
//  Created by Brandon Wong on 8/1/22.
//

import RealmSwift
import SwiftUI
import AuthenticationServices

// Authentication Views
// Represents the login screen. We will have a button to log in anonymously.
struct LoginView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var authManager = AuthenticationManager()
    // Hold an error if one occurs so we can display it.
    @State var error: Error?
    
    // Keep track of whether login is in progress.
    @State var isLoggingIn = false
    
// Sign with Apple
//    private func onRequest(_ request: ASAuthorizationAppleIDRequest) {
//        request.requestedScopes = [.fullName, .email]
//    }
//
//    private func onCompletion(_ result: Result<ASAuthorization, Error>) {
//        switch result {
//        case .success (let authResults):
//            guard let credential = authResults.credential as? ASAuthorizationAppleIDCredential, let identityToken = credential.identityToken, let identityTokenString = String(data: identityToken, encoding: .utf8) else { return }
//            authManager.loginWithApple(identityToken: identityTokenString)
//        case .failure (let error):
//            print("Authorization failed: " + error.localizedDescription)
//        }
//    }

    var body: some View {
        VStack {
            if isLoggingIn {
                ProgressView()
            }
            if let error = error {
                Text("Error: \(error.localizedDescription)")
            }
            
            Text("Label Scanner")
                .font(.title)
            
            TextField("Email", text: $authManager.email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
            
            SecureField("Password", text: $authManager.password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .textInputAutocapitalization(.never)
            
            if authManager.isLoading {
                ProgressView()
            }
            
            if let error = authManager.errorMessage {
                Text(error)
                    .foregroundColor(.pink)
            }
            
            HStack {
                Button("Sign Up") {
                    isLoggingIn = true
                    authManager.signup()
                    isLoggingIn = false
                }
                .buttonStyle(.bordered)
                .disabled(!authManager.authIsEnabled)
                
                Button("Log In") {
                    isLoggingIn = true
                    authManager.login()
                    isLoggingIn = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(!authManager.authIsEnabled)
            }
            .padding()
            
//            HStack {
//                SignInWithAppleButton(.signIn, onRequest: onRequest, onCompletion: onCompletion)
//                    .frame(width: 250, height: 50)
//                    .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
//                    .disabled(authManager.isLoading)
//            }
//            .padding()
            
            Button("Continue without an account") {
                isLoggingIn = true
                authManager.anonymouslyLogin()
                isLoggingIn = false
            }
            .disabled(authManager.isLoading)
        }
    }
}
