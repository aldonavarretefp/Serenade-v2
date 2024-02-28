//
//  StreamingAppPickerSheet.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 27/02/24.
//

import SwiftUI

struct StreamingAppPickerSheet: View {
    
    @State var selectedAppleMusic: Bool = true
    @State var selectedSpotify: Bool = true
    @State var selectedYouTubeMusic: Bool = true
    @State var selectedAmazonMusic: Bool = true
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.viewBackground
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Favorite streaming apps")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("Select your favorite streaming apps to play music.")
                    .foregroundStyle(.callout)
                    .font(.body)
                ChecklistItem(selected: selectedAppleMusic, image: "AppleMusicAppIcon", label: "Apple Music")
                ChecklistItem(selected: selectedSpotify, image: "SpotifyAppIcon", label: "Spotify")
                ChecklistItem(selected: selectedYouTubeMusic, image: "YouTubeMusicAppIcon", label: "YouTube Music")
                ChecklistItem(selected: selectedAmazonMusic, image: "AmazonMusicAppIcon", label: "Amazon Music")
//                Spacer()
            }
            .padding()
        }
    }
    
}

#Preview {
    StreamingAppPickerSheet()
}
