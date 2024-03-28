//
//  FriendsListView.swift
//  serenadev2
//
//  Created by Pedro Daniel Rouin Salazar on 11/03/24.
//

import SwiftUI
import MusicKit
import CloudKit

struct FriendsListView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userVM: UserViewModel
    @StateObject private var viewModel = SearchViewModel()
    @StateObject private var friendsListViewModel = FriendsListViewModel()
    @StateObject private var loadingStateViewModel = LoadingStateViewModel()
    @StateObject private var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Properties
    @Binding var user: User
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // If the list is loading show a progress view
                if loadingStateViewModel.isLoading {
                    progressView
                    
                }else {
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            if  viewModel.searchText.isEmpty { // If the user is not searching for a friend show the entire list
                                ForEach(profileViewModel.friendsFromUser, id: \.self) { friend in
                                    NavigationLink(destination: ProfileViewFromSearch(user: friend)) {
                                        ItemSmall(item: ContentItem(isPerson: true, user: friend), showArrow: true)
                                            .padding([.leading, .top, .bottom ])
                                        
                                    }
                                    .buttonStyle(.plain)
                                    
                                }
                            }  else { // Show the filtered list
                                ForEach(friendsListViewModel.filteredFriends, id: \.self) { friend in
                                    NavigationLink(destination: ProfileViewFromSearch(user: friend), label: {
                                        ItemSmall(item: ContentItem(isPerson: true, user: friend), showArrow: true)
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
            .navigationTitle(user.tagName)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(colorScheme == .light ? .white : .black,for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            .overlay {
                
                // If the friendslist is empty and the user is not searching for a friend show this
                if friendsListViewModel.filteredFriends.isEmpty && !viewModel.searchText.isEmpty {
                    ContentUnavailableView(label: {
                        Label(LocalizedStringKey("NoMatchesFound"), systemImage: "exclamationmark")
                    }, description: {
                        Text(LocalizedStringKey("NoMatchesDescription"))
                    })
                }
            }
            .background(.viewBackground)
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
            .disableAutocorrection(true)
        }
        .onChange(of: viewModel.searchText) {
            friendsListViewModel.filterFriends(searchText: viewModel.searchText, friendsList: profileViewModel.friendsFromUser)
        }
        .task {
            
            loadingStateViewModel.isLoading = true
            profileViewModel.friendsFromUser = await userVM.fetchFriendsForUser(user: self.user)
            loadingStateViewModel.isLoading = false
            //                for friend in friendsFromUser{
            //                    print("THIS ARE THE UPDATED FRIENDS")
            //                    print(friend.tagName)
            //                }
        }
    }
}

extension FriendsListView{
    var progressView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                    .scaleEffect(1.5) // Makes the progress view larger
                    .progressViewStyle(CircularProgressViewStyle()) // Customize the spinner
                Spacer()
            }
            Spacer()
        }
    }
}
