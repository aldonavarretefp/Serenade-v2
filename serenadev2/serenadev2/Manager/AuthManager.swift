//
//  AuthManager.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 04/03/24.
//

import Foundation
import SwiftUI
import AuthenticationServices

class AuthManager: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var userId: String = ""
    
    @Published var isAuthenticated: Bool = false
    @Published var showInitialSetup: Bool = false
    
    @EnvironmentObject var userViewModel: UserViewModel

    func signInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]

        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            DispatchQueue.main.async {
                self.userId = appleIDCredential.user
                self.email = appleIDCredential.email ?? ""
                self.fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName].compactMap { $0 }.joined(separator: " ")
                
                if self.email != "" && self.fullName != "" {
                    UserDefaults.standard.set(self.fullName, forKey: UserDefaultsKeys.userName)
                    print("Saved userName: \(self.fullName)")

                    UserDefaults.standard.set(self.email, forKey: UserDefaultsKeys.userEmail)
                    print("Saved userEmail: \(self.email)")

                    UserDefaults.standard.set(self.userId, forKey: UserDefaultsKeys.userID)
                    print("Saved userID: \(self.userId)")
                }
                
                self.isAuthenticated = true
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error
        print("Authorization failed: \(error.localizedDescription)")
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    func checkAuthenticationState() {
        if let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.userID), !userId.isEmpty {
            // Assume user is authenticated if userID exists and is not empty
            self.isAuthenticated = true
        } else {
            self.isAuthenticated = false
        }
    }

    func logOut() {
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userID)
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userName)
//        UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userEmail)
        
        
        DispatchQueue.main.async {
            self.isAuthenticated = false
        }
        
    }
    
}
