//
//  OnboardingView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 04/03/24.
//

import SwiftUI

struct OnboardingView: View {
    
    //    ZStack{
    //        LinearGradient(colors: [.accent, .clear], startPoint: .top, endPoint: .bottom)
    //        Color.card.opacity(0.5)
    //
    //    }
    //        .ignoresSafeArea()
    
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        ZStack{
            
            Color.viewBackground
                .ignoresSafeArea()
            
            VStack(){
                Text(LocalizedStringKey("WelcomeToSerenade"))
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                ScrollView{
                    VStack(alignment: .leading, spacing: 40){
                        FeatureView(icon: "person.fill.checkmark", title: LocalizedStringKey("AddFriends"), description: LocalizedStringKey("AddFriendsDescription"))
                        
                        FeatureView(icon: "waveform.circle.fill", title: LocalizedStringKey("DailySongSharing"), description: LocalizedStringKey("DailySharingDescription"))
                        
                        FeatureView(icon: "play.circle.fill", title: LocalizedStringKey("ListenPreviews"), description: LocalizedStringKey("ListenPreviewsDescription"))
                        
                        FeatureView(icon: "arrow.up.right.circle.fill", title: LocalizedStringKey("OpenWithFavorite"), description: LocalizedStringKey("OpenWithFavoriteDescription"))
                    }
                    .padding(.horizontal)
                }
                .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
                
                Spacer ()
                ActionButton(label: LocalizedStringKey("Start"), symbolName: "", fontColor: .white, backgroundColor: .accentColor, isShareDaily: false, isDisabled: false) {
                    
                    UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasCompletedOnboarding)
                    hasCompletedOnboarding = true
                    
                }
                .padding()
            }
            
        }
        
    }
}

struct FeatureView: View {
    var icon: String
    var title: LocalizedStringKey
    var description: LocalizedStringKey
    
    var body: some View {
        HStack(alignment: .center, spacing: 32){
            
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.accentColor)
                .padding(.leading)
                .frame(maxWidth: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .fontWeight(.semibold)
                    .font(.title2)
                
                Text(description)
                    .foregroundColor(.callout)
            }
        }
    }
}


#Preview {
    OnboardingView(hasCompletedOnboarding: .constant(true))
        .environment(\.locale, .init(identifier: "it"))
}
