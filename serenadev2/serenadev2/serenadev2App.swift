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
    @StateObject var friendRequestViewModel: FriendRequestsViewModel = FriendRequestsViewModel()
    
    @State private var isShowingSplashScreen = true
    @State var hasCompletedOnboarding: Bool = UserDefaults.standard.bool(forKey: UserDefaultsKeys.hasCompletedOnboarding)
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // The splash screen view is always at the top of the stack but will be hidden after determining the user's state.
                if isShowingSplashScreen {
                    SplashScreenView(isShowingSplashScreen: $isShowingSplashScreen)
                        .zIndex(3) // Highest zIndex ensures it's always on top initially.
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                }

                // Conditional views based on user state that are displayed after the splash screen logic has completed.
                if !hasCompletedOnboarding {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .zIndex(1)
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                } else if userViewModel.user == nil && !userViewModel.isLoggedIn {
                    SignInView()
                        .zIndex(2)
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                } else if userViewModel.user != nil && !userViewModel.tagNameExists {
                    UserDetailsView()
                        .zIndex(1) // Lower zIndex as it's not initially important.
                } else {
                    ContentView()
                        .zIndex(0) // Default content view with the lowest priority.
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.5)))
                }
            }
            .environmentObject(userViewModel)
            .environmentObject(postViewModel)
            .environmentObject(friendRequestViewModel)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Adjust timing as needed for your splash screen
                    withAnimation {
                        self.isShowingSplashScreen = false // Hide splash screen after delay
                    }
                }
            }
        }
    }
}

