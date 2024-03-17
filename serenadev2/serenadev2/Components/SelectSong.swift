//
//  SelectSong.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import SwiftUI

struct SelectSong: View {
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Properties
    var action: () -> Void

    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.title3)
                Text(LocalizedStringKey("SelectSong"))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.body)
                    .fontWeight(.semibold)
                
                Spacer()
                
            }
            .padding(30) // Add some padding inside the button
            .overlay(
                RoundedRectangle(cornerRadius: 10) // The shape of the border
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [1, 4])) // The dashed style
                    .foregroundColor(colorScheme == .dark ? .white : .black)// The color of the dashed border
            )
        }
        .foregroundColor(.white) // The color of the content (icon and text)
    }
}

#Preview {
    SelectSong(){
        print("Hello")
    }
}
