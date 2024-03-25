//
//  SearchView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 22/02/24.
//

import SwiftUI
import MusicKit

// Enum to define the tabs
enum selectedTab {
    case music
    case people
}

struct SearchView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var searchViewModel = SearchViewModel()
    @ObservedObject private var historySongManager = SongHistoryManager.shared
    @ObservedObject private var historyPeopleManager = PeopleHistoryManager.shared
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Properties
    @State private var underlineOffset: CGFloat = 0
    private let underlineHeight: CGFloat = 2
    private let animationDuration = 0.2
    @State var selectedTab: selectedTab = .music
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        // Music tab
                        TabSelection(selectedTab: .music)
                            .foregroundColor(selectedTab == .music ? colorScheme == .dark ? .white : .black : .callout)
                            .onTapGesture {
                                withAnimation(.easeOut(duration: animationDuration)) {
                                    selectedTab = .music
                                    underlineOffset = 0  // Reset offset for the Music tab
                                }
                            }
                        
                        // people tab
                        TabSelection(selectedTab: .people)
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
                    
                    // If the user tap on music show the history / search for music
                    if selectedTab == .music {
                        ScrollView{
                            VStack(spacing: 0){
                                
                                // If the history is not empty and the user has not typed anything in the search show history for songs
                                if searchViewModel.historySong.count != 0 && searchViewModel.searchText.isEmpty {
                                    ForEach(searchViewModel.historySong, id:\.self) { song in
                                        ItemSmall(item: ContentItem(isPerson: false, song: song), showXMark: true){
                                            historySongManager.removeSong(songId: song.id)
                                            loadHistory()
                                        }
                                        .padding([.leading, .top, .bottom])
                                        .onTapGesture{
                                            searchViewModel.selectedSong = ContentItem(isPerson: false, song: song)
                                            historySongManager.addToHistory(song.id)
                                            loadHistory()
                                        }
                                    }
                                } else {
                                    // Show all the filtered results (search for music)
                                    ForEach(searchViewModel.filteredResults(for: .music)) { value in
                                        ItemSmall(item: value)
                                            .padding()
                                            .onTapGesture{
                                                searchViewModel.selectedSong = value
                                                historySongManager.addToHistory(value.song!.id)
                                                loadHistory()
                                            }
                                    }
                                }
                            }
                        }
                        .scrollDismissesKeyboard(.immediately)
                    } else { // If the user tap on people show the history / search for users
                        ScrollView{
                            VStack(spacing: 0){
                                
                                // If the history is not empty and the user has not typed anything in the search show history for people
                                if searchViewModel.historyPeople.count != 0 && searchViewModel.searchText.isEmpty {
                                    ForEach(searchViewModel.historyPeople, id:\.self) { user in
                                        NavigationLink(destination: ProfileViewFromSearch(user: user), label: {
                                            ItemSmall(item: ContentItem(isPerson: true, user: user), showXMark: true){
                                                historyPeopleManager.removeUser(userID: user.record.recordID.recordName)
                                                loadHistory()
                                            }
                                            .padding([.leading, .top, .bottom])
                                        })
                                    }
                                    
                                } else {
                                    // Show all the filtered results (search for people)
                                    ForEach(searchViewModel.filteredResults(for: .people)) { value in
                                        NavigationLink(destination: ProfileViewFromSearch(user: value.user!), label: {
                                            ItemSmall(item: ContentItem(isPerson: true, user: value.user), showArrow: true)
                                                .padding([.leading, .top, .bottom])
                                        })
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                        .scrollDismissesKeyboard(.immediately)
                    }
                }
            }
            .overlay {
                if selectedTab == .music {
                    if searchViewModel.searchText.isEmpty {
                        if searchViewModel.historySong.count == 0 {
                            // Display this when no search has been made yet (for Music tab only)
                            ContentUnavailableView(label: {
                                Label(LocalizedStringKey("SearchForMusic"), systemImage: "music.note")
                            }, description: {
                                Text(LocalizedStringKey("SearchDescription"))
                            })
                        }
                        
                    } else if searchViewModel.filteredResults(for: .music).isEmpty {
                        // Display this when there are no results (for Music tab only)
                        ContentUnavailableView(label: {
                            Label(LocalizedStringKey("NoMatchesFound"), systemImage: "exclamationmark")
                        }, description: {
                            Text(LocalizedStringKey("NoMatchesDescription"))
                        })
                        
                    }
                } else if selectedTab == .people {
                    if searchViewModel.searchText.isEmpty {
                        if searchViewModel.historyPeople.count == 0 && searchViewModel.peopleList.count == 0 && searchViewModel.searchText == "" {
                            // Display this when no search has been made yet (for Music tab only)
                            ContentUnavailableView(label: {
                                Label(LocalizedStringKey("SearchForPeople"), systemImage: "person.3.fill")
                            }, description: {
                                Text(LocalizedStringKey("SearchPeopleDescription"))
                            })
                        }
                        
                    } else if searchViewModel.peopleList.isEmpty {
                        // Display this when there are no results (for Pople tab only)
                        ContentUnavailableView(label: {
                            Label(LocalizedStringKey("NoMatchesFound"), systemImage: "exclamationmark")
                        }, description: {
                            Text(LocalizedStringKey("NoMatchesDescription"))
                        })
                        
                    }
                }
            }
            .background(.viewBackground)
            .searchable(text: $searchViewModel.searchText)
            .disableAutocorrection(true)
        }
        .onChange(of: searchViewModel.searchText) {
            // Everytime the user type perform the search
            if selectedTab == .music {
                Task {
                    searchViewModel.fetchMusic(with: searchViewModel.searchText)
                }
            } else {
                searchViewModel.peopleList = searchViewModel.users.filter({ user in
                    user.tagName.lowercased().contains(searchViewModel.searchText.lowercased()) || user.name.lowercased().contains(searchViewModel.searchText.lowercased())
                }).map({ user in
                    ContentItem(isPerson: true, user: user)
                })
            }
        }
        .fullScreenCover(item: $searchViewModel.selectedSong){ item in
            SongDetailView(song: item.song!)
        }
        .onAppear{
            loadHistory()
        }
        .task {
            loadUsers()
        }
    }
    
    // Load the song and people history from the historymanager
    func loadHistory() {
        Task {
            searchViewModel.historySong = await historySongManager.getHistory()
            searchViewModel.historyPeople = await historyPeopleManager.getHistory()
        }
    }
    
    // Load all the users in the app
    func loadUsers() {
        userViewModel.fetchAllUsers { returnedUsers in
            if let returnedUsers = returnedUsers {
                searchViewModel.users = returnedUsers
            }
        }
    }
    
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
        
    }
}
