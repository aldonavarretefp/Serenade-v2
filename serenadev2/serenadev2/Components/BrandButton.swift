//
//  BrandButton.swift
//  serenadev2
//
//  Created by Pedro Daniel Rouin Salazar on 22/02/24.
//

import SwiftUI
import MusicKit

// Struct definition for a custom brand button
struct BrandButton : View {
    
    // Environment property to detect color scheme
    @Environment(\.colorScheme) private var colorScheme
    
    // Properties for button customization
    var label: String
    var brandLogo: String
    var fontColor: Color
    var endColor: Color
    var startColor: Color
    var action: () -> Void
    
    // Initializer for the brand button
    init(label: String, brandLogo: String, fontColor: Color,  startColor: Color, endColor: Color, action: @escaping () -> Void) {
        self.label = label
        self.brandLogo = brandLogo
        self.fontColor = fontColor
        self.endColor = endColor
        self.startColor = startColor
        self.action = action
    }
    
    // Body view for the brand button
    var body: some View {
        Button(action: action) {
            VStack{
                HStack {
                    // Geometry reader to adapt image size
                    GeometryReader { geo in
                        Image(brandLogo)
                            .padding(.top, 5)
                            .shadow(color: .black.opacity(0.13), radius: 10, x: 0.0, y: 8.0)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                // Background gradient for the button
                .background(
                    LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .top,
                                   endPoint: .bottom)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                // Label text for the button
                Text(label)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.footnote)
                    .fontWeight(.medium)
            }
        }
    }
}

// Enum to define different types of brand buttons
enum ButtonType: CaseIterable {
    case appleMusic
    case spotify
    case youtubeMusic
    case amazonMusic
    
    // Function to return configured brand buttons based on the enum case
    func configuration(songTitle: String, songArtist: String, songId: String) -> BrandButton{
        switch self {
        case .appleMusic:
            return BrandButton(label: "Apple Music", brandLogo: "AppleMusicBrandLogo", fontColor: .black, startColor: .appleMusicStart, endColor: .appleMusicEnd) {
                
                Task{
                    let albumID = await requestIDAlbum(songId: songId)
                    
                    DispatchQueue.main.async {
                        let urlString = "https://music.apple.com/us/album/\(albumID)?i=\(songId)"
                        if let url = URL(string: urlString), !albumID.isEmpty {
                            UIApplication.shared.open(url)
                        } else {
                            // Handle error, e.g., show an alert
                            print("Invalid URL or Album ID")
                        }
                    }
                }
            }
        case .spotify:
            return BrandButton(label: "Spotify", brandLogo: "SpotifyBrandLogo", fontColor: .black, startColor: .spotifyStart, endColor: .spotifyEnd) {
                
                if let encodedArtist = songArtist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let encodedTitle = songTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    
                    let urlString = "https://open.spotify.com/search/\(encodedTitle)%20\(encodedArtist)"
                    
                    guard let spotifyUrl = URL(string: urlString) else { return }
                    UIApplication.shared.open(spotifyUrl)
                } else {
                    print("Unable to create URL: Artist or title is nil")
                }
            }
        case .youtubeMusic:
            return BrandButton(label: "Youtube Music", brandLogo: "YoutubeBrandLogo", fontColor: .black, startColor: .youtubeMusicStart, endColor: .youtubeMusicEnd) {
                
                if let encodedArtist = songArtist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let encodedTitle = songTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    
                    let urlString = "https://music.youtube.com/search?q=\(encodedTitle)%20\(encodedArtist)"
                    guard let youtubeMusicUrl = URL(string: urlString) else { return }
                    UIApplication.shared.open(youtubeMusicUrl)
                } else {
                    print("Unable to create URL: Artist or title is nil")
                }
            }
        case .amazonMusic:
            return BrandButton(label: "Amazon Music", brandLogo: "AmazonMusicBrandLogo", fontColor: .black, startColor: .amazonMusicStart, endColor: .amazonMusicEnd) {
                
                if let encodedArtist = songArtist.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                   let encodedTitle = songTitle.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    
                    let urlString = "https://music.amazon.com/search/\(encodedTitle)%20\(encodedArtist)?filter=IsLibrary%7Cfalse&sc=none"
                    print(urlString)
                    guard let amazonMusicUrl = URL(string: urlString) else { return }
                    UIApplication.shared.open(amazonMusicUrl)
                } else {
                    print("Unable to create URL: Artist or title is nil")
                }
                
            }
        }
    }
    
}

func requestIDAlbum(songId: String) async -> String{
    do {
        // Replace 'songID' with your specific song's identifier
        let songs = try await MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(rawValue: songId)).response()
        
        // Assuming the song exists and has an album
        if let song = songs.items.first{
            let detailedSong = try await song.with([.albums])
            if let album = detailedSong.albums?.first {
                return album.id.rawValue
            }
        } else {
            print("Song or album not found.")
        }
    } catch {
        print("An error occurred: \(error.localizedDescription)")
    }
    return ""
}

// Extension to UIScreen to get screen dimensions
extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

// Preview code for BrandButton
#Preview {
    BrandButton(label: "Amazon Music", brandLogo: "AmazonMusicBrandLogo", fontColor: .black, startColor: .amazonMusicStart, endColor: .amazonMusicEnd) {
        print("Open Amazon Music")
    }
}

