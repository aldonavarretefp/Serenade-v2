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
    
    @ObservedObject var historySongManager = SongHistoryManager.shared
    @ObservedObject var historyPeopleManager = PeopleHistoryManager.shared
    
    @State var historySong: [SongModel] = []
    @State var historyPeople: [User] = []
    
    @State private var selectedTab: selectedTab = .music
    @State private var underlineOffset: CGFloat = 0
    @State var isSongInfoDisplayed: Bool = false
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    private let underlineHeight: CGFloat = 2
    private let animationDuration = 0.2
    
    @State private var selectedSong: ContentItem?
    @State private var selectedUser: ContentItem?
    
    @State private var peopleList: [ContentItem]  = []
    
    init() {
        loadHistory()
    }
    
    func loadHistory() {
        Task {
            historySong = await historySongManager.getHistory()
            historyPeople = await historyPeopleManager.getHistory()
        }
    }
    
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
                    
                    if self.historySong.count != 0 && viewModel.searchText.isEmpty && selectedTab == .music{
                        ScrollView{
                            VStack(spacing: 0){
                                ForEach(self.historySong, id:\.self) { song in
                                    ItemSmall(item: ContentItem(isPerson: false, song: song), showXMark: true){
                                        historySongManager.removeSong(songId: song.id)
                                        loadHistory()
                                    }
                                    .padding([.leading, .top, .bottom])
                                    .onTapGesture{
                                        selectedSong = ContentItem(isPerson: false, song: song)
                                        historySongManager.addToHistory(song.id)
                                        loadHistory()
                                    }
                                }
                            }
                        }
                    } else if self.historyPeople.count != 0 && viewModel.searchText.isEmpty && selectedTab == .people {
                        ScrollView {
                            VStack(spacing: 0){
                                ForEach(self.historyPeople, id:\.self) { user in
                                    NavigationLink(destination: ProfileView(user: user), label: {
                                        ItemSmall(item: ContentItem(isPerson: true, user: user), showXMark: true){
                                            historyPeopleManager.removeUser(userID: user.record.recordID.recordName)
                                            loadHistory()
                                        }
                                        .padding([.leading, .top, .bottom])
                                    })
                                }
                            }
                        }
                        .scrollDismissesKeyboard(.immediately)
                    }
                }
            }
            .overlay {
                if selectedTab == .music {
                    if viewModel.isLoading {
                        // Display a loading indicator or view when music is being fetched
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else if viewModel.searchText.isEmpty {
                        if self.historyPeople.count == 0 {
                            // Display this when no search has been made yet (for Music tab only)
                            ContentUnavailableView(label: {
                                Label(LocalizedStringKey("SearchForMusic"), systemImage: "music.note")
                            }, description: {
                                Text(LocalizedStringKey("SearchDescription"))
                            })
                        }
                        
                    } else if filteredResults.isEmpty {
                        // Display this when there are no results (for Music tab only)
                        ContentUnavailableView(label: {
                            Label(LocalizedStringKey("NoMatchesFound"), systemImage: "exclamationmark")
                        }, description: {
                            Text(LocalizedStringKey("NoMatchesDescription"))
                        })
                        
                    }
                } else if selectedTab == .people {
                    if viewModel.isLoading {
                        // Display a loading indicator or view when music is being fetched
                        ProgressView()
                            .progressViewStyle(.circular)
                    } else if viewModel.searchText.isEmpty {
                        if self.historyPeople.count == 0 {
                            // Display this when no search has been made yet (for Music tab only)
                            ContentUnavailableView(label: {
                                Label(LocalizedStringKey("SearchForPeople"), systemImage: "person.3")
                            }, description: {
                                Text(LocalizedStringKey("SearchDescription"))
                            })
                        }
                        
                    } else if peopleList.isEmpty {
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
            if selectedTab == .music {
                viewModel.fetchMusic(with: viewModel.searchText)
            } else {
                userViewModel.searchUsers(tagname: viewModel.searchText) { returnedUsers in
                    if let returnedUsers = returnedUsers {
                        peopleList = returnedUsers.map({ user in
                            ContentItem(isPerson: true, user: user)
                        })
                    }
                }
            }
            
        }
        
        .fullScreenCover(item: $selectedSong){ item in
            SongDetailView(song: item.song!)
        }
        .onAppear{
            loadHistory()
        }
    }
    
    
    var filteredResults: [ContentItem] {
        if selectedTab == .music {
            return viewModel.songs.map { song in
                ContentItem(isPerson: false, song: song)
            }
        } else {
            return peopleList
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        
    }
}
