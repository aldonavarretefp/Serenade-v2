//
//  StreamingAppPickerSheet.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 27/02/24.
//

import SwiftUI

struct StreamingAppPickerSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
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
                    HStack(alignment: .top){
                        Text(LocalizedStringKey("FavoriteStreamingApps"))
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button{
                            // Dismiss the full screen
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.title)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .clear)
                                .background(.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                    .padding([.top, .bottom])
                    
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
        }
    }
    
}

#Preview {
    StreamingAppPickerSheet()
}
