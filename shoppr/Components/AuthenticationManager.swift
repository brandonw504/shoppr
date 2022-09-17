//
//  AuthenticationManager.swift
//  running-total-test
//
//  Created by Brandon Wong on 8/3/22.
//

import Foundation
import RealmSwift
import AuthenticationServices

class AuthenticationManager: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var authIsEnabled: Bool {
        isValidEmail(email) && password.count > 5
    }
    
    var enableButtons: Bool {
        !isLoading && authIsEnabled
    }
    
    func anonymouslyLogin() {
        isLoading = true
        errorMessage = nil
        
        app!.login(credentials: .anonymous) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(_):
                        print("success anonymously logged in")
                    case .failure(_):
                        self?.errorMessage = "login failed"
                }
                self?.isLoading = false
            }
        }
    }
    
    func signup() {
        let client = app!.emailPasswordAuth
        
        isLoading = true
        errorMessage = nil
        
        client.registerUser(email: email, password: password) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "Sign up error: \(error.localizedDescription)"
                    self?.isLoading = false
                } else {
                    self?.login()
                }
            }
        }
    }
    
    func login() {
        isLoading = true
        errorMessage = nil
        
        let credentials = Credentials.emailPassword(email: email, password: password)
        app!.login(credentials: credentials) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    self?.errorMessage = "Login failed: \(error.localizedDescription)"
                case .success(_):
                    print("login success")
                }
                self?.isLoading = false
            }
        }
    }
    
//    func loginWithApple(identityToken: String) {
//        let credentials = Credentials.apple(idToken: identityToken)
//
//        isLoading = true
//        errorMessage = nil
//
//        // Fetch IDToken via the Apple SDK
//        app!.login(credentials: credentials) { [weak self] result in
//            DispatchQueue.main.async {
//                switch result {
//                case .failure(let error):
//                    self?.errorMessage = "Login failed: \(error.localizedDescription)"
//                case .success(let user):
//                    print("Successfully logged in as user \(user)")
//                }
//                self?.isLoading = false
//            }
//        }
//    }
    
    static func logout() {
        app!.currentUser?.logOut(completion: { error in
            if let error = error {
                print("error logout \(error)")
            }
        })
    }
}
