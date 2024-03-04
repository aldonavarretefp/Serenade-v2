//
//  ItemSmall.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 20/02/24.
//

import SwiftUI

struct ContentItem: Identifiable {
    let id = UUID()
    var imageUrl: URL?
    var title: String?
    var subtitle: String?
    var isPerson: Bool// True for person, false for song
    var song: SongModel?
    
}

struct ItemSmall: View {
    var item: ContentItem
    var showArrow: Bool
    var comesFromDaily: Bool
    
    init(item: ContentItem, showArrow: Bool = false, comesFromDaily: Bool = false) {
        self.item = item
        self.showArrow = showArrow
        self.comesFromDaily = comesFromDaily
    }
    
    var body: some View {
        HStack {
            if let imageUrl = item.isPerson ? item.imageUrl : item.song?.artworkUrlSmall {
                AsyncImage(url: imageUrl) { phase in
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
                Text(item.isPerson ? (item.title ?? "Unknown Title") : item.song?.title ?? "Unknown Song Title")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .lineLimit(2)

                    
                
                Text(item.isPerson ? (item.subtitle ?? "No Subtitle") : (item.song?.artists ?? "Unknown Artists"))
                    .font(.caption)
                    .foregroundStyle(.callout)
                    .lineLimit(2)
            }
            
            Spacer()
           
            if showArrow {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ItemSmall(item: ContentItem(imageUrl: URL(string: "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde"), title: "Fernando Fernández", subtitle: "janedoe", isPerson: true), showArrow: false)
                    .previewLayout(.sizeThatFits)
                    .previewDisplayName("Person Preview")
            
            ItemSmall(item: ContentItem(imageUrl: URL(string: "https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3"), title: "See you again (feat. Kali Uchis)", subtitle: "Tyler, The Creator, Kali Uchis", isPerson: false), showArrow: true)
                .previewLayout(.sizeThatFits)
                .previewDisplayName("Song Preview")
        }
    }
}
