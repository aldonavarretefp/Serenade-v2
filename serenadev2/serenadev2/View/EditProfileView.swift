//
//  EditProfileView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 26/02/24.
//

import SwiftUI
import CloudKit

struct EditProfileView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userVM: UserViewModel
    @StateObject var profilePicViewModel: ProfilePicViewModel = ProfilePicViewModel()
    var user: User
    
    // MARK: - Properties
    @State private var name: String = ""
    @State private var tagName: String = ""
    @State private var error: String = ""
    @State private var lastTagName: String = ""
    
    // Initializer to inject ProfilePicViewModel with an existing profile picture URL if available
    init(user: User) {
        self.user = user
        if let imageAssetUrlToShow = user.profilePictureAsset?.fileURL {
            _profilePicViewModel = StateObject(wrappedValue: ProfilePicViewModel(profileImageUrl: imageAssetUrlToShow.absoluteString))
        }
        _name = State(initialValue: user.name)
        _tagName = State(initialValue: user.tagName)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ZStack{
                Color.viewBackground
                    .ignoresSafeArea()
                VStack {
                    
                    EditableCircularProfileImage(viewModel: profilePicViewModel)
                    VStack{
                        Divider()
                            .padding(.vertical, 4)
                        HStack{
                            HStack{
                                Text(LocalizedStringKey("Name"))
                                Spacer()
                            }
                            .frame(maxWidth: 100)
                            Spacer()
                            TextField("New name", text: $name)
                        }
                        Divider()
                            .padding(.vertical, 4)
                        HStack{
                            HStack{
                                Text(LocalizedStringKey("Username"))
                                Spacer()
                            }
                            .frame(maxWidth: 100)
                            Spacer()
                            TextField("New username",text: $tagName)
                                .autocapitalization(.none)
                                .onChange(of: tagName) { oldValue, newValue in
                                    tagName = newValue.lowercased()
                                }
                        }
                        Divider()
                        if self.error != "" {
                            Text(error)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.vertical)
                    Spacer()
                    ActionButton(label: "Save changes", symbolName: "checkmark.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color(hex: 0xBA55D3), isShareDaily: false, isDisabled: tagName == "" || name == "") {
                        guard var user = userVM.user else {
                            return
                        }
                        var imageAsset: CKAsset?
                        // Imagen cargada
                        switch profilePicViewModel.imageState {
                        case .empty:
                            break;
                        case .loading(_):
                            break;
                        case .success(let uIImage):
                            imageAsset = profilePicViewModel.imageToCKAsset(image: uIImage)
                            guard let imageAsset, let profilePicUrl = imageAsset.fileURL else {
                                print("Couldn't bring the profileImgURL")
                                return
                                
                            }
                        case .failure(_):
                            break;
                        }
                        let trimmedTagName: String = tagName.formattedForTagName
                        
                        userVM.searchUsers(tagname: trimmedTagName) { users in
                            if let users, users.count > 0 && trimmedTagName != "" {
                                let userFromDB = users[0]
                                if isSameUserInSession(fromUser: user, toCompareWith: userFromDB) {
                                    if trimmedTagName.containsEmoji {
                                        self.error = "The username can't include emojis. Try again."
                                        return
                                    }
                                    saveUserDetails(user: user, imageAsset: imageAsset, trimmedTagName: trimmedTagName)
                                } else {
                                    self.error = "Sorry! \(trimmedTagName) is already in use."
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        lastTagName = ""
                                    }
                                }
                            } else {
                                if trimmedTagName.containsEmoji {
                                    self.error = "The username can't include emojis. Try again."
                                    return
                                }
                                saveUserDetails(user: user, imageAsset: imageAsset, trimmedTagName: trimmedTagName)
                            }
                        }
                        
                    }
                }
                .padding()
            }
            .navigationTitle(LocalizedStringKey("EditProfile"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(colorScheme == .light ? .white : .black,for: .navigationBar)
        }
        
    }
    func isSameUserInSession(fromUser user1: User, toCompareWith user2: User) -> Bool {
        return user1.accountID == user2.accountID
    }
    
    func saveUserDetails(user: User, imageAsset: CKAsset?, trimmedTagName: String) {
        guard var user = userVM.user else {
            return
        }
        user.profilePictureAsset = imageAsset
        user.tagName = trimmedTagName
        user.name = name
        userVM.updateUser(updatedUser: user)
        self.dismiss()
    }
}



#Preview {
    EditProfileView(user: sebastian)
}
