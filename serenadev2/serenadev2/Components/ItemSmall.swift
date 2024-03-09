//
//  ItemSmall.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 20/02/24.
//

import SwiftUI
import Kingfisher

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
            if(!item.isPerson) {
                KFImage(item.song?.artworkUrlSmall)
                    .placeholder { progress in
                        Image("no-artwork")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(width: 50, height: 50)
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(width: 50, height: 50)
            } else {
                if let user = item.user {
                    if let asset = user.profilePictureAsset {
                        AsyncImage(url: asset.fileURL) { phase in
                            switch phase {
                            case .success(let img):
                                img
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())

                            default:
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                        }
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    
                }
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
                    .padding()
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
