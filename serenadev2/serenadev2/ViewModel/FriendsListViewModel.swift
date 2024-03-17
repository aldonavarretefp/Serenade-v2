//
//  FriendsListViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import Foundation

final class FriendsListViewModel: ObservableObject{
    
    // MARK: - Properties
    @Published var filteredFriends: [User] = []
    
    // MARK: - Methods
    func filterFriends(searchText: String, friendsList: [User]) {
        if searchText.isEmpty {
            self.filteredFriends = friendsList // No search text, so show all friends.
        } else {
            // Filter friends based on searchText. Adjust according to your User model.
            self.filteredFriends = friendsList.filter { user in
                user.name.contains(searchText) || user.tagName.contains(searchText)
                //user.name.localizedCaseInsensitiveContains(searchText) ||
                //user.tagName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}
