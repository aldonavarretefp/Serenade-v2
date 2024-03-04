//
//  ProfileBar.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 19/02/24.
//

import SwiftUI

var sebastian = User(name: "Sebastian Leon", email: "mail@domain.com", streak: 15, profilePicture: "", isActive: true, tagName: "sebatoo")

struct ProfileBar: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var isSettingsSheetDisplayed: Bool = false
    @State var isUnfriendSheetDisplayed: Bool = false
    @State var isFriendRequestSent: Bool
    @State var isCurrentUser: Bool
    @State var isFriend: Bool?
    
    var user: User
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .top) {
                ZStack(alignment: .top) {
                    if user.profilePicture != "" {
                        Image(user.profilePicture)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .clipShape(Circle())
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "flame.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                                .foregroundStyle(.accent)
                            Text(String(user.streak))  // user.streak
                                .bold()
                                .font(.title3)
                        }
                        .padding(5)
                        .background(Color.card.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0), radius: 12.5, x: 0, y: 4)
                        .offset(y: 5)
                    }
                }
                .padding(.trailing)
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            
                            Text(user.name)
                                .font(.title2)
                                .bold()
                            
                            Text(user.tagName)
                                .font(.footnote)
                                .foregroundStyle(.callout)
                            Spacer()
                        }
                        Spacer()
                        if isCurrentUser {
                            NavigationLink(destination: SettingsView().toolbarRole(.editor)) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                            }
                            .padding(5)
                            .foregroundStyle(.primary)
                        }
                        else {
                            Spacer()
                                .frame(width: 22, height: 22)
                                .padding(5)
                        }
                    }
                    HStack {
                        VStack {
                            
                            Text(LocalizedStringKey("Posts"))
                        }
                        .font(.caption)
                        VStack {
                            
                            Text(LocalizedStringKey("Friends"))
                        }
                        .font(.caption)
                        .padding(.horizontal)
                        Spacer()
                        if !isCurrentUser {
                            if !isFriend! {
                                if !isFriendRequestSent {
                                    Button(action: {
                                        //                                    sendFriendRequest()
                                        isFriendRequestSent = true
                                    }, label: {
                                        ZStack {
                                            Capsule()
                                            Text(LocalizedStringKey("AddFriendButton"))
                                                .foregroundStyle(.white)
                                                .fontWeight(.bold)
                                                .font(.headline)
                                        }
                                    })
                                }
                                else {
                                    ZStack {
                                        Capsule()
                                            .fill(.secondaryButton)
                                        Text(LocalizedStringKey("PendingFriend"))
                                        //                                        .foregroundStyle(.callout)
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            else {
                                Button(action: {
                                    isUnfriendSheetDisplayed = true
                                }, label: {
                                    ZStack {
                                        Capsule()
                                            .fill(.secondaryButton)
                                        Image(systemName: "person.fill.checkmark")
                                            .foregroundStyle(colorScheme == .light ? .black : .white)
                                            .font(.headline)
                                    }
                                })
                                .sheet(isPresented: $isUnfriendSheetDisplayed, content: {
                                    
                                    ConfirmationSheet(titleStart: LocalizedStringKey("UnfriendTitleStart"), titleEnd: LocalizedStringKey("UnfriendTitleEnd"), user: "alex10liva", descriptionStart: LocalizedStringKey("UnfriendDescriptionStart"), descriptionEnd: LocalizedStringKey("UnfriendDescriptionEnd"), buttonLabel: "DeleteFriend"){
                                        isFriend = false
                                    }
                                    .presentationDetents([.fraction(0.3)])
                                })
                            }
                        }
                    }
                    .font(.footnote)
                }
            }
            .padding()
            .frame(height: 130)
            .background()
        }
    }
}

#Preview {
    ProfileBar(isFriendRequestSent: false, isCurrentUser: false, isFriend: false, user: sebastian)
        .environment(\.locale, .init(identifier: "it"))
}
