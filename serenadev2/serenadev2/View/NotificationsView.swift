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
    @StateObject var friendRequestViewModel: FriendRequestsViewModel = FriendRequestsViewModel()
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.viewBackground
                    .ignoresSafeArea()
                
                VStack{
                    ScrollView{
                        VStack(spacing: 35){
                            ForEach(friendRequestViewModel.friendRequests, id: \.self) { request in
                                if let user = friendRequestViewModel.userDetails[request.sender.recordID] {
                                    NotificationItem(user: user, friendRequest: request)
                                        .environmentObject(friendRequestViewModel)
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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let currentUser = userViewModel.user {
                        self.friendRequestViewModel.fetchFriendRequestsForUser(user: currentUser)
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
