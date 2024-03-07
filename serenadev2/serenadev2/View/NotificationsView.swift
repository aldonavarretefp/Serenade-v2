//
//  NotificationsView.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//

/*
 Button {
 print(friendRequestViewModel.friendRequests)
 } label: {
 Text("Print model")
 }
 
 Button {
 let ale = CKRecord.init(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "87BF288A-BB93-467E-B342-838DE0292B87"))
 guard let miID = userViewModel.user?.record.recordID else {
 print("No user")
 return
 }
 friendRequestViewModel.createFriendRequest(senderID: ale.recordID, receiverID: miID)
 } label: {
 Text("Create Friend Request")
 }
 
 Button {
 let friendRequest = friendRequestViewModel.friendRequests[0]
 
 friendRequestViewModel.acceptFriendRequest(friendRequest: friendRequest) {
 userViewModel.makeFriend(withID: friendRequest.sender.recordID)
 }
 } label: {
 Text("Accept Friend Request")
 }
 */

import SwiftUI
import CloudKit
struct NotificationsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var friendRequestViewModel: FriendRequestsViewModel
    @State var notifications: [NotificationItem] = []
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.viewBackground
                    .ignoresSafeArea()
                VStack{
                    ScrollView{
                        VStack(spacing: 35){
                            ForEach(notifications){ notification in
                                notification
                            }
                        }
                        .padding()
                    }
                    .padding()
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(colorScheme == .light ? .white : .black,for: .navigationBar)
            .navigationTitle(LocalizedStringKey("Notifications"))
            .toolbarTitleDisplayMode(.inline)
            .onAppear {
                if let currentUser = userViewModel.user {
                    self.friendRequestViewModel.fetchFriendRequestsForUser(user: currentUser) {
                        for friendRequest in self.friendRequestViewModel.friendRequests {
                            userViewModel.fetchUserFromRecordID(recordID: friendRequest.sender.recordID) { user in
                                guard let user = user else { return }
                                notifications.append(NotificationItem(user: user, friendRequest: friendRequest, completionHandlerAccept: {accept(friendRequest: friendRequest)}, completionHandlerReject: {decline(friendRequest: friendRequest)}))
                            }
                        }
                    }
                }
            }
        }
    }
    
    func accept(friendRequest: FriendRequest){
        notifications.removeAll()
        friendRequestViewModel.acceptFriendRequest(friendRequest: friendRequest) {
            userViewModel.makeFriend(withID: friendRequest.sender.recordID)
        }
        updateNotifications()
    }
    
    func decline(friendRequest: FriendRequest){
        notifications.removeAll()
        friendRequestViewModel.declineFriendRequest(friendRequest: friendRequest) {
        }
        updateNotifications()
        
    }
    
    func updateNotifications(){
        notifications.removeAll()
        if let currentUser = userViewModel.user {
            friendRequestViewModel.fetchFriendRequestsForUser(user: currentUser) {
                for friendRequest in self.friendRequestViewModel.friendRequests {
                    userViewModel.fetchUserFromRecordID(recordID: friendRequest.sender.recordID) { user in
                        guard let user = user else { return }
                        notifications.append(NotificationItem(user: user, friendRequest: friendRequest, completionHandlerAccept: {accept(friendRequest: friendRequest)}, completionHandlerReject: {decline(friendRequest: friendRequest)}))
                    }
                }
            }
        }
    }
}

#Preview {
    NotificationsView()
        .environment(\.locale, .init(identifier: "it"))
}
