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
        NavigationStack{
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    Text(LocalizedStringKey("FavoriteAppsDescription"))
                        .fontWeight(.light)
                        .foregroundStyle(.callout)
                        .padding(.bottom)
                    ChecklistItem(selected: selectedAppleMusic, image: "AppleMusicAppIcon", label: "Apple Music")
                    ChecklistItem(selected: selectedSpotify, image: "SpotifyAppIcon", label: "Spotify")
                    ChecklistItem(selected: selectedYouTubeMusic, image: "YouTubeMusicAppIcon", label: "YouTube Music")
                    ChecklistItem(selected: selectedAmazonMusic, image: "AmazonMusicAppIcon", label: "Amazon Music")
                    //                Spacer()
                }
                .padding(.horizontal)
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Text(LocalizedStringKey("FavoriteStreamingApps"))
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
        }
    }
    
}

#Preview {
    StreamingAppPickerSheet()
}
