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
    
    @State private var isShowingSplashScreen = true
    
    @State var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasCompletedOnboarding)
    
    @State var tagName: String = ""
    
    @StateObject var songViewModel = SongViewModelTest()
    
    var body: some Scene {
        
        WindowGroup {
            ZStack {
                if !hasCompletedOnboarding {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                        .zIndex(1)
                    
                } else if userViewModel.user == nil && !userViewModel.isLoggedIn {
                    SignInView()
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                        .zIndex(0)
                } else if userViewModel.user != nil && !userViewModel.tagNameExists {
                    UserDetailsView()
                    
                } else if isShowingSplashScreen {
                    SplashScreenView(isShowingSplashScreen: $isShowingSplashScreen)
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                        .zIndex(2)
                } else {
                    ContentView()
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                        .zIndex(0)
                }
            }
            .environmentObject(userViewModel)
            .environmentObject(postViewModel)
            .environmentObject(songViewModel)
            .onAppear {
//                authManager.checkAuthenticationState()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        self.isShowingSplashScreen = false
                    }
                }
            }
        }
    }
}

