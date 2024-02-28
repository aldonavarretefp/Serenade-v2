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
    
    
    @State var isDailySheetDisplayed: Bool = false
    @State var isOpenWithSheetDisplayed: Bool = false
    
    // MARK: - Properties
    // Audio URL (will be added to Song)?
    var audioURL: URL
    var song: Song
    var seconds: Double = 15.0
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ZStack{
                
                // Gradients to add the art work color to the background
                LinearGradient(gradient: Gradient(colors: [song.color, Color(hex: 0x101010)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
                LinearGradient(gradient: Gradient(colors: [song.color, Color(hex: 0x101010).opacity(0)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
                
                VStack{
                    // Art work of the passed song
                    SongDetailCoverArt(covertArt: song.coverArt, mainColor: song.color)
                    
                    // Info of the passed song
                    SongDetailTitleInfo(title: song.title, author: song.artist, fontColor: Color(hex: 0xffffff))
                    
                    Spacer()
                    
                    // View to play the preview of the passed song
                    PreviewPlayer(mainColor: song.color, audioURL: audioURL, seconds: seconds)
                    
                    Spacer()
                    
                    // Daily and open with buttons
                    VStack(spacing: 15){
                        
                        // Daily button
                        ActionButton(label: "Daily", symbolName: "waveform", fontColor: .black, backgroundColor: .white.opacity(0.8), isShareDaily: false, isDisabled: false) {
                            isDailySheetDisplayed.toggle()
                            
                        }
                        .sheet(isPresented: $isDailySheetDisplayed){
                            DailySongView(song: song, isSongFromDaily: false)
                                .presentationDetents([.fraction(0.7)])
                        }
                        
                        // Open with button
                        ActionButton(label: "Open with", symbolName: "arrow.up.forward.circle.fill", fontColor: song.fontColor, backgroundColor: song.color, isShareDaily: false, isDisabled: false) {
                            isOpenWithSheetDisplayed.toggle()
                        }.sheet(isPresented: $isOpenWithSheetDisplayed){
                            OpenWithView(buttonTypes: [.appleMusic, .spotify, .youtubeMusic, .amazonMusic])
                                .presentationDetents([.fraction(0.55)])
                        }
                        
                    }
                    .padding()
                    
                }
            }
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
    SongDetailView(audioURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/38/be/54/38be54d8-7411-fe31-e15f-c85e7d8515e8/mzaf_15200620892322734212.plus.aac.p.m4a")!, song: Song(id: "id", title: "Robbers", artist: "The 1975", album: "After Hours", coverArt: "the19", color: Color(hex: 0x202020), fontColor: Color(hex: 0xffffff)))
}
