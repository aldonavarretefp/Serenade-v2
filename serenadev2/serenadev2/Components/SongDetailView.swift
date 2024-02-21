//
//  SongDetailView.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI

struct SongDetailView: View {
    
    // URL del audio
    var audioURL: URL
    
    var coverArt: String
    var title: String
    var author: String
    var color: Color
    var fontColor: Color
    var seconds: Double = 15.0
    
    var body: some View {
        NavigationStack{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [color, Color(hex: 0x101010)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
                
                LinearGradient(gradient: Gradient(colors: [color, Color(hex: 0x101010).opacity(0)]),
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                
                
                VStack{
                    SongDetailCoverArt(covertArt: coverArt, mainColor: color)
                    
                    
                    SongDetailTitleInfo(title: title, author: author, fontColor: Color(hex: 0xffffff))
                    
                    Spacer()
                    
                    PreviewPlayer(mainColor: color, audioURL: audioURL, seconds: seconds)
                    
                    Spacer()
                    
                    
                    VStack(spacing: 15){
                        
                        ActionButton(label: "Daily", symbolName: "waveform", fontColor: .black, backgroundColor: .white.opacity(0.8), isShareDaily: false) {
                            print("Daily button tapped")
                        }
                        
                        ActionButton(label: "Open with", symbolName: "arrow.up.forward.circle.fill", fontColor: fontColor, backgroundColor: color, isShareDaily: false) {
                            print("Daily button tapped")
                        }
                    }
                    .padding()
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem{
                    
                    Image(systemName: "xmark.circle")
                        .font(.callout)
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.white, .clear)
                        .background(.black.opacity(0.2))
                        .clipShape(Circle())
                }
            }
        }
    }
}

#Preview {
    SongDetailView(audioURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/38/be/54/38be54d8-7411-fe31-e15f-c85e7d8515e8/mzaf_15200620892322734212.plus.aac.p.m4a")!, coverArt: "entropy", title: "Entropy", author: "Beach bunny", color: Color(hex: 0xAEA6F6), fontColor: Color(hex: 0x202020))
}
