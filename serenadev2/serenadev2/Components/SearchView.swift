//
//  SearchView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 22/02/24.
//

import SwiftUI
import MusicKit

enum selectedTab {
    case music
    case people
}
struct SearchView: View {
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = SearchViewModel() // Initialize the view model
    
    @State private var selectedTab: selectedTab = .music
    @State private var underlineOffset: CGFloat = 0
    @State var isSongInfoDisplayed: Bool = false
    
    
    private let underlineHeight: CGFloat = 2
    private let animationDuration = 0.2
    
    @State private var selectedSong: ContentItem?
    
    let peopleList = [
        ContentItem(imageUrl: URL(string: "https://www.opticalexpress.co.uk/media/1064/man-with-glasses-smiling-looking-into-distance.jpg"), title: "Fernando Fernández", subtitle: "janedoe", isPerson: true),
        ContentItem(imageUrl: URL(string: "https://i.pinimg.com/474x/98/51/1e/98511ee98a1930b8938e42caf0904d2d.jpg"), title: "Jane Smith", subtitle: "janesmith", isPerson: true),
        ContentItem(imageUrl: URL(string: "https://img.freepik.com/free-photo/young-beautiful-woman-pink-warm-sweater-natural-look-smiling-portrait-isolated-long-hair_285396-896.jpg?size=626&ext=jpg&ga=GA1.1.1700460183.1708560000&semt=ais"), title: "Alice Johnson", subtitle: "alicejohnson", isPerson: true)
    ]
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        // Music tab
                        Text(LocalizedStringKey("Music"))
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background()
                            .foregroundColor(selectedTab == .music ? colorScheme == .dark ? .white : .black : .callout)
                            .fontWeight(.semibold)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: animationDuration)) {
                                    selectedTab = .music
                                    underlineOffset = 0  // Reset offset for the Music tab
                                }
                            }
                        
                        // People tab
                        Text(LocalizedStringKey("People"))
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background()
                            .fontWeight(.semibold)
                            .foregroundColor(selectedTab == .people ? colorScheme == .dark ? .white : .black : .callout)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: animationDuration)) {
                                    selectedTab = .people
                                    underlineOffset = geometry.size.width / 2 // Set offset for the People tab
                                }
                            }
                    }
                    .overlay(
                        Rectangle()
                            .frame(width: geometry.size.width / 2, height: underlineHeight)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .offset(x: underlineOffset, y: 0),
                        alignment: .bottomLeading
                    )
                    .frame(height: 50)
                    .background()
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(filteredResults) { value in
                                
                                ItemSmall(item: value, showArrow: false)
                                    .padding()
                                    .onTapGesture{
                                        selectedSong = value
                                    }
                            }
                        }
                    }
                    .scrollDismissesKeyboard(.immediately)
                }
            }
            .overlay {
                // Check if the selected tab is Music before showing the overlay
                if selectedTab == .music {
                    if viewModel.isLoading {
                        // Display a loading indicator or view when music is being fetched
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else if viewModel.searchText.isEmpty {
                        // Display this when no search has been made yet (for Music tab only)
                        ContentUnavailableView(label: {
                            Label(LocalizedStringKey("SearchForMusic"), systemImage: "music.note")
                        }, description: {
                            Text(LocalizedStringKey("SearchDescription"))
                        })
                        
                    } else if filteredResults.isEmpty {
                        // Display this when there are no results (for Music tab only)
                        ContentUnavailableView(label: {
                            Label(LocalizedStringKey("NoMatchesFound"), systemImage: "exclamationmark")
                        }, description: {
                            Text(LocalizedStringKey("NoMatchesDescription"))
                        })
                        
                    }
                    
                }
                
            }
            .background(.viewBackground)
            .searchable(text: $viewModel.searchText)
            .disableAutocorrection(true)
        }
        .onChange(of: viewModel.searchText) {
            viewModel.fetchMusic(with: viewModel.searchText)
        }
        
        .fullScreenCover(item: $selectedSong){ item in
            SongDetailView(song: item.song!)
        }
    }
    
    
    var filteredResults: [ContentItem] {
        if selectedTab == .music {
            return viewModel.songs.map { song in
                ContentItem(isPerson: false, song: song)
            }
        } else {
            return peopleList.filter {
                $0.title!.localizedCaseInsensitiveContains(viewModel.searchText) ||
                $0.subtitle!.localizedCaseInsensitiveContains(viewModel.searchText) ||
                viewModel.searchText.isEmpty
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            
    }
}
