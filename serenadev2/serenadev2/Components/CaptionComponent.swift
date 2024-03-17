//
//  Caption.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import SwiftUI

struct CaptionComponent: View {
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    @Binding var caption: String
    @Binding var characterLimit: Int
    var isSongFromDaily: Bool
    @FocusState.Binding var isTextEditorFocused : Bool
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.card) // Change this to your actual color variable
                TextEditor(text: $caption)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    .padding(4)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear) // Set background color to clear
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .focused($isTextEditorFocused)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onChange(of: caption) {
                        if caption.count > characterLimit {
                            caption = String(caption.prefix(characterLimit))
                        }
                    }
                
                if caption.isEmpty {
                    Text(LocalizedStringKey ("PlaceholderCaption"))
                        .font(.subheadline)
                        .foregroundColor(.callout) // Placeholder text color
                        .padding()
                        .opacity(isTextEditorFocused ? 0 : 1)
                }
            }
            .frame(width: geo.size.width, height: isSongFromDaily ? geo.size.height * 2/7 : max(geo.size.height * 2/7, 100))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                isTextEditorFocused = true
                print($isTextEditorFocused)
            }
        }
    }
}
