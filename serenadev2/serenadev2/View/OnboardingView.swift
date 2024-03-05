//
//  OnboardingView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 04/03/24.
//

import SwiftUI

struct OnboardingView: View {
    
    @Binding var hasCompletedOnboarding: Bool
    
    var body: some View {
        
        VStack(){
            Text("Welcome to Serenade")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 40){
                FeatureView(icon: "heart.fill", title: "Add Friends", description: "Connect effortlessly with friends to share and explore musical tastes together.")
                
                
                FeatureView(icon: "hearingdevice.ear.fill", title: "Hear Previews", description: "Listen to 15-second previews of songs before diving into the full experience.")
                
                FeatureView(icon: "clock.arrow.circlepath", title: "Daily Song Posting", description: "Share your daily song once every 24 hours with the community, enriching everyone's musical journey.")
                
                FeatureView(icon: "play.circle.fill", title: "Open with Favorite Streaming App", description: "Enjoy uninterrupted listening by opening songs directly in your preferred streaming app.")
            }
            
        }
        .padding()
        
        Spacer ()
        ActionButton(label: "Start", symbolName: "", fontColor: .white, backgroundColor: .accentColor, isShareDaily: false, isDisabled: false) {
            
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.hasCompletedOnboarding)
            hasCompletedOnboarding = true
            
        }
        .padding()
    }
}

struct FeatureView: View {
    var icon: String
    var title: String
    var description: String
    
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
}
