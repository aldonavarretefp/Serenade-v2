//
//  AuthManager.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 04/03/24.
//

import Foundation
import AuthenticationServices

class AuthManager: NSObject, ObservableObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    @Published var email: String = ""
    @Published var fullName: String = ""
    @Published var userId: String = ""
    
    @Published var isAuthenticated: Bool = false

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
                self.email = appleIDCredential.email ?? "No Email Found"
                self.fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName].compactMap { $0 }.joined(separator: " ")
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
}
