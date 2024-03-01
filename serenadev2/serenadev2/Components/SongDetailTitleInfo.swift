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
    var isMetaDataDisplayed: Bool
    var receivedAction: () -> Void
    
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
            
            Button(action: receivedAction){
                Image(systemName: "info.circle")
                    .font(.title3)
            }
            .buttonStyle(.plain)
            .padding(5)
            .background(isMetaDataDisplayed == true ? .white : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding([.leading, .top, .bottom])
            .foregroundStyle(isMetaDataDisplayed == true ? .black : .white)
        }
        .foregroundStyle(fontColor)
    }
}

#Preview {
    SongDetailTitleInfo(title: "Save your tears", author: "The weeknd", fontColor: .white, isMetaDataDisplayed: false){
        print("Hello")
    }
}
