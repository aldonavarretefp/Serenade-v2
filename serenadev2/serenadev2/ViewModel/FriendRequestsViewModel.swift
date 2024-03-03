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

class FriendRequestsViewModel {
    
    @Published var friendRequests = [FriendRequest]()
    var cancellables = Set<AnyCancellable>()
    
    init(user: User) {
        fetchFriendRequestsForUser(user: user)
    }
    
    /**
     Fetches the friend requests for the user.
     - Parameters:
        - user: The user to fetch the friend requests for.
     */
    func fetchFriendRequestsForUser(user: User) {
        let userID = CKRecord.ID(recordName: "87E3D069-576C-4DF4-A297-C5A15D231511")
        
        let recordToMatch = CKRecord.Reference(recordID: CKRecord.ID(recordName: "87E3D069-576C-4DF4-A297-C5A15D231511"), action: .none)
        let predicate = NSPredicate(format: "receiver == %@", recordToMatch)
        let recordType = FriendRequestsRecordKeys.type.rawValue
        print(recordToMatch)
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
        let requestStatus: FriendRequestStatus = .pending
        let timeStamp: Date = .now
        
        let friendRequest = FriendRequest(sender: senderReference, receiver: receiverReference, status: requestStatus, timeStamp: timeStamp, record: CKRecord(recordType: FriendRequestsRecordKeys.type.rawValue))
        
        CloudKitUtility.add(item: friendRequest) { result in
            switch result {
            case .success(_):
                print("Success sending friend request!")
                break;
            case .failure(let error):
                print(error.localizedDescription)
                break;
            }
        }
    }

    /**
        Accepts a friend request from certain  and updates the status of the friend request to accepted.
        - Parameters:
            - friendRequest: The friend request to accept.
    */
    func acceptFriendRequest(friendRequest: FriendRequest, completionHandler: @escaping () -> Void) {
        friendRequest.record["status"] = FriendRequestStatus.accepted.rawValue
        CloudKitUtility.update(item: friendRequest) { result in
            switch result {
            case .success(_):
                print("Success accepting friend request!")
                completionHandler()
                break;
            case .failure(let error):
                print("Error while accepting the friend request", error.localizedDescription)
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
        friendRequest.record["status"] = FriendRequestStatus.rejected.rawValue
        CloudKitUtility.update(item: friendRequest) { result in
            switch result {
            case .success(_):
                print("Updated succesfully")
                break;
            case .failure(let error):
                print("Failure", error.localizedDescription)
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
