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
    
    // MARK: - Properties
    // Audio URL (will be added to Song)?
    var song: SongModel
    var seconds: Double = 15.0
    
    // MARK: - Body
    var body: some View {
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
                    // Art work of the passed song
                    SongDetailCoverArt(coverArt: song.artworkUrlLarge!, mainColor: Color(song.bgColor!))
                    
                    // Info of the passed song
                    SongDetailTitleInfo(title: song.title, author: song.artists, fontColor: Color(hex: 0xffffff))
                    
                    Spacer()
                    
                    // View to play the preview of the passed song
                    PreviewPlayer(mainColor: Color(song.bgColor!), audioURL: song.previewUrl!, seconds: seconds)
                    
                    Spacer()
                    
                    // Daily and open with buttons
                    VStack(spacing: 15){
                        
                        // Daily button
                        ActionButton(label: "Daily", symbolName: "waveform", fontColor: .black, backgroundColor: .white.opacity(0.8), isShareDaily: false) {
                            print("Daily button tapped")
                        }
                        
                        // Open with button
                        ActionButton(label: "Open with", symbolName: "arrow.up.forward.circle.fill", fontColor: Color(song.priColor!), backgroundColor: Color(song.bgColor!), isShareDaily: false) {
                            print("Daily button tapped")
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
    SongDetailView(song: SongModel(
        id: "1",
        title: "Robbers",
        artists: "The 1975",
        artworkUrlSmall: URL(string: "https://example.com/small.jpg"),
        artworkUrlLarge: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/f4/bc/71/f4bc7194-a92a-8f73-1b81-154adc503ecb/00602537497119.rgb.jpg/1500x1500bb.jpg"),
        bgColor: CGColor(srgbRed: 0.12549, green: 0.12549, blue: 0.12549, alpha: 1),
        priColor: CGColor(srgbRed: 0.898039, green: 0.894118, blue: 0.886275, alpha: 1),
        secColor: CGColor(srgbRed: 0.815686, green: 0.807843, blue: 0.8, alpha: 1),
        terColor: CGColor(srgbRed: 0.745098, green: 0.741176, blue: 0.733333, alpha: 1),
        quaColor: CGColor(srgbRed: 0.67451, green: 0.670588, blue: 0.662745, alpha: 1),
        previewUrl: URL(string: "https://example.com/preview.mp3"),
        duration: 295.502,
        composerName: "Greg Kurstin & Adele Adkins",
        genreNames: ["Pop"],
        releaseDate: Date(timeIntervalSince1970: 1445558400)))
}
