//
//  SongDetailCoverArt.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI

struct SongDetailCoverArt: View {
    
    // MARK: - Properties
    var coverArt: URL
    var mainColor: Color
    
    // MARK: - Body
    var body: some View {
        
        let screenWidth = UIScreen.main.bounds.width
        
        ZStack{
            
            // Background song cover art
            AsyncImage(url: coverArt, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(mainColor.opacity(0.5))
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
                    EmptyView()
                default:
                    EmptyView()
                }
            }
            
            
            // Front song cover art
            AsyncImage(url: coverArt, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(mainColor.opacity(0.8))
                        .frame(width: screenWidth - 32, height: screenWidth - 32)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(mainColor, lineWidth: 0.5)
                        )
                        .shadow(color: .black.opacity(0.13), radius: 18, x: 0, y: 8)
                        .padding()
                        .transition(.opacity.animation(.easeIn(duration: 0.5)))
                case .failure(_):
                    EmptyView()
                default:
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    SongDetailCoverArt(coverArt: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/f4/bc/71/f4bc7194-a92a-8f73-1b81-154adc503ecb/00602537497119.rgb.jpg/1500x1500bb.jpg")!, mainColor: Color(hex: 0x202020))
}
