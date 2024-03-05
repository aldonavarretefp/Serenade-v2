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
                            
//                            NotificationItem(user: User(name: "Sebastian Leon", tagName: "sebatoo", email: "mail@domain.com", streak: 15, profilePicture: "AfterHoursCoverArt", isActive: true, record: CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "B5E07FDA-EB68-4C72-B547-ACE39273D662"))))
                            
                            Button {
                                print(friendRequestViewModel.friendRequests)
                            } label: {
                                Text("Print model")
                            }
                            
                            Button {
                                guard friendRequestViewModel.friendRequests.count != 0 else {
                                    return
                                }
                                Task {
                                    friendRequestViewModel.acceptFriendRequest(friendRequest: friendRequestViewModel.friendRequests[0]) {
                                        guard let user = userViewModel.user else { return }
                                        userViewModel.makeFriends(withId: user, friendId: friendRequestViewModel.friendRequests[0].sender.recordID)
                                    }
                                }
                                
                            } label: {
                                Text("Accept")
                            }
                            
//                            Button {
//                                guard let friendRequests = friendRequestViewModel.friendRequests else {
//                                    print("NO friend requests")
//                                    return
//                                }
//                                friendRequestViewModel?.declineFriendRequest(friendRequest: friendRequests[0])
//                            } label: {
//                                Text("Decline")
//                            }
                            
                            
//                            Button {
//                                let ale = CKRecord.init(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "110590A8-297A-495C-929D-B9951EAFF752"))
//                                guard let aldoID = userViewModel.user?.record.recordID else {
//                                    print("No user")
//                                    return
//                                }
//                                friendRequestViewModel?.createFriendRequest(senderID: ale.recordID, receiverID: aldoID)
//                            } label: {
//                                Text("Create")
//                            }
                            
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
    //                    self.friendRequestViewModel = FriendRequestsViewModel(user: currentUser)
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
