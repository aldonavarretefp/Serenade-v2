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
    var user: User
    
    // MARK: - Properties
    @State private var name: String = ""
    @State private var username: String = ""
    
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
                            TextField("New username",text: $username)
                        }
                        Divider()
                    }
                    .padding(.vertical)
                    Spacer()
                    Button{
//                        saveUserChangesToCloudKit()
                    } label: {
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                        Text(LocalizedStringKey("SaveChanges"))
                            .font(.subheadline)
                        Spacer()
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(.accent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.top, 12)
                }
                .padding()
            }
            .navigationTitle(LocalizedStringKey("EditProfile"))
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                name = user.name 
                username = user.tagName
            }
        }
    }
}

#Preview {
    EditProfileView(user: sebastian)
}
