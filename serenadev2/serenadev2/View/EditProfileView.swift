//
//  EditProfileView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 26/02/24.
//

import SwiftUI
import CloudKit

struct EditProfileView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userVM: UserViewModel
    @StateObject private var profilePicViewModel = ProfilePicViewModel()
    @StateObject private var editProfileViewModel: EditProfileViewModel
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    // Initializer to inject ProfilePicViewModel with an existing profile picture URL if available
    init(user: User) {
        self._editProfileViewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
        
        if let imageAssetUrlToShow = user.profilePictureAsset?.fileURL {
            _profilePicViewModel = StateObject(wrappedValue: ProfilePicViewModel(profileImageUrl: imageAssetUrlToShow.absoluteString))
        }
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ZStack{
                // Background of the view
                Color.viewBackground
                    .ignoresSafeArea()
                
                VStack {
                    
                    // Circular profile image (edit)
                    EditableCircularProfileImage(viewModel: profilePicViewModel)
                        .padding()
                    
                    VStack{
                        Divider()
                            .padding(.vertical, 4)
                        
                        // Text field for the name
                        HStack{
                            HStack{
                                Text(LocalizedStringKey("Name"))
                                Spacer()
                            }
                            .frame(maxWidth: 100)
                            Spacer()
                            TextField(LocalizedStringKey("NewName"), text: $editProfileViewModel.name)
                        }
                        
                        Divider()
                            .padding(.vertical, 4)
                        
                        // Text field for the username
                        HStack{
                            HStack{
                                Text(LocalizedStringKey("Username"))
                                Spacer()
                            }
                            .frame(maxWidth: 100)
                            Spacer()
                            TextField(LocalizedStringKey("NewUsername"),text: $editProfileViewModel.tagName)
                                .autocapitalization(.none)
                                .onChange(of: editProfileViewModel.tagName) { oldValue, newValue in
                                    editProfileViewModel.tagName = newValue.lowercased()
                                }
                        }
                        
                        Divider()
                        
                        // If there is an error show it
                        if editProfileViewModel.error != ""{
                            HStack{
                                Spacer()
                                
                                Image(systemName: "info.circle")
                                Text(editProfileViewModel.error)
                                Spacer()
                            }
                            .font(.footnote)
                            .foregroundStyle(.red)
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                    
                    // Button to save the changes
                    ActionButton(label: LocalizedStringKey("SaveChanges"), symbolName: "checkmark.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color(hex: 0xBA55D3), isShareDaily: false, isDisabled: editProfileViewModel.tagName.formattedForTagName == "" || editProfileViewModel.name.formattedForTagName == "") {
                        guard let user = userVM.user else {
                            return
                        }
                        var imageAsset: CKAsset?
                        // Image loaded
                        switch profilePicViewModel.imageState {
                        case .empty:
                            break;
                        case .loading(_):
                            break;
                        case .success(let uIImage):
                            imageAsset = profilePicViewModel.imageToCKAsset(image: uIImage)
                            //                            guard let imageAsset, let profilePicUrl = imageAsset.fileURL else {
                            //                                print("Couldn't bring the profileImgURL")
                            //                                return
                            //                            }
                        case .failure(_):
                            break;
                        }
                        
                        // Give a format to the tagname
                        let trimmedTagName: String = editProfileViewModel.tagName.formattedForTagName
                        
                        userVM.searchUsers(searchText: trimmedTagName) { users in
                            if let users, users.count > 0 && trimmedTagName != "" {
                                let userFromDB = users[0]
                                
                                // If the user is the same in session
                                if userVM.isSameUserInSession(fromUser: user, toCompareWith: userFromDB) {
                                    if trimmedTagName.containsEmoji { // If the user name contains emojis give an error to the user
                                        withAnimation {
                                            editProfileViewModel.error = "The username can't include emojis. Try again."
                                        }
                                        return
                                    }
                                    editProfileViewModel.saveUserDetails(userVM: userVM, imageAsset: imageAsset, trimmedTagName: trimmedTagName)
                                    self.dismiss()
                                } else { // If the username is already taken
                                    withAnimation {
                                        editProfileViewModel.error = "Sorry! \(trimmedTagName) is already in use. Please try another one"
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        editProfileViewModel.lastTagName = ""
                                    }
                                }
                            } else {
                                if trimmedTagName.containsEmoji { // If the user name contains emojis give an error to the user
                                    withAnimation {
                                        editProfileViewModel.error = "The username can't include emojis. Try again."
                                    }
                                    return
                                }
                                editProfileViewModel.saveUserDetails(userVM: userVM, imageAsset: imageAsset, trimmedTagName: trimmedTagName)
                                self.dismiss()
                            }
                        }
                        
                    }
                }
                .padding()
                .padding(.top)
            }
            .navigationTitle(LocalizedStringKey("EditProfile"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(colorScheme == .light ? .white : .black,for: .navigationBar)
        }
    }
}



#Preview {
    EditProfileView(user: sebastian)
}
