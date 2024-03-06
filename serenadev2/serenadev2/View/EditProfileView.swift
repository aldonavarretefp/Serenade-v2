//
//  EditProfileView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 26/02/24.
//

import SwiftUI

struct EditProfileView: View {
    // MARK: - Properties
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userVM: UserViewModel
    var user: User
    
    // MARK: - Properties
    @State private var name: String = ""
    @State private var tagName: String = ""
    @State private var error: String = ""
    @State private var lastTagName: String = ""
    
    // MARK: - Body
    var body: some View {
        NavigationStack{
            ZStack{
                Color.viewBackground
                    .ignoresSafeArea()
                VStack {
                    if user.profilePicture != "" {
                        Image(user.profilePicture)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                    Button(LocalizedStringKey("ChangeProfilePhoto")) {
//                        PhotosPicker()
                    }
                        .padding(.top)
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
                        }
                        Divider()
                        if self.error != "" && tagName == self.lastTagName {
                            Text(error)
                                .foregroundStyle(.red)
                        }
                    }
                    .padding(.vertical)
                    Spacer()
                    ActionButton(label: "Save changes", symbolName: "checkmark.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color(hex: 0xBA55D3), isShareDaily: false, isDisabled: tagName != "" && name != "" ? false : true) {
                        guard var newUser = userVM.user else {
                            return
                        }
                        let trimmedTagName: String = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
                        lastTagName = trimmedTagName
                        newUser.name = name
                        newUser.tagName = trimmedTagName
                        userVM.searchUsers(tagname: trimmedTagName) { users in
                            if let users, users.count > 0 {
                                let user = users[0]
                                if user == self.user {
                                    print("user is the same")
                                } else {
                                    self.error = "Sorry! \(trimmedTagName) is already in use."
                                }
                                return
                            }
                            userVM.updateUser(updatedUser: newUser)
                            self.dismiss()
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(LocalizedStringKey("EditProfile"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                name = user.name 
                tagName = user.tagName
            }
        }
    }
}

#Preview {
    EditProfileView(user: sebastian)
}
