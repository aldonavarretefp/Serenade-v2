//
//  SongDetailView.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI

struct SongDetailView: View {
    
    // MARK: - Environment properties
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var postViewModel: PostViewModel
    
    @State var isDailySheetDisplayed: Bool = false
    @State var isOpenWithSheetDisplayed: Bool = false
    
    // MARK: - Properties
    var song: SongModel
    var seconds: Double = 15.0
    
    @State var metaDataOpacity = 0.0
    
    // Create an instance of PreviewPlayer once
    let previewPlayer: PreviewPlayer
    
    // Initialization of the preview player
    init(song: SongModel) {
        self.song = song
        self.previewPlayer = PreviewPlayer(mainColor: Color(song.bgColor!), audioURL: song.previewUrl!, fontColor: Color(song.priColor!), secondaryColor: Color(song.secColor!), seconds: 15)
        
    }
    
    let selectedStreamingApps: [ButtonType] = [.appleMusic, .spotify, .youtubeMusic].filter {
        if $0 == .appleMusic {
            return UserDefaults.standard.bool(forKey: "selectedAppleMusic")
        } else if $0 == .spotify {
            return UserDefaults.standard.bool(forKey: "selectedSpotify")
        } else if $0 == .youtubeMusic {
            return UserDefaults.standard.bool(forKey: "selectedYouTubeMusic")
        } else {
            // Si ninguna de las condiciones anteriores se cumple, devolver false (o true según lo que necesites)
            return false
        }
    }
    
