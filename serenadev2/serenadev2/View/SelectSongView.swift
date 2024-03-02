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
    @Binding var song: SongModel?
    @StateObject private var viewModel = SearchViewModel() // Initialize the view model
    @State private var selectedSong: ContentItem?
    
    var body: some View {
        NavigationStack {
            ZStack{
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    
                    List(filteredResults) { value in
                        ItemSmall(item: value, showArrow: false)
                            //.padding()
                            .onTapGesture {
                                print("THIS IS THE SONG : \(value)")
                                updateSelectedSong(from: value)
                                presentationMode.wrappedValue.dismiss()
                                selectedSong = value
                            }
                            .background(.clear)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .background(.viewBackground)
                    .overlay {
                            if viewModel.isLoading {
                                // Display a loading indicator or view when music is being fetched
                                ProgressView()
                                    .progressViewStyle(.circular)
                            } else if viewModel.searchText.isEmpty {
                                // Display this when no search has been made yet
                                ContentUnavailableView(label: {
                                    Label("Search for music ", systemImage: "music.note")
                                }, description: {
                                    Text("Search for your favorite songs, artists or albums")
                                })
                            } else if filteredResults.isEmpty {
                                // Display this when there are no results (for Music tab only)
                                ContentUnavailableView(label: {
                                    Label("No Matches Found ", systemImage: "exclamationmark")
                                }, description: {
                                    Text("We couldn't find anything for your search. Try different keywords or check for typos.")
                                })
                            
                        }
                    }
                }
                
                .searchable(text: $viewModel.searchText)
                .disableAutocorrection(true)
            }
            .onChange(of: viewModel.searchText) {
                viewModel.fetchMusic(with: viewModel.searchText)
            }
            .navigationTitle("Select Song")
                        .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var filteredResults: [ContentItem] {
            var contentitems = viewModel.songs.map { song in
                ContentItem(isPerson: false, song: song)
            }
        print(contentitems.count)
        return contentitems
        
    }
    
    func updateSelectedSong(from item: ContentItem) {
        // Attempt to unwrap `item.song` safely
        guard let songDetails = item.song else {
            print("Failed to unwrap item.song")
            // Handle the failure case, e.g., return or set a default value
            return
        }
        
        // Since `songDetails` is now safely unwrapped, use it directly without optional chaining
        let newSong = SongModel(
            id: songDetails.id,
            title: songDetails.title,
            artists: songDetails.artists,
            artworkUrlSmall: songDetails.artworkUrlSmall,
            artworkUrlLarge: songDetails.artworkUrlLarge,
            bgColor: songDetails.bgColor,
            priColor: songDetails.priColor,
            secColor: songDetails.secColor,
            terColor: songDetails.terColor,
            quaColor: songDetails.quaColor,
            previewUrl: songDetails.previewUrl,
            duration: songDetails.duration,
            composerName: songDetails.composerName,
            genreNames: songDetails.genreNames ?? [],
            releaseDate: songDetails.releaseDate
        )
        
        print("This is the deeeddeddede\(newSong)")
        self.song = newSong
        print(" SI ESTA PASANDO LA CANCION \(song)")
    }

}

struct SelectSongView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSongView(song: .constant(nil as SongModel?))
    }
}




