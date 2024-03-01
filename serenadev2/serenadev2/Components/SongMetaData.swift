//
//  SongInfo.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 29/02/24.
//

import SwiftUI

struct SongMetaData: View {
    
    var song: SongModel
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        if let releaseDate = song.releaseDate {
            return dateFormatter.string(from: releaseDate)
        } else {
            return ""
        }
    }
    
    var formattedDuration: String {
        if let duration = song.duration {
            let minutes = Int(duration) / 60
            let seconds = Int(duration) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        } else {
            return ""
        }
    }
    
    var body: some View {
        VStack{
            Text("Song information")
                .font(.headline)
                .bold()
            
            ScrollView(showsIndicators: false){
                HStack{
                    VStack(alignment: .leading, spacing: 15){
                        // Release date
                        if formattedDuration != "" {
                            VStack(alignment: .leading){
                                Text("Release date")
                                    .fontWeight(.semibold)
                                
                                Text(formattedDate)
                                    .font(.subheadline)
                            }
                        }
                        
                        // Written by
                        if let composerName = song.composerName {
                            VStack(alignment: .leading){
                                Text("Written by")
                                    .fontWeight(.semibold)
                                
                                Text(composerName)
                                    .font(.subheadline)
                            }
                        }
                        
                        // Song duration
                        if formattedDuration != "" {
                            VStack(alignment: .leading){
                                Text("Duration")
                                    .fontWeight(.semibold)
                                
                                Text(formattedDuration)
                                    .font(.subheadline)
                            }
                        }
                        
                        // Song genre/s
                        if song.genreNames.count != 0 {
                            VStack(alignment: .leading){
                                Text(song.genreNames.count == 1 ? "Genre" : "Genres")
                                    .fontWeight(.semibold)
                                
                                ForEach(song.genreNames.indices, id: \.self) { index in
                                    Text(song.genreNames[index])
                                }
                                .font(.subheadline)
                            }
                        }
                        
                        // Album
                        if song.albumTitle != "" {
                            VStack(alignment: .leading){
                                Text("Album")
                                    .fontWeight(.semibold)
                                
                                Text(song.albumTitle!)
                                    .font(.subheadline)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .scrollBounceBehavior(.basedOnSize, axes: [.vertical])
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .foregroundStyle(Color(song.priColor!))
    }
}

#Preview {
    SongMetaData(song: SongModel(
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
        genreNames: ["Pop", "Funk"],
        releaseDate: Date(timeIntervalSince1970: 1445558400)))
}
