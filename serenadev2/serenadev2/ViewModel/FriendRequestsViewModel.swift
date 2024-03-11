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
    @Published var friendRequests: [FriendRequest] = []
    @Published var userDetails: [CKRecord.ID: User] = [:]
    var cancellables = Set<AnyCancellable>()
    
    private func fetchUserDetails(for recordID: CKRecord.ID) {
        // Use CloudKit to fetch the CKRecord for the given recordID
        // Then initialize a User object with the fetched CKRecord and store it in `userDetails`
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { [weak self] record, error in
            guard let record = record, error == nil else {
                print("Error fetching user details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let user = User(record: record) {
                DispatchQueue.main.async {
                    self?.userDetails[recordID] = user
                }
            }
        }
    }
    
    func fetchFriendRequestsForUser(user: User) {
        
        let recordToMatch = CKRecord.Reference(record: user.record, action: .none)
        let predicate = NSPredicate(format: "receiver == %@ && status == %@", recordToMatch, FriendRequestStatus.pending.rawValue)
        let recordType = FriendRequestsRecordKeys.type.rawValue
        let sortDescriptor = NSSortDescriptor(key: FriendRequestsRecordKeys.timeStamp.rawValue, ascending: false)
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptions: [sortDescriptor])
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] (returnedFriendRequests: [FriendRequest]) in
                DispatchQueue.main.async {
                    self?.friendRequests = returnedFriendRequests
                    print(self?.friendRequests.count ?? -1)
                }
                for request in returnedFriendRequests {
                    let record = CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: request.sender.recordID)
                    self?.fetchUserDetails(for: record.recordID)
                }
            }
            .store(in: &cancellables)
    }
    /**
     Fetches the friend requests for the user.
     - Parameters:
     - user: The user to fetch the friend requests for.
     */
    func fetchFriendRequestsForUser(user: User, completionHandler: @escaping () -> Void) {
        
        let recordToMatch = CKRecord.Reference(record: user.record, action: .none)
        let predicate = NSPredicate(format: "receiver == %@ && status == %@", recordToMatch, FriendRequestStatus.pending.rawValue)
        let recordType = FriendRequestsRecordKeys.type.rawValue
        let sortDescriptor = NSSortDescriptor(key: FriendRequestsRecordKeys.timeStamp.rawValue, ascending: false)
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptions: [sortDescriptor])
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { [weak self] (returnedFriendRequests: [FriendRequest]) in
                guard let self else {
                    print("VM doesn't exists")
                    return
                }
                DispatchQueue.main.async {
                    print("Model ",returnedFriendRequests.count)
                    withAnimation {
                        self.friendRequests = returnedFriendRequests
                    }
                }
                for request in returnedFriendRequests {
                    let record = CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: request.sender.recordID)
                    self.fetchUserDetails(for: record.recordID)
                }
                completionHandler()
            }
            .store(in: &cancellables)
    }
    
    func fetchFriendRequest(from sender: User, for reciever: User, completionHandler: @escaping ([FriendRequest]) -> Void){
        let recordSenderToMatch = CKRecord.Reference(record: sender.record, action: .none)
        let recordReceiverToMatch = CKRecord.Reference(record: reciever.record, action: .none)
        
        let predicate = NSPredicate(format: "receiver == %@ && sender == %@ && status == %@", recordReceiverToMatch, recordSenderToMatch, FriendRequestStatus.pending.rawValue)
        let recordType = FriendRequestsRecordKeys.type.rawValue
        
        let sortDescriptor = NSSortDescriptor(key: FriendRequestsRecordKeys.timeStamp.rawValue, ascending: false)
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptions: [sortDescriptor])
            .receive(on: DispatchQueue.main)
            .sink { _ in
            } receiveValue: { (returnedFriendRequests: [FriendRequest]) in
                completionHandler(returnedFriendRequests)
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
        
        guard let friendRequest = FriendRequest(sender: senderReference, receiver: receiverReference, status: requestStatus, timeStamp: timeStamp) else {
            print("Could not create new Friend Request")
            return
        }
        
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
        friendRequest.record[FriendRequestsRecordKeys.status.rawValue] = FriendRequestStatus.accepted.rawValue
        CloudKitUtility.update(item: friendRequest) { result in
            switch result {
            case .success(_):
                self.removeFriendRequestFromList(friendRequest)
                completionHandler()
                break;
            case .failure(let error):
                print("Error while accepting the friend request", error.localizedDescription)
                break;
            }
        }
    }
    
    func removeFriendRequestFromList(_ friendRequest: FriendRequest) {
        DispatchQueue.main.async {
            withAnimation {
                self.friendRequests = self.friendRequests.filter { $0 != friendRequest }
                self.userDetails.removeValue(forKey: friendRequest.sender.recordID)
            }
            
        }
    }
    
    /**
     Declines a friend request from certain  and updates the status of the friend request to declined.
     - Parameters:
     - friendRequest: The friend request to decline.
     */
    func declineFriendRequest(friendRequest: FriendRequest, completionHandler: @escaping () -> Void) {
        friendRequest.record[FriendRequestsRecordKeys.status.rawValue] = FriendRequestStatus.rejected.rawValue
        CloudKitUtility.update(item: friendRequest) { result in
            switch result {
            case .success(_):
                print("DeclinedFriendRequest")
                self.removeFriendRequestFromList(friendRequest)
                completionHandler()
                break;
            case .failure(let error):
                print("Failure", error.localizedDescription)
                break;
            }
        }
    }
    
    func deleteFriendReques(friendRequest: FriendRequest, completionHandler: @escaping () -> Void) {
        _ = CloudKitUtility.delete(item: friendRequest)
    }
}
