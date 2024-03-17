//
//  SignInView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 04/03/24.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    @State private var shouldShowUserDetails = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    
                    // Image of the app
                    Image("AppLogo")
                        .padding(.bottom)
                        .shadow(color: .black.opacity(0.15), radius: 13, x: 0, y: 8)
                    
                    // Show a description so the user can know what this view is about
                    Text(LocalizedStringKey("StartSerenading"))
                        .bold()
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    // Display the sign in with apple button
                    SignInWithAppleButton(.signIn, onRequest: { request in
                        request.requestedScopes = [.email, .fullName]
                    }, onCompletion: { authResult in
                        switch authResult {
                        case .success(let authResults): // If the request is successfull
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                let userID = appleIDCredential.user
                                let fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName].compactMap { $0 }.joined(separator: " ")
                                let email = appleIDCredential.email ?? ""
                                userViewModel.handleAuthorization(userID: userID, fullName: fullName, email: email) // Handle the authorization with the user info
                            default:
                                break;
                            }
                        case .failure(let error):
                            userViewModel.error = error.localizedDescription // Get the error
                            break;
                        }
                    })
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(height: 45)
                    .padding()
                    .padding(.top)
                    
                }
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack{
                    // Background of the view
                    LinearGradient(colors: [.accent, .clear], startPoint: .top, endPoint: .bottom)
                    Color.card.opacity(0.5)
                    
                }
                    .ignoresSafeArea()
            )
        }
        .transition(.asymmetric(insertion: .slide, removal: .push(from: .trailing)))
    }
}
