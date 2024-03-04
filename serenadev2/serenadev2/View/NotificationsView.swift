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
    @State var friendRequestViewModel: FriendRequestsViewModel? = nil
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.viewBackground
                    .ignoresSafeArea()
                
                VStack{
                    ScrollView{
                        VStack(spacing: 35){
                            if let vm = friendRequestViewModel {
                                
                                ForEach(vm.friendRequests, id: \.self) { request in
                                    let record = CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: request.sender.recordID)
                                    
                                    let user = User(record: record)
                                    if let user {
                                        Text("\(user.name) te mandó solicitud")
                                    }
                                }
                                
                            }
                            
                            NotificationItem(user: User(name: "Sebastian Leon", tagName: "sebatoo", email: "mail@domain.com", streak: 15, profilePicture: "AfterHoursCoverArt", isActive: true, record: CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "B5E07FDA-EB68-4C72-B547-ACE39273D662"))))
                            
                            
                            Button {
                                print(friendRequestViewModel?.friendRequests)
                            } label: {
                                Text("Print model")
                            }
                            
                            Button {
                                guard let friendRequests = friendRequestViewModel?.friendRequests else {
                                    return
                                }
                                Task {
                                    friendRequestViewModel?.acceptFriendRequest(friendRequest: friendRequests[0]) {
                                        guard let user = userViewModel.user else { return }
                                        userViewModel.makeFriends(withId: user, friendId: friendRequests[0].sender.recordID)
                                    }
                                    
                                    
                                }
                                
                            } label: {
                                Text("Accept")
                            }
                            
                            Button {
                                guard let friendRequests = friendRequestViewModel?.friendRequests else {
                                    print("NO friend requests")
                                    return
                                }
                                friendRequestViewModel?.declineFriendRequest(friendRequest: friendRequests[0])
                            } label: {
                                Text("Decline")
                            }
                            
                            
                            Button {
                                let ale = CKRecord.init(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "110590A8-297A-495C-929D-B9951EAFF752"))
                                guard let aldoID = userViewModel.user?.record.recordID else {
                                    print("No user")
                                    return
                                }
                                friendRequestViewModel?.createFriendRequest(senderID: ale.recordID, receiverID: aldoID)
                            } label: {
                                Text("Create")
                            }
                            
                        }
                        .padding()
                    }
                }
                .toolbarBackground(.black)
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(colorScheme == .light ? .white : .black,for: .navigationBar)
            .navigationTitle("Notifications")
            .toolbarTitleDisplayMode(.inline)
            .onAppear {
                
                if friendRequestViewModel == nil, let currentUser = userViewModel.user {
                    self.friendRequestViewModel = FriendRequestsViewModel(user: currentUser)
                }
                
                
            }
        }
    }
}

#Preview {
    NotificationsView()
}
