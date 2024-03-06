//
//  ItemSmall.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 20/02/24.
//

import SwiftUI

struct ContentItem: Identifiable {
    let id = UUID()
    var isPerson: Bool// True for person, false for song
    var song: SongModel?
    var user: User? 
}

struct ItemSmall: View {
    var item: ContentItem
    var showArrow: Bool
    var showXMark: Bool
    var comesFromDaily: Bool
    var xMarkAction: (() -> Void)?
    
    init(item: ContentItem, showArrow: Bool = false, showXMark: Bool = false, comesFromDaily: Bool = false, xMarkAction: (() -> Void)? = nil) {
        self.item = item
        self.showArrow = showArrow
        self.showXMark = showXMark
        self.comesFromDaily = comesFromDaily
        self.xMarkAction = xMarkAction // Asignamos la acción del botón X al cierre
    }
    
    var body: some View {
        HStack {
            if(item.isPerson){
                AsyncImage(url: item.song?.artworkUrlSmall) { phase in
                    switch phase {
                    case .empty:
                        // Displays a loading animation while the image is being fetched
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5) // Adjust the size of the ProgressView as needed
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure(_):
                        // Displays a placeholder in case of failure to load the image
                        Color.gray
                    @unknown default:
                        // Fallback for future cases
                        EmptyView()
                    }
                }
                .if(item.isPerson) { view in
                    view.clipShape(Circle())
                }
                .if(!item.isPerson) { view in
                    view.clipShape(RoundedRectangle(cornerRadius: 5))
                }
                .frame(width: 50, height: 50)
            } else {
                // Provide a fallback view or image here if imageUrl is nil
                Color.gray.frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading, spacing: 4){
                Text(item.isPerson ? (item.user?.name ?? "No name") : item.song?.title ?? "Unknown Song Title")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                Text(item.isPerson ? (item.user?.tagName ?? "No tagname") : (item.song?.artists ?? "Unknown Artists"))
                    .font(.caption)
                    .foregroundStyle(.callout)
                    .lineLimit(2)
            }
            
            Spacer()
            
            if showArrow {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
            if showXMark {
                Button(action: xMarkAction!) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
                .padding()
                
            }
        }
        .background(comesFromDaily == true ? .clear : .viewBackground)
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
