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
    
    @State var userId: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) ?? "")
    @State var userName: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userName) ?? "")
    @State var userEmail: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail) ?? "")
    @StateObject var authManager = AuthManager()
    
    @State var tagName: String = ""
    
    var body: some Scene {
        
        WindowGroup {
            ZStack {
                if authManager.isAuthenticated {
                    ContentView()
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0).delay(0.5)))
                        .zIndex(0)
                } else if isShowingSplashScreen {
                    SplashScreenView(isShowingSplashScreen: $isShowingSplashScreen)
                        .transition(AnyTransition.opacity.animation(.easeOut(duration: 1.0).delay(0.5)))
                        .zIndex(2)
                } else if !hasCompletedOnboarding {
                    OnboardingView(hasCompletedOnboarding: $hasCompletedOnboarding)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0).delay(0.5)))
                        .zIndex(1)
                

                } else if authManager.isAuthenticated && !userViewModel.isLoggedIn {
                    Form {
                        Text("Name: " + userName)
                        Text("UserID: " + userId)
                        Text("UserEmail: " + userEmail)
                        TextField("Tag Name", text: $tagName)
                            .padding(.bottom, 40)
                        
                        Button(action: {
                            guard let newUser = User(accountID: authManager.userId, name: authManager.fullName, tagName: tagName, email: authManager.email, friends: nil, posts: nil, streak: 0, profilePicture: "", isActive: true)
                            else {
                                return
                            }
                            userViewModel.createUser(user: newUser)
                            
                        }, label: {
                            Text("Create Account")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        })
                    }
                } else {
                    SignInView(authManager: authManager)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5).delay(0.5)))
                        .zIndex(0)
                }
            }
            .environmentObject(userViewModel)
            .environmentObject(postViewModel)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Adjust delay as necessary
                    withAnimation {
                        self.isShowingSplashScreen = false
                    }
                }
            }
        }
    }
}

