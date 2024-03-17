//
//  SongDetailView.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI

struct SongDetailView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var postViewModel: PostViewModel
    @StateObject private var songViewModel = SongDetailViewModel()
    @StateObject private var loadingStateViewModel = LoadingStateViewModel()
    
    // MARK: - Environment properties
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Properties
    var song: SongModel
    // Status of the daily sheet
    @State var isDailySheetDisplayed: Bool = false
    
    // Status of the open with sheet
    @State var isOpenWithSheetDisplayed: Bool = false
    
    // Opacity of the meta data
    @State var metaDataOpacity = 0.0
    
    // Create an instance of PreviewPlayer once
    let previewPlayer: PreviewPlayer
    
    // Initialization of the preview player and the received song
    init(song: SongModel) {
        self.song = song
        self.previewPlayer = PreviewPlayer(mainColor: Color(song.bgColor!), audioURL: song.previewUrl!, fontColor: Color(song.priColor!), secondaryColor: Color(song.secColor!), seconds: 15)
    }
    
    // Screen width of the device
    let screenWidth = UIScreen.screenWidth
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ZStack{
                // Gradients to add the artwork color to the background
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
                            .environmentObject(loadingStateViewModel)
                            .onAppear {
                                // Set isLoading to true when the view appears
                                loadingStateViewModel.isLoading = true
                            }
                        
                        // Song meta data
                        ZStack{
                            Rectangle()
                                .fill(Color(song.bgColor!).opacity(0.7))
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            SongMetaData(song: song)
                                .padding(.vertical, 10)
                        }
                        .opacity(metaDataOpacity)
                        .frame(width: screenWidth - 32, height: screenWidth - 32)
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
                        .environmentObject(loadingStateViewModel)
                    
                    Spacer()
                    
                    // Daily and open with buttons
                    VStack(spacing: 15){
                        // Daily button
                        ActionButton(label: LocalizedStringKey("Daily"), symbolName: "waveform", fontColor: .black, backgroundColor: .white.opacity(0.8), isShareDaily: false, isDisabled: postViewModel.isDailyPosted) {
                            isDailySheetDisplayed.toggle()
                        }
                        .sheet(isPresented: $isDailySheetDisplayed){
                            DailySongView(selectedSongBinding: song, isSongFromDaily: false)
                                .presentationDetents([.fraction(0.7)])
                        }
                        
                        
                        // Open with button
                        // If the user selects more than one favorite app open the open with sheet
                        if songViewModel.selectedStreamingApps.count != 1 {
                            ActionButton(label: LocalizedStringKey("OpenWith"), symbolName: "arrow.up.forward.circle.fill", fontColor: Color(song.priColor!), backgroundColor: Color(song.bgColor!), isShareDaily: false, isDisabled: false) {
                                isOpenWithSheetDisplayed.toggle()
                            }.sheet(isPresented: $isOpenWithSheetDisplayed){
                                OpenWithView(buttonTypes: [.appleMusic, .spotify, .youtubeMusic], songTitle: song.title, songArtist: song.artists, songId: song.id)
                                    .presentationDetents([.fraction(0.4)])
                            }
                        } else {
                            // The user selected just one favorite streaming app
                            ActionButton(label: songViewModel.buttonText, symbolName: "arrow.up.forward.circle.fill", fontColor: Color(song.priColor!), backgroundColor: Color(song.bgColor!), isShareDaily: false, isDisabled: false) {
                                songViewModel.openWithAction(self.song)
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
        .alert(isPresented: Binding<Bool>(
            get: { songViewModel.alertMessage != nil },
            set: { _ in songViewModel.alertMessage = nil }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(songViewModel.alertMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

// MARK: - Preview
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
