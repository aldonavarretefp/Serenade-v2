//
//  DailyPosted.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 25/02/24.
//

import SwiftUI

struct DailyPosted: View {
    
    // MARK: - Environment properties
    // Color scheme of the phone
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    var song: SongModel
    @State var isSongInfoDisplayed: Bool = false
    
    // MARK: - Body
    var body: some View{
        HStack{
            
            // Art work of the passed song
            Image(song.coverArt)
                .resizable()
                .frame(width: 50, height: 50)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .padding(.trailing, 5)
            
            VStack(alignment: .leading){
                Text("Your daily song")
                    .font(.caption2)
                    .foregroundStyle(.callout)
                
                // Song title of the passed song
                Text(song.title)
                    .font(.footnote)
                    .bold()
                
                // Song artist of the passed song
                Text(song.artist)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.callout)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        // On tap gesture to open the info of the passed song
        .onTapGesture {
            isSongInfoDisplayed = true
        }
        .fullScreenCover(isPresented: $isSongInfoDisplayed){
            SongDetailView(audioURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview122/v4/72/a3/ab/72a3ab79-0066-f773-6618-7a53adc250b3/mzaf_17921540907592750976.plus.aac.p.m4a")!, song: song)
        }
        
    }
}

#Preview {
    DailyPosted(song: SongModel(id: "5", title: "See you again (feat. Kali Uchis)", artist: "Tyler, The Creator, Kali Uchis", album: "Flowerboy", coverArt: "tyler", color: Color(hex: 0xD5881C), fontColor: Color(hex: 0xffffff)))
}