    @StateObject private var loadingState = LoadingState()
    
    
    // MARK: - Body
    var body: some View {
        
        let screenWidth = UIScreen.main.bounds.width
        
        NavigationStack{
            ZStack{
                // Gradients to add the art work color to the background
                LinearGradient(gradient: Gradient(colors: [Color(song.bgColor!), Color(hex: 0x101010)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
                LinearGradient(gradient: Gradient(colors: [Color(song.bgColor!), Color(hex: 0x101010).opacity(0)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
                
                VStack{
                    ZStack{
                        // Art work of the passed song
                        SongDetailCoverArt(song: song)
                            .environmentObject(loadingState)
                            .onAppear {
                                // Set isLoading to true when the view appears
                                self.loadingState.isLoading = true
                            }
                        
                        // Song meta data
                        ZStack{
                            Rectangle()
                                .fill(Color(song.bgColor!).opacity(0.7))
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            SongMetaData(song: song)
                                .padding([.top, .bottom], 10)
                        }
                        .opacity(metaDataOpacity)
                        .frame(height: screenWidth - 32)
                        .padding(.horizontal)
                    }
                    
                    // Info of the passed song
                    SongDetailTitleInfo(title: song.title, author: song.artists, fontColor: Color(hex: 0xffffff), isMetaDataDisplayed: metaDataOpacity == 1.0 ? true : false){
                        withAnimation(.linear(duration: 0.3)){
                            metaDataOpacity = metaDataOpacity == 1.0 ? 0.0 : 1.0
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // View to play the preview of the passed song
                    previewPlayer
                        .environmentObject(loadingState)
                    
                    Spacer()
                    
                    // Daily and open with buttons
                    VStack(spacing: 15){
                        // Daily button
                        
                        ActionButton(label: LocalizedStringKey("Daily"), symbolName: "waveform", fontColor: .black, backgroundColor: .white.opacity(0.8), isShareDaily: false, isDisabled: postViewModel.isDailyPosted) {
                            isDailySheetDisplayed.toggle()
                        }
                        .sheet(isPresented: $isDailySheetDisplayed){
                            DailySongView(song: song, isSongFromDaily: false)
                                .presentationDetents([.fraction(0.7)])
                        }
                        
                        
                        // Open with button
                        if selectedStreamingApps.count != 1 {
                            ActionButton(label: LocalizedStringKey("OpenWith"), symbolName: "arrow.up.forward.circle.fill", fontColor: Color(song.priColor!), backgroundColor: Color(song.bgColor!), isShareDaily: false, isDisabled: false) {
                                isOpenWithSheetDisplayed.toggle()
                            }.sheet(isPresented: $isOpenWithSheetDisplayed){
                                OpenWithView(buttonTypes: [.appleMusic, .spotify, .youtubeMusic], songTitle: song.title, songArtist: song.artists, songId: song.id)
                                    .presentationDetents([.fraction(0.4)])
                            }
                        } else {
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
                            
                            var openWithAction: (() -> Void)? {
                                if let streamingApp = selectedStreamingApps.first {
                                    switch streamingApp {
                                    case .appleMusic:
                                        return {
                                            Task {
                                                let albumID = await requestIDAlbum(songId: song.id)
                                                DispatchQueue.main.async {
                                                    let urlString = "https://music.apple.com/us/album/\(albumID)?i=\(song.id)"
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
                                        return {
                                            if let encodedArtist = song.artists.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                               let encodedTitle = song.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                                
                                                let urlString = "https://open.spotify.com/search/\(encodedTitle)%20\(encodedArtist)"
                                                
                                                guard let spotifyUrl = URL(string: urlString) else { return }
                                                UIApplication.shared.open(spotifyUrl)
                                            } else {
                                                print("Unable to create URL: Artist or title is nil")
                                            }
                                        }
                                    case .youtubeMusic:
                                        return {
                                            if let encodedArtist = song.artists.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                               let encodedTitle = song.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                                
                                                let urlString = "https://music.youtube.com/search?q=\(encodedTitle)%20\(encodedArtist)"
                                                guard let youtubeMusicUrl = URL(string: urlString) else { return }
                                                UIApplication.shared.open(youtubeMusicUrl)
                                            } else {
                                                print("Unable to create URL: Artist or title is nil")
                                            }
                                        }
                                    case .amazonMusic:
                                        return {
                                            if let encodedArtist = song.artists.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                                               let encodedTitle = song.title.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                                                
                                                let urlString = "https://music.amazon.com/search/\(encodedTitle)%20\(encodedArtist)?filter=IsLibrary%7Cfalse&sc=none"
                                                guard let amazonMusicUrl = URL(string: urlString) else { return }
                                                UIApplication.shared.open(amazonMusicUrl)
                                            } else {
                                                print("Unable to create URL: Artist or title is nil")
                                            }
                                        }
                                    }
                                } else {
                                    return nil
                                }
                            }
                            
                            ActionButton(label: buttonText, symbolName: "arrow.up.forward.circle.fill", fontColor: Color(song.priColor!), backgroundColor: Color(song.bgColor!), isShareDaily: false, isDisabled: false) {
                                if let openWithAction = openWithAction {
                                    openWithAction()
                                }
                            }
                        }
                        
                    }
                    .padding()
                    
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbar{
                // Add the xmark at top trailing
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        // Dismiss the full screen
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .clear)
                            .background(.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}


#Preview {
    SongDetailView(song: SongModel(
        id: "1",
        title: "Robbers",
        artists: "The 1975",
        artworkUrlSmall: URL(string: "https://example.com/small.jpg"), artworkUrlMedium: URL(string: "https://example.com/small.jpg"),
        artworkUrlLarge: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/f4/bc/71/f4bc7194-a92a-8f73-1b81-154adc503ecb/00602537497119.rgb.jpg/1500x1500bb.jpg"),
        bgColor: CGColor(srgbRed: 0.12549, green: 0.12549, blue: 0.12549, alpha: 1),
        priColor: CGColor(srgbRed: 0.898039, green: 0.894118, blue: 0.886275, alpha: 1),
        secColor: CGColor(srgbRed: 0.815686, green: 0.807843, blue: 0.8, alpha: 1),
        terColor: CGColor(srgbRed: 0.745098, green: 0.741176, blue: 0.733333, alpha: 1),
        quaColor: CGColor(srgbRed: 0.67451, green: 0.670588, blue: 0.662745, alpha: 1),
        previewUrl: URL(string: "https://example.com/preview.mp3"), albumTitle: "The 1975",
        duration: 295.502,
        composerName: "Greg Kurstin & Adele Adkins",
        genreNames: ["Pop"],
        releaseDate: Date(timeIntervalSince1970: 1445558400)))
}
