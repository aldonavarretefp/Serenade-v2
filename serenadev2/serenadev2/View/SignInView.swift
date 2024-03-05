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
    
    @ObservedObject var authManager: AuthManager
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var shouldShowUserDetails = false
    
    
    init(authManager: AuthManager) {
        self.authManager = authManager
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Image("AppLogo")
                    
                    Text("Sign in and start serenading")
                      .bold()
                      .font(.largeTitle)
                      .multilineTextAlignment(.center)
                    
                    
                    SignInWithAppleButton(.signIn) { _ in
                        authManager.signInWithApple()
                    } onCompletion: { result in

                    }
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                    .frame(height: 45)
                    .padding()
                    
                }
                .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)
                .padding()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
              LinearGradient(
                stops: [
                    Gradient.Stop(color: Color.accentColor.opacity(0.40), location: 0.00),
                    Gradient.Stop(color: Color.accentColor.opacity(0.7), location: 0.50),
                    Gradient.Stop(color: Color.accentColor.opacity(0), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
              )
            )
            .navigationBarTitleDisplayMode(.inline)
        }//: Navigation
        .preferredColorScheme(colorScheme == .dark ? .dark : .light)
        .transition(.asymmetric(insertion: .slide, removal: .push(from: .trailing)))
    }
}
