//
//  ProfileBar.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 19/02/24.
//

import SwiftUI
import CloudKit

var sebastian = User(name: "Sebastian Leon", tagName: "sebatoo", email: "mail@domain.com", friends: [], posts: [], streak: 15, profilePicture: "", isActive: true, record: CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "B5E07FDA-EB68-4C72-B547-ACE39273D66")))

struct ProfileBar: View {
    @Environment(\.colorScheme) var colorScheme


    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var friendRequestViewModel: FriendRequestsViewModel = FriendRequestsViewModel()
    @Binding var friends :[User]
    
    
    @State var friendRequest: FriendRequest? = nil
    @State var isSettingsSheetDisplayed: Bool = false
    @State var isUnfriendSheetDisplayed: Bool = false
    @Binding var user: User
    @Binding var isFriend: Bool
    @Binding var isFriendRequestSent: Bool
    @Binding var isFriendRequestRecieved: Bool
    @Binding var showFriendRequestButton: Bool
    @Binding var isLoading :Bool
    let isCurrentUser: Bool
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .top) {
                ZStack(alignment: .top) {
                    if let asset = user.profilePictureAsset {
                        AsyncImage(url: asset.fileURL) { phase in
                            switch phase {
                            case .success(let img):
                                img
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                
                            default:
                                Image(systemName: "person.fill")
                                    .font(.title)
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .foregroundStyle(colorScheme == .light ? .white : .black)
                                    .background {
                                        Circle().fill(.primary)
                                    }
                                    .padding(.trailing)
                            }
                        }
                    } else {
                        Image(systemName: "person.fill")
                            .font(.title)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .foregroundStyle(colorScheme == .light ? .white : .black)
                            .background {
                                Circle().fill(.primary)
                            }
                            .padding(.trailing)
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
                        
                        
                        NavigationLink(destination: FriendsListView(userTagName: user.tagName, friends: $friends, isLoading: $isLoading)) {
                                   VStack {
                                       Text("\(user.friends.count == 0 ? "0" : "\(user.friends.count - 1)")")
                                       Text("Friends")
                                   }
                                   .font(.caption)
                                   .padding(.horizontal)
                               }
                               .buttonStyle(PlainButtonStyle())
                        
                        
                        Spacer()
                        
                        if !isCurrentUser && isFriendRequestRecieved && showFriendRequestButton {
                            HStack(spacing: 5){
                                NotificationActionButton(icon: "xmark", isDisabled: false){
                                    guard let friendRequest = friendRequest else {return}
                                    friendRequestViewModel.declineFriendRequest(friendRequest: friendRequest) {
                                        
                                    }
                                    isFriendRequestRecieved = false
                                    isFriend = false
                                    isFriendRequestSent = false
                                }
                                
                                NotificationActionButton(icon: "checkmark", isDisabled: false){
                                    guard let friendRequest = friendRequest else {return}
                                    
                                    friendRequestViewModel.acceptFriendRequest(friendRequest: friendRequest) {
                                        userViewModel.makeFriend(withID: friendRequest.sender.recordID)
                                    }
                                    
                                    isFriendRequestRecieved = false
                                    isFriend = true
                                    isFriendRequestSent = false
                                }
                            }
                        } else if !isCurrentUser && showFriendRequestButton {
                            if !isFriend {
                                if !isFriendRequestSent {
                                    Button(action: {
                                        guard let me = userViewModel.user else {
                                            print("No user")
                                            return
                                        }
                                        friendRequestViewModel.createFriendRequest(sender: me, receiver: user)
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
                                } else {
                                    Button(action: {
                                        guard let me = userViewModel.user else {
                                            print("No user")
                                            return
                                        }
                                        friendRequestViewModel.fetchFriendRequest(from: me, for: user) { returnedFriendRequest in
                                            guard let returnedFriendRequest = returnedFriendRequest.first else {return}
                                            friendRequestViewModel.deleteFriendReques(friendRequest: returnedFriendRequest) {}
                                            isFriendRequestSent = false
                                        }
                                    }, label: {
                                        ZStack {
                                            Capsule()
                                                .fill(.secondaryButton)
                                            Text(LocalizedStringKey("PendingFriend"))
                                            //                                        .foregroundStyle(.callout)
                                                .fontWeight(.bold)
                                                .font(.subheadline)
                                        }
                                    })
                                }
                            } else {
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
                                    ConfirmationSheet(titleStart: LocalizedStringKey("UnfriendTitleStart"), titleEnd: LocalizedStringKey("UnfriendTitleEnd"), user: user.tagName, descriptionStart: LocalizedStringKey("UnfriendDescriptionStart"), descriptionEnd: LocalizedStringKey("UnfriendDescriptionEnd"), buttonLabel: "DeleteFriend") {
                                        isFriend = false
                                        userViewModel.unmakeFriend(friend: user)
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
        .onChange(of: isFriendRequestRecieved) {
            userViewModel.fetchUserFromRecord(record: self.user.record) { returnedUser in
                guard let updatedUser = returnedUser else {
                    print("NO USER FROM DB")
                    return
                }
                print("Fetched User from DB: \(updatedUser)")
                self.user = updatedUser
                fetchUserFriendRequests()
            }
        }
        
        .task {
            fetchUserFriendRequests()
        }
    }
    private func fetchUserFriendRequests() {
        guard let me = userViewModel.user else { return }
        
        friendRequestViewModel.fetchFriendRequest(from: me, for: user) { resultFriendRequest in
            if(!resultFriendRequest.isEmpty){
                self.friendRequest = resultFriendRequest.first
            }
            else {
                friendRequestViewModel.fetchFriendRequest(from: user, for: me) { resultFriendRequest in
                    if(!resultFriendRequest.isEmpty){
                        self.friendRequest = resultFriendRequest.first
                    }
                }
            }
        }
        
        if let mainUser = userViewModel.user {
            if(user.accountID == mainUser.accountID){
                user = mainUser
            }
        }
    }
}

//#Preview {

//    ProfileBar(isFriendRequestSent: true, isCurrentUser: false, isFriend: false, user: sebastian)

//        .environment(\.locale, .init(identifier: "us"))
//}
