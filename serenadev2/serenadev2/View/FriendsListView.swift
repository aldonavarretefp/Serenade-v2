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
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel = SearchViewModel() // Initialize the view model
    
    
    @State var userTagName : String?
    @Binding var friends: [User]
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var selectedUser: ContentItem?
    
    @State private var filteredFriends: [User]  = []
    @Binding var isLoading : Bool
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    
                    
                    if isLoading{
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView()
                                    .scaleEffect(1.5) // Makes the spinner larger
                                    .progressViewStyle(CircularProgressViewStyle()) // Customize the spinner
                                Spacer()
                            }
                            Spacer()
                        }
                        
                    }
                    else {
                        if  viewModel.searchText.isEmpty {
                            ScrollView {
                                VStack(spacing: 0){
                                    ForEach(friends, id: \.self) { friend in
                                        NavigationLink(destination: ProfileViewFromSearch(user: friend)) {
                                            ItemSmall(item: ContentItem(isPerson: true, user: friend), showArrow: true)
                                                .padding([.leading, .top, .bottom ])
                                            
                                        }
                                        .buttonStyle(.plain)
                                        
                                    }
                                }
                            }
                            .scrollDismissesKeyboard(.immediately)
                        } else {
                            ScrollView {
                                VStack(spacing: 0) {
                                    ForEach(filteredFriends, id: \.self) { friend in
                                        NavigationLink(destination: ProfileViewFromSearch(user: friend), label: {
                                            ItemSmall(item: ContentItem(isPerson: true, user: friend), showArrow: true)
                                                .padding([.leading, .top, .bottom])
                                        })
                                        .buttonStyle(.plain)
                                        
                                    }
                                }
                            }
                            .scrollDismissesKeyboard(.immediately)
                        }
                    }
                }
                
            }
            .navigationTitle(listTitle)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(colorScheme == .light ? .white : .black,for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
            
            .overlay {
                
                if filteredFriends.isEmpty && !viewModel.searchText.isEmpty {
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
        .onChange(of: viewModel.searchText) {newValue in
            filterFriends(searchText: newValue)
            print("this are the FILTERED friends on the LIST from \(String(describing: userTagName))")
            print(filteredFriends)
        }
        
        
        
        .onAppear{
            print("this are the friends on the LIST")
            print(friends)
            print("this are the FILTERED friends on the LIST")
            print(filteredFriends)
        }
        
        
    }
    
    
    func filterFriends(searchText: String) {
        if searchText.isEmpty {
            filteredFriends = friends // No search text, so show all friends.
        } else {
            // Filter friends based on searchText. Adjust according to your User model.
            filteredFriends = friends.filter { user in
                user.name.contains(searchText) || user.tagName.contains(searchText)
                //user.name.localizedCaseInsensitiveContains(searchText) ||
                //user.tagName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var listTitle: String {
        if let tag = userTagName {
            return tag
        } else {
            // Any additional logic to determine the default title
            return ""
        }
    }
    
    //MARK: Insensitive
    //    var filteredFriends: [User] {
    //        // Check if searchText is empty and return the whole friends list if true
    //        guard !viewModel.searchText.isEmpty else {
    //            return friends
    //        }
    //
    //        // Filter friends based on searchText matching either the name or tagname
    //        return friends.filter { user in
    //            user.name.localizedCaseInsensitiveContains(viewModel.searchText) ||
    //            user.tagName.localizedCaseInsensitiveContains(viewModel.searchText)
    //        }
    //    }
    
    //MARK: Sensitive search
}

//struct FriendsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        FriendsListView()
//
//    }
//}
