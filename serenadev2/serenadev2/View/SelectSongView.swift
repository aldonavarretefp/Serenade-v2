//
//  SelectSongView.swift
//  serenadev2
//
//  Created by Pedro Daniel Rouin Salazar on 27/02/24.
//

import SwiftUI

struct SelectSongView: View {
    
    // MARK: - ViewModel
    @StateObject private var searchViewModel = SearchViewModel()
    @StateObject private var selectSongViewModel: SelectSongViewModel
    
    // MARK: - Environment properties
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Properties
    @Binding var song: SongModel?
    @State private var selectedSong: ContentItem?
    
    // MARK: - Init
    init(song: Binding<SongModel?>) {
        self._song = song
        self._selectSongViewModel = StateObject(wrappedValue: SelectSongViewModel(song: song))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack{
                // Background of the view
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .ignoresSafeArea()
                
                // List to show the results of a search
                VStack(spacing: 0) {
                    List(searchViewModel.filteredResults(for: .music)) { value in
                        ItemSmall(item: value, showArrow: false)
                            .onTapGesture { // On tap change the selected song and close this search song sheet
                                selectSongViewModel.updateSelectedSong(from: value)
                                dismiss()
                                selectedSong = value
                            }
                            .background(.clear)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                    .background(.viewBackground)
                    .overlay {
                        if searchViewModel.isLoading {
                            // Display a loading indicator or view when music is being fetched
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else if searchViewModel.searchText.isEmpty {
                            // Display this when no search has been made yet (for Music tab only)
                            ContentUnavailableView(label: {
                                Label(LocalizedStringKey("SearchForMusic"), systemImage: "music.note")
                            }, description: {
                                Text(LocalizedStringKey("SearchDescription"))
                            })
                            
                        } else if searchViewModel.filteredResults(for: .music).isEmpty {
                            // Display this when there are no results (for Music tab only)
                            ContentUnavailableView(label: {
                                Label(LocalizedStringKey("NoMatchesFound"), systemImage: "exclamationmark")
                            }, description: {
                                Text(LocalizedStringKey("NoMatchesDescription"))
                            })
                            
                        }
                        
                    }
                }
                .searchable(text: $searchViewModel.searchText)
                .disableAutocorrection(true)
            }
            .onChange(of: searchViewModel.searchText) {
                searchViewModel.fetchMusic(with: searchViewModel.searchText)
            }
            .navigationTitle(LocalizedStringKey("SelectSong"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SelectSongView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSongView(song: .constant(nil as SongModel?))
    }
}
