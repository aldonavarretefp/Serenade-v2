//
//  SplashScreenView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 04/03/24.
//

import SwiftUI

struct SplashScreenView: View {
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    @Binding var isShowingSplashScreen: Bool
    
    var body: some View {
        ZStack{
            // Background of the view
            if colorScheme == .dark{
                Color.black.ignoresSafeArea()
            }
            else{
                Color.white.ignoresSafeArea()
            }
            
            // Show the app logo at the middle of the view
            Image("AppLogo")
        }
        .onAppear {
            // Delay to simulate loading time
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // Adjust time as needed
                withAnimation {
                    self.isShowingSplashScreen = false
                }
            }
            
        }
    }
}

