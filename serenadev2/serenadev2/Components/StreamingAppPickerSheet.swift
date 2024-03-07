//
//  StreamingAppPickerSheet.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 27/02/24.
//

import SwiftUI

struct StreamingAppPickerSheet: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var selectedAppleMusic = UserDefaults.standard.bool(forKey: "selectedAppleMusic")
    @State var selectedSpotify = UserDefaults.standard.bool(forKey: "selectedSpotify")
    @State var selectedYouTubeMusic = UserDefaults.standard.bool(forKey: "selectedYouTubeMusic")
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(LocalizedStringKey("FavoriteStreamingApps"))
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Button {
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
                    
                    ChecklistItem(selected: $selectedAppleMusic, image: "AppleMusicAppIcon", label: "Apple Music", key: "selectedAppleMusic", disableIfLastOne: true)
                    ChecklistItem(selected: $selectedSpotify, image: "SpotifyAppIcon", label: "Spotify", key: "selectedSpotify", disableIfLastOne: true)
                    ChecklistItem(selected: $selectedYouTubeMusic, image: "YouTubeMusicAppIcon", label: "YouTube Music", key: "selectedYouTubeMusic", disableIfLastOne: true)
                }
                .padding(.horizontal)
            }
        }
        .onAppear {
            // Asegurarse de que al menos una opción esté activa
            if !selectedAppleMusic && !selectedSpotify && !selectedYouTubeMusic {
                // Activa una opción por defecto (por ejemplo, Apple Music)
                selectedAppleMusic = true
                UserDefaults.standard.set(true, forKey: "selectedAppleMusic")
            }
        }
    }
}

#Preview {
    StreamingAppPickerSheet()
}
