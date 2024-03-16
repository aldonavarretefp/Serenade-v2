//
//  SongDetailViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 16/03/24.
//

import Foundation
import SwiftUI

final class SongDetailViewModel: ObservableObject {
    
    // MARK: - Properties
    // Status of the daily sheet
    @Published var isDailySheetDisplayed: Bool = false
    
    // Status of the open with sheet
    @Published var isOpenWithSheetDisplayed: Bool = false
    
    // Opacity of the meta data
    @Published var metaDataOpacity = 0.0
    
    @Published var alertMessage: String?
    
    // Get the user favorite streaming apps
    @Published var selectedStreamingApps: [ButtonType] = [.appleMusic, .spotify, .youtubeMusic].filter {
        if $0 == .appleMusic {
            return UserDefaults.standard.bool(forKey: "selectedAppleMusic")
        } else if $0 == .spotify {
            return UserDefaults.standard.bool(forKey: "selectedSpotify")
        } else if $0 == .youtubeMusic {
            return UserDefaults.standard.bool(forKey: "selectedYouTubeMusic")
        } else {
            return false
        }
    }
    
    var buttonText: LocalizedStringKey {
        if selectedStreamingApps.count == 1 {
            switch selectedStreamingApps[0] {
            case .appleMusic:
                return LocalizedStringKey("OpenWithAppleMusic")
            case .spotify:
                return LocalizedStringKey("OpenWithSpotify")
            case .youtubeMusic:
                return LocalizedStringKey("OpenWithYouTubeMusic")
            case .amazonMusic:
                return LocalizedStringKey("OpenWithAmazonMusic")
            }
        } else {
            return "Open With"
        }
    }
    
    // MARK: - Functions
    // Action to do when pressing the open with button
    func openWithAction(_ song: SongModel) {
        if selectedStreamingApps.count != 1 {
            toggleOpenWithSheet()
        } else {
            guard let streamingApp = self.selectedStreamingApps.first else { return }
            
            switch streamingApp {
            case .appleMusic:
                openWithAppleMusic(song: song)
            case .spotify:
                openWithSpotify(song: song)
            case .youtubeMusic:
                openWithYouTubeMusic(song: song)
            case .amazonMusic:
                openWithAmazonMusic(song: song)
            }
        }
    }
    
    // Open the song using Apple Music
    private func openWithAppleMusic(song: SongModel) {
        Task {
            let albumID = await requestIDAlbum(songId: song.id)
            DispatchQueue.main.async {
                let urlString = "https://music.apple.com/us/album/\(albumID)?i=\(song.id)"
                if let url = URL(string: urlString), !albumID.isEmpty {
                    UIApplication.shared.open(url)
                } else {
                    // Handle error, e.g., show an alert
                    print("Oops! Something went wrong while trying to open the song. Please try again later.")
                }
            }
        }
    }
    
    // Open the song using Spotify
    private func openWithSpotify(song: SongModel) {
        guard let encodedArtist = song.artists.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedTitle = song.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Unable to create URL: Artist or title is nil")
            self.alertMessage = "Oops! Something went wrong while trying to open the song. Please try again later."
            return
        }
        
        let urlString = "https://open.spotify.com/search/\(encodedTitle)%20\(encodedArtist)"
        guard let spotifyUrl = URL(string: urlString) else {
            print("Error: Invalid URL")
            self.alertMessage = "Oops! Something went wrong while trying to open the song. Please try again later."
            return
        }
        
        UIApplication.shared.open(spotifyUrl)
    }
    
    // Open the song using YouTube Music
    private func openWithYouTubeMusic(song: SongModel) {
        guard let encodedArtist = song.artists.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedTitle = song.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Unable to create URL: Artist or title is nil")
            self.alertMessage = "Oops! Something went wrong while trying to open the song. Please try again later."
            return
        }
        
        let urlString = "https://music.youtube.com/search?q=\(encodedTitle)%20\(encodedArtist)"
        guard let youtubeMusicUrl = URL(string: urlString) else {
            print("Error: Invalid URL")
            self.alertMessage = "Oops! Something went wrong while trying to open the song. Please try again later."
            return
        }
        UIApplication.shared.open(youtubeMusicUrl)
    }
    
    // Open the song using Amazon Music
    private func openWithAmazonMusic(song: SongModel) {
        guard let encodedArtist = song.artists.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let encodedTitle = song.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Unable to create URL: Artist or title is nil")
            self.alertMessage = "Oops! Something went wrong while trying to open the song. Please try again later."
            return
        }
        
        let urlString = "https://music.amazon.com/search/\(encodedTitle)%20\(encodedArtist)?filter=IsLibrary%7Cfalse&sc=none"
        guard let amazonMusicUrl = URL(string: urlString) else {
            print("Error: Invalid URL")
            self.alertMessage = "Oops! Something went wrong while trying to open the song. Please try again later."
            return
        }
        UIApplication.shared.open(amazonMusicUrl)
    }
    
    // Toggle to show the daily sheet
    func toggleDailySheet() {
        DispatchQueue.main.async {
            self.isDailySheetDisplayed.toggle()
        }
    }
    
    // Toggle to show the open with sheet
    func toggleOpenWithSheet() {
        DispatchQueue.main.async {
            self.isOpenWithSheetDisplayed.toggle()
        }
    }
}
