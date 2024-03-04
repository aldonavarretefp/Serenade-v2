//
//  OnboardingView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 04/03/24.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        
        Text("Welcome to Serenade")
            .font(.largeTitle)
            .fontWeight(.bold)
        
        
        VStack(alignment: .center) {
            
            FeatureView(icon: "heart.fill", title: "Add Friends", description: "Connect effortlessly with friends to share and explore musical tastes together.")
            
            FeatureView(icon: "eye.fill", title: "Hear Previews", description: "Listen to 30-second previews of songs before diving into the full experience.")
            
            FeatureView(icon: "play.rectangle.fill", title: "Daily Song Posting", description: "Share your daily musical inspiration with the community and spark conversations.")
            
            
        }
        
    }
}

struct FeatureView: View {
    var icon: String
    var title: String
    var description: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.pink)
                .imageScale(.large)
            VStack(alignment: .leading) {
                Text(title)
                    .fontWeight(.semibold)
                Text(description)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
