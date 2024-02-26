//
//  SongDetailCoverArt.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI

struct SongDetailCoverArt: View {
    
    // MARK: - Properties
    var covertArt: String
    var mainColor: Color
    
    // MARK: - Body
    var body: some View {
        ZStack{
            // Background song cover art
            Image(covertArt)
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
            
            
            // Front song cover art
            Image(covertArt)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(mainColor, lineWidth: 0.5)
                )
                .shadow(color: .black.opacity(0.13), radius: 18, x: 0, y: 8)
                .padding()
        }
    }
}

#Preview {
    SongDetailCoverArt(covertArt: "entropy", mainColor: Color(hex: 0xAEA6F6))
}
