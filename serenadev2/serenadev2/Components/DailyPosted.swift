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
            AsyncImage(url: song.artworkUrlSmall, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color((song.bgColor)!))
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing, 5)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing, 5)
                        .transition(.opacity.animation(.easeIn(duration: 0.5)))
                case .failure(_):
                    Rectangle()
                        .fill(Color((song.bgColor)!))
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing, 5)
                default:
                    Rectangle()
                        .fill(Color((song.bgColor)!))
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .padding(.trailing, 5)
                }
            }
            
            VStack(alignment: .leading){
                Text(LocalizedStringKey("YourDailySong"))
                    .font(.caption2)
                    .foregroundStyle(.callout)
                
                // Song title of the passed song
                Text(song.title)
                    .font(.footnote)
                    .bold()
                
                // Song artist of the passed song
                Text(song.artists)
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
            SongDetailView(song: song)
        }
        
    }
}

#Preview {
    DailyPosted(song: SongModel(
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
        previewUrl: URL(string: "https://example.com/preview.mp3"), albumTitle: "",
        duration: 295.502,
        composerName: "Greg Kurstin & Adele Adkins",
        genreNames: ["Pop"],
        releaseDate: Date(timeIntervalSince1970: 1445558400)))
}
