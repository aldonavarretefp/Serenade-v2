//
//  FriendRequest.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 29/02/24.
//

import Foundation
import CloudKit

enum FriendRequestsRecordKeys: String {
    case type = "FriendRequest"
    case sender
    case receiver
    case status
    case timeStamp
}

enum FriendRequestStatus: String {
    case pending
    case accepted
    case rejected
}

struct FriendRequest: Hashable, CloudKitableProtocol {
    var sender: CKRecord.Reference
    var receiver: CKRecord.Reference
    var status: FriendRequestStatus
    var timeStamp: Date
    var record: CKRecord
    
}

extension FriendRequest {
    init?(record: CKRecord) {
        guard let sender = record[FriendRequestsRecordKeys.sender.rawValue] as? CKRecord.Reference,
              let receiver = record[FriendRequestsRecordKeys.receiver.rawValue] as? CKRecord.Reference,
              let status = record[FriendRequestsRecordKeys.status.rawValue] as? String,
                let timeStamp = record[FriendRequestsRecordKeys.timeStamp.rawValue] as? Date
                else {
            return nil
        }
        
        self.init(sender: sender, receiver: receiver, status: FriendRequestStatus(rawValue: status) ?? .pending, timeStamp: timeStamp, record: record)
        
    }
}

extension FriendRequest {
    
    var id: String {
        record.recordID.recordName
    }
}
