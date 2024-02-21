//
//  SongDetailTitleInfo.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI

struct SongDetailTitleInfo: View {
    
    var title: String
    var author: String
    var fontColor: Color
    
    var body: some View {
        HStack(){
            VStack(alignment: .leading, spacing: 5){
                Text(title)
                    .font(.title3)
                    .bold()
                
                Text(author)
            }
            
            Spacer()
            
            Button{
                
            } label: {
                Image(systemName: "info.circle")
                    .font(.title3)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .foregroundStyle(fontColor)
    }
}

#Preview {
    SongDetailTitleInfo(title: "Save your tears", author: "The weeknd", fontColor: .black)
}
