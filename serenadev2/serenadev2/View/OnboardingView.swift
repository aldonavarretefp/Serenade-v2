//
//  OnboardingView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 04/03/24.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: - Properties
    @Binding var hasCompletedOnboarding: Bool
    
    // MARK: - Body
    var body: some View {
        ZStack{
            // Background of the view
            Color.viewBackground
                .ignoresSafeArea()
            
            VStack(){
                // Welcome text
                Text(LocalizedStringKey("WelcomeToSerenade"))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // Scroll view if the content doesnt fit in the phone
                ScrollView{
                    VStack(alignment: .leading, spacing: 40){
                        // Add friends feature
                        FeatureComponent(icon: "person.fill.checkmark", title: LocalizedStringKey("AddFriends"), description: LocalizedStringKey("AddFriendsDescription"))
                        
                        // Daily post feature
                        FeatureComponent(icon: "waveform.circle.fill", title: LocalizedStringKey("DailySongSharing"), description: LocalizedStringKey("DailySharingDescription"))
                        
                        // Listen previews feature
                        FeatureComponent(icon: "play.circle.fill", title: LocalizedStringKey("ListenPreviews"), description: LocalizedStringKey("ListenPreviewsDescription"))
                        
                        // Open with feature
                        FeatureComponent(icon: "arrow.up.right.circle.fill", title: LocalizedStringKey("OpenWithFavorite"), description: LocalizedStringKey("OpenWithFavoriteDescription"))
                    }
                    .padding(.horizontal)
                }
                .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
                
                Spacer ()
                ActionButton(label: LocalizedStringKey("Start"), symbolName: "", fontColor: .white, backgroundColor: .accentColor, isShareDaily: false, isDisabled: false) {
                    
                    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasCompletedOnboarding) // Set to true so the user only see it once
                    hasCompletedOnboarding = true
                }
                .padding()
            }
        }
    }
}

#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(true))
        .environment(\.locale, .init(identifier: "it"))
}
