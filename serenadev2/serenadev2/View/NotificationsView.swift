//
//  NotificationsView.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//


import SwiftUI
import CloudKit

struct NotificationsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var friendRequestViewModel: FriendRequestsViewModel
    @State var notifications: [NotificationItem] = []
    @State private var isLoading: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.viewBackground
                    .ignoresSafeArea()
                VStack{
                    ScrollView {
                        VStack(spacing: 35) {
                            
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .font(.title2)
                            } else {
                                if notifications.count == 0 {
                                    Text("Ups, there are no notifications for you yet!")
                                } else {
                                    ForEach(notifications){ notification in
                                        notification
                                    }
                                }
                                
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
            .task {
                isLoading = true
                if let currentUser = userViewModel.user {
                    self.friendRequestViewModel.fetchFriendRequestsForUser(user: currentUser) {
                        isLoading = false
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
