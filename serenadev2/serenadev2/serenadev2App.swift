//
//  serenadev2App.swift
//  serenadev2
//
//  Created by Diego Ignacio Nunez Hernandez on 19/02/24.
//

import SwiftUI
import SwiftData

@main
struct serenadev2App: App {
    @StateObject var userViewModel: UserViewModel = UserViewModel()
    @StateObject var postViewModel: PostViewModel = PostViewModel()
    @StateObject var authManager: AuthManager = AuthManager()
    
    @State private var isShowingSplashScreen = true
    
    @State var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasCompletedOnboarding)
    
    @State var userId: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) ?? "")
    @State var userName: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userName) ?? "")
    @State var userEmail: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail) ?? "")
    
    @State var tagName: String = ""
    
    @StateObject var songViewModel = SongViewModelTest()
    
    var body: some Scene {
        
        WindowGroup {
            ZStack {
                if authManager.isAuthenticated && userViewModel.user != nil {
                    UserDetailsView(authManager: authManager)
                } else if authManager.isAuthenticated {
                    ContentView()
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                        .zIndex(0)
                } else if !hasCompletedOnboarding {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                        .zIndex(1)
                    
                } else if isShowingSplashScreen {
                    SplashScreenView(isShowingSplashScreen: $isShowingSplashScreen)
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                        .zIndex(2)
                } else {
                    SignInView(authManager: authManager)
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                        .zIndex(0)
                }
            }
            .environmentObject(userViewModel)
            .environmentObject(postViewModel)
            .environmentObject(songViewModel)
            .environmentObject(authManager)
            .onAppear {
                authManager.checkAuthenticationState()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { 
                    withAnimation {
                        self.isShowingSplashScreen = false
                    }
                }
            }
        }
    }
}

