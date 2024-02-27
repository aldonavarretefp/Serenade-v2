//
//  SelectSongView.swift
//  serenadev2
//
//  Created by Pedro Daniel Rouin Salazar on 27/02/24.
//

import SwiftUI

struct SelectSongView: View {
    
    @State private var placeholder = "Search for your daily song"
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @Binding var song: Song?
    
    
    let musicList = [
        ContentItem(imageUrl: URL(string: "https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3"), title: "See you again (feat. Kali Uchis)", subtitle: "Tyler, The Creator, Kali Uchis", isPerson: false),
        ContentItem(imageUrl: URL(string: "https://i.scdn.co/image/ab67616d00001e02baf2a68126739ff553f2930a"), title: "Runaway", subtitle: "Kanye West", isPerson: false),
        ContentItem(imageUrl: URL(string: "https://i.scdn.co/image/ab67616d0000b273dafad44c40c08d3fbfcce20f"), title: "Entropy", subtitle: "Beach Bunny", isPerson: false)
    ]
    
    var body: some View {
        NavigationStack {
            ZStack{
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .ignoresSafeArea()
                List(filteredResults, id: \.title) { item in
                    ItemSmall(item: item, showArrow: false)
                        
                        .onTapGesture {
                            updateSelectedSong(from: item)
                            presentationMode.wrappedValue.dismiss()
                        }
                        .background(.clear)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
                
                .listStyle(.plain)
            }
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            
           .navigationTitle("Select Song")
            .navigationBarTitleDisplayMode(.inline)

        }
    }
    
    var filteredResults: [ContentItem] {
        musicList.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.subtitle.localizedCaseInsensitiveContains(searchText) ||
            searchText.isEmpty
        }
    }
    
    func updateSelectedSong(from item: ContentItem) {
        let newSong = Song(id: UUID().uuidString,
                           title: item.title,
                           artist: item.subtitle,
                           album: "",
                           coverArt: item.imageUrl?.absoluteString ?? "")
        self.song = newSong
    }
}

struct SelectSongView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSongView(song: .constant(nil as Song?))
    }
}
