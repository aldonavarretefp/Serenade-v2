//
//  EditProfileViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import Foundation
import CloudKit

final class EditProfileViewModel: ObservableObject{
    
    // MARK: - Properties
    @Published var user: User
    @Published var name: String = ""
    @Published var tagName: String = ""
    @Published var error: String = ""
    @Published var lastTagName: String = ""
    
    // MARK: - Initializer
    init(user: User) {
        self.user = user
        self.name = user.name
        self.tagName = user.tagName
    }
    
    // MARK: - Methods
    func saveUserDetails(userVM: UserViewModel, imageAsset: CKAsset?, trimmedTagName: String) {
        guard var user = userVM.user else {
            return
        }
        user.profilePictureAsset = imageAsset
        user.tagName = trimmedTagName
        user.name = self.name
        userVM.updateUser(updatedUser: user)
    }
}
