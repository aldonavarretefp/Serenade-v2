//
//  ProfileBar.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 19/02/24.
//

import SwiftUI
import CloudKit

var sebastian = User(name: "Sebastian Leon", tagName: "sebatoo", email: "mail@domain.com", friends: [], posts: [], streak: 15, profilePicture: "", isActive: true, record: CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "B5E07FDA-EB68-4C72-B547-ACE39273D662")))

struct ProfileBar: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var isSettingsSheetDisplayed: Bool = false
    @State var isUnfriendSheetDisplayed: Bool = false
    @State var isFriendRequestSent: Bool
    @State var isCurrentUser: Bool
    @State var isFriend: Bool?
    @EnvironmentObject var userViewModel: UserViewModel
    
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
                            Text(user.posts != nil ? String(user.posts!.count) : "0")
                            Text(LocalizedStringKey("Posts"))
                        }
                        .font(.caption)
                        VStack {
                            Text(String(user.friends.count))
                            Text(LocalizedStringKey("Friends"))
                        }
                        .font(.caption)
                        .padding(.horizontal)
                        Spacer()
                        if !isCurrentUser {
                            if !isFriend! {
                                if !isFriendRequestSent {
                                    Button(action: {
                                        
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
                                    
                                    ConfirmationSheet(titleStart: LocalizedStringKey("UnfriendTitleStart"), titleEnd: LocalizedStringKey("UnfriendTitleEnd"), user: user.tagName, descriptionStart: LocalizedStringKey("UnfriendDescriptionStart"), descriptionEnd: LocalizedStringKey("UnfriendDescriptionEnd"), buttonLabel: "DeleteFriend"){
                                        guard let currentUser = userViewModel.user else {
                                            print("ERROR: Couldn't unmake friends")
                                            return
                                        }
                                        let friendID = user.record.recordID
                                        userViewModel.unmakeFriend(withID: friendID)
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
