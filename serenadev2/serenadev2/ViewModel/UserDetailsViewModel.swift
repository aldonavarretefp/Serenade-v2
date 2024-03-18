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
    
    // MARK: - Methods
    func saveUserDetails(userViewModel: UserViewModel) {
        self.tagname = self.tagname.formattedForTagName
        userViewModel.searchUsers(searchText: self.tagname) { users in
            
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
