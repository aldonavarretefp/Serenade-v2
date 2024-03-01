//
//  FriendRequestsViewModel.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 29/02/24.
//

import Foundation
import SwiftUI
import CloudKit
import Combine

class FriendRequestsViewModel: ObservableObject {
    
    @Published var friendRequests = [FriendRequest]()
    var cancellables = Set<AnyCancellable>()
    
    /**
     Fetches the friend requests for the user.
     - Parameters:
        - user: The user to fetch the friend requests for.
     */
    func fetchFriendRequestsForUser(user: User) {
        let userID = user.record.recordID
        let recordToMatch = CKRecord.Reference(recordID: userID, action: .none)
        let predicate = NSPredicate(format: "receiver == %@", recordToMatch)
        let recordType = FriendRecordKeys.type.rawValue
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedFriendRequests in
                self?.friendRequests = returnedFriendRequests
            }
            .store(in: &cancellables)
        
    }

    /**
        Creates a friend request that links two users with their IDs.
        - Parameters:
            - senderID: The ID of the user that is sending the friend request.
            - receiverID: The ID of the user that is receiving the friend request.
    */
    func createFriendRequest(senderID: CKRecord.ID, receiverID: CKRecord.ID) {
        
        let senderReference = CKRecord.Reference(recordID: senderID, action: .none)
        let receiverReference = CKRecord.Reference(recordID: receiverID, action: .none)
        
        let friendRequest = FriendRequest(sender: senderReference, receiver: receiverReference, status: .pending, date: .now)
        
        CloudKitUtility.add(item: friendRequest) { result in
            switch result {
            case .success(_):
                print("Success sending friend request!")
                break;
            case .failure(_):
                break;
            }
        }
    }

    /**
        Accepts a friend request from certain  and updates the status of the friend request to accepted.
        - Parameters:
            - friendRequest: The friend request to accept.
    */
    func acceptFriendRequest(friendRequest: FriendRequest) {
        var updatedFriendRequest = friendRequest
        updatedFriendRequest.status = .accepted
        CloudKitUtility.update(item: updatedFriendRequest) { result in
            switch result {
            case .success(_):
                print("Success accepting friend request!")
                break;
            case .failure(_):
                break;
            }
        }
    }

    /**
        Declines a friend request from certain  and updates the status of the friend request to declined.
        - Parameters:
            - friendRequest: The friend request to decline.
    */
    func declineFriendRequest(friendRequest: FriendRequest) {
        var updatedFriendRequest = friendRequest
        updatedFriendRequest.status = .rejected
        CloudKitUtility.update(item: updatedFriendRequest) { result in
            switch result {
            case .success(_):
                break;
            case .failure(_):
                break;
            }
        }
    }

    /**
        Adds the sender to the receiver's friends list and viceversa.
        - Parameters:
            - friendRequest: The friend request to accept.
    */
    func acceptFriendRequestAndAddFriend(friendRequest: FriendRequest) {
        let senderID = friendRequest.sender.recordID
        let receiverID = friendRequest.receiver.recordID
        let predicate = NSPredicate(format: "accountID == %@", senderID)
        let userRecordType = UserRecordKeys.type.rawValue
        print(senderID, receiverID, predicate, userRecordType)
        
    }
    
    private func addFriend(friend: User, to user: User) {
        var updatedUser = user
        let friendAccountID = friend.record.recordID
        let reference = CKRecord.Reference(recordID: friendAccountID, action: .none)
        updatedUser.friends?.append(reference)
        CloudKitUtility.update(item: updatedUser) { _ in }
    }

}
