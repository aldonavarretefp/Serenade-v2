//
//  SplashScreenView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 04/03/24.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isShowingSplashScreen: Bool
    
    var body: some View {
        ZStack{
            
            if colorScheme == .dark{
                Color.black.ignoresSafeArea()
            }
            else{
                Color.white.ignoresSafeArea()
            }
            
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

