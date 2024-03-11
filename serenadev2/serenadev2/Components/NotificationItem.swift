//
//  NotificationItem.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//

import SwiftUI
import CloudKit

struct NotificationItem: View, Identifiable {
    // MARK: - Properties
    let id = UUID()
    var user: User
    var friendRequest: FriendRequest
    @Binding var isDisabled : Bool
    @EnvironmentObject var friendRequestViewModel: FriendRequestsViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
    var completionHandlerAccept: (() -> Void)?
    var completionHandlerReject: (() -> Void)?
    
    // MARK: - Body
    var body: some View {
        HStack{
            NotificationItemPicture(asset: user.profilePictureAsset)
            notificationMessage
            Spacer()
            HStack(spacing: 5) {
                NotificationActionButton(icon: "xmark", isDisabled: isDisabled) {
                    friendRequestViewModel.declineFriendRequest(friendRequest: self.friendRequest) {
                    }
                }
                
                NotificationActionButton(icon: "checkmark", isDisabled: isDisabled) {
                    friendRequestViewModel.acceptFriendRequest(friendRequest: self.friendRequest) {
                        userViewModel.makeFriend(withID: friendRequest.sender.recordID)
                        
                    }
                }
            }
            .padding(.leading)
        }
    }
    
    @ViewBuilder
    func NotificationItemPicture(asset: CKAsset?) -> some View {
        if let asset {
            AsyncImage(url: asset.fileURL) { phase in
                switch phase {
                case .success(let img):
                    img
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                default:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                }
            }
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .clipShape(Circle())
                .padding(.trailing, 5)
        }
    }
    
    var notificationMessage: some View {
        Text(user.tagName)
            .fontWeight(.semibold)
            .font(.subheadline)
        + Text(LocalizedStringKey("FriendRequest"))
    }
}

//#Preview {
//    NotificationItem(user: User(name: "Sebastian Leon", tagName: "sebatoo", email: "mail@domain.com", friends: [], posts: [], streak: 15, profilePicture: "AfterHoursCoverArt", isActive: true, record: .init(recordType: UserRecordKeys.type.rawValue, recordID: .init(recordName: "B5E07FDA-EB68-4C72-B547-ACE39273D662"))))
//}
