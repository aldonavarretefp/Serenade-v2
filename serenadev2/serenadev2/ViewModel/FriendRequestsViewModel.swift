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
}
