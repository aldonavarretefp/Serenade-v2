//
//  NotificationItem.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//

import SwiftUI

struct NotificationItem: View {
    // MARK: - Properties
    var user: User
    var friendRequest: FriendRequest
    @EnvironmentObject var friendRequestViewModel: FriendRequestsViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    // MARK: - Body
    var body: some View {
        HStack{
            if user.profilePicture != "" {
                Image(user.profilePicture)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .clipShape(Circle())
                    .padding(.trailing, 5)
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .clipShape(Circle())
                    .padding(.trailing, 5)
            }
            
            
            Text(user.tagName)
                .fontWeight(.semibold)
                .font(.subheadline)
            + Text(LocalizedStringKey("FriendRequest"))
            
            Spacer()
            
            HStack(spacing: 5){
                NotificationActionButton(icon: "xmark"){
                    friendRequestViewModel.declineFriendRequest(friendRequest: friendRequest) {
                        
                    }
                }
                
                NotificationActionButton(icon: "checkmark"){
                    friendRequestViewModel.acceptFriendRequest(friendRequest: friendRequest) {
                        userViewModel.makeFriend(withID: friendRequest.sender.recordID)
                    }
                }
            }
            .padding(.leading)
        }
    }
}

//#Preview {
//    NotificationItem(user: User(name: "Sebastian Leon", tagName: "sebatoo", email: "mail@domain.com", friends: [], posts: [], streak: 15, profilePicture: "AfterHoursCoverArt", isActive: true, record: .init(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "B5E07FDA-EB68-4C72-B547-ACE39273D662"))))
//}
