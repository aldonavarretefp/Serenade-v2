//
//  SongDetailCoverArt.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI

struct SongDetailCoverArt: View {
    
    // MARK: - Properties
    var song: SongModel
    
    @Binding var isMetaDataDisplayed: Bool
    
    // MARK: - Body
    var body: some View {
        
        let screenWidth = UIScreen.main.bounds.width
        
        ZStack{
            // Background song cover art
            AsyncImage(url: song.artworkUrlLarge, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color(song.bgColor!).opacity(0.5))
                        .frame(width: screenWidth, height: screenWidth)
                        .blur(radius: 30)
                        .scaleEffect(1.1)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        .overlay(
                            LinearGradient(gradient: Gradient(colors: [Color.clear.opacity(0.4), Color.black.opacity(0.4)]),
                                           startPoint: .bottom,
                                           endPoint: .top)
                        )
                        .blur(radius: 30)
                        .scaleEffect(1.1)
                        .transition(.opacity.animation(.easeIn(duration: 0.5)))
                case .failure(_):
                    Rectangle()
                        .fill(Color(song.bgColor!).opacity(0.5))
                        .frame(width: screenWidth, height: screenWidth)
                        .blur(radius: 30)
                        .scaleEffect(1.1)
                default:
                    Rectangle()
                        .fill(Color(song.bgColor!).opacity(0.5))
                        .frame(width: screenWidth, height: screenWidth)
                        .blur(radius: 30)
                        .scaleEffect(1.1)
                }
            }
            
            // Front song cover art
            AsyncImage(url: song.artworkUrlLarge, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color(song.bgColor!).opacity(0.8))
                        .frame(width: screenWidth - 32, height: screenWidth - 32)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(song.bgColor!), lineWidth: 0.5)
                        )
                        .shadow(color: .black.opacity(0.13), radius: 18, x: 0, y: 8)
                        .padding()
                        .transition(.opacity.animation(.easeIn(duration: 0.5)))
                case .failure(_):
                    Rectangle()
                        .fill(Color(song.bgColor!).opacity(0.8))
                        .frame(width: screenWidth - 32, height: screenWidth - 32)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                default:
                    Rectangle()
                        .fill(Color(song.bgColor!).opacity(0.8))
                        .frame(width: screenWidth - 32, height: screenWidth - 32)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            if isMetaDataDisplayed {
                ZStack{
                    Rectangle()
                        .fill(Color(song.bgColor!).opacity(0.7))
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    SongMetaData(song: song)
                        .padding(.top, 10)
                }
                .frame(height: screenWidth - 32)
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    SongDetailCoverArt(song: SongModel(
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
        previewUrl: URL(string: "https://example.com/preview.mp3"), albumTitle: "The 1975",
        duration: 295.502,
        composerName: "Greg Kurstin & Adele Adkins",
        genreNames: ["Pop"],
        releaseDate: Date(timeIntervalSince1970: 1445558400)), isMetaDataDisplayed: .constant(false))
}

