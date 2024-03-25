//
//  UserDetailsViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 18/03/24.
//

import Foundation

final class UserDetailsViewModel: ObservableObject{
    
    // MARK: - Properties
    @Published var name: String = ""
    @Published var tagname: String = ""
    @Published var tagNameRepeated: Bool = false
    @Published var isLinkActive = false
    @Published var sameUser = false
    @Published var error: String = ""
    
    var isUsernameValid: Bool {
        return !tagname.isEmpty && !tagname.containsEmoji
    }
    
    func verifyUsernameAvailability(userViewModel: UserViewModel, completion: @escaping (Bool, String) -> Void) {
        if !isUsernameValid {
            completion(false, "The username can't include emojis. Try again.")
            return
        }
        
        userViewModel.searchUsersByExactTagName(searchText: self.tagname) { [weak self] users in
            guard let self = self, let users = users, !users.isEmpty else {
                // No users found or error occurred, treat as username available.
                completion(true, "")
                return
            }
            print("Did get a user...")
            if let user = userViewModel.user, userViewModel.isSameUserInSession(fromUser: user, toCompareWith: users.first!) {
                // Same user, proceed.
                completion(true, "")
            } else {
                // Username taken.
                completion(false, "Sorry! \(self.tagname) is already in use. Please try another one")
            }
        }
    }
    
    // MARK: - Methods
    func saveUserDetails(userViewModel: UserViewModel) {
        self.tagname = self.tagname.formattedForTagName
        userViewModel.searchUsersByExactTagName(searchText: self.tagname) { users in
            guard let users = users else { return }
            if !users.isEmpty && !self.sameUser {
                self.tagNameRepeated = true
                return
            } else {
                self.tagNameRepeated = false
                guard var user = userViewModel.user else {
                    print("No user in DB")
                    return
                }
                user.tagName = self.tagname
                user.name = self.name
                
                userViewModel.updateUser(updatedUser: user)
                self.isLinkActive = true
            }
        }
    }
}
