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
    @StateObject var authManager: AuthManager  = AuthManager()
    
    
    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated == false {
                SignInView()
            }
            else{
                ContentView()
                    .environmentObject(userViewModel)
            }
            
        }
    }
}
