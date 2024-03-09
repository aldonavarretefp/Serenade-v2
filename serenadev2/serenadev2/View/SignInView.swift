//
//  SignInView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 04/03/24.
//

import SwiftUI
import AuthenticationServices

struct SignInView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var shouldShowUserDetails = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image("AppLogo")
                        .padding(.bottom)
                        .shadow(color: .black.opacity(0.15), radius: 13, x: 0, y: 8)
                    
                    Text(LocalizedStringKey("StartSerenading"))
                        .bold()
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    SignInWithAppleButton(.signIn, onRequest: { request in
                        request.requestedScopes = [.email, .fullName]
                    }, onCompletion: { authResult in
                        switch authResult {
                        case .success(let authResults):
                            switch authResults.credential {
                            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                                let userID = appleIDCredential.user
                                let fullName = [appleIDCredential.fullName?.givenName, appleIDCredential.fullName?.familyName].compactMap { $0 }.joined(separator: " ")
                                let email = appleIDCredential.email ?? ""
                                userViewModel.handleAuthorization(userID: userID, fullName: fullName, email: email)
                            default:
                                break;
                            }
                        case .failure(let error):
                            userViewModel.error = error.localizedDescription
                            break;
                        }
                    })
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(height: 45)
                    .padding()
                    .padding(.top)
                    
                    //                    if userViewModel.error != "" {
                    //                        Text(userViewModel.error)
                    //                    }
                    
                }
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                ZStack{
                    LinearGradient(colors: [.accent, .clear], startPoint: .top, endPoint: .bottom)
                    Color.card.opacity(0.5)
                    
                }
                    .ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
            
            
        }
        .transition(.asymmetric(insertion: .slide, removal: .push(from: .trailing)))
    }
}
