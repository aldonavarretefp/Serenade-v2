//
//  SongDetailTitleInfo.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI

struct SongDetailTitleInfo: View {
    
    // MARK: - Properties
    var title: String
    var author: String
    var fontColor: Color
    
    // MARK: - Body
    var body: some View {
        HStack(){
            VStack(alignment: .leading, spacing: 5){
                
                // Song of the song
                Text(title)
                    .font(.headline)
                    .bold()
                    .lineLimit(2)
                
                // Author of the song
                Text(author)
                    .font(.subheadline)
                    .lineLimit(1)
            }
            
            Spacer()
                
            
            Button{
                // Add view with the song info if needed
            } label: {
                Image(systemName: "info.circle")
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .padding([.leading, .top, .bottom])
        }
        .padding(.horizontal)
        .foregroundStyle(fontColor)
    }
}

#Preview {
    SongDetailTitleInfo(title: "Save your tears", author: "The weeknd", fontColor: .white)
}
