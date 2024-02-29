//
//  FriendRequest.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 29/02/24.
//

import Foundation
import CloudKit

enum FriendRecordKeys: String {
    case type = "FriendRequest"
    case sender
    case receiver
    case status
    case date
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
    var date: Date
    
}

extension FriendRequest {
    init?(record: CKRecord) {
        guard let sender = record[FriendRecordKeys.sender.rawValue] as? CKRecord.Reference,
              let receiver = record[FriendRecordKeys.receiver.rawValue] as? CKRecord.Reference,
              let status = record[FriendRecordKeys.status.rawValue] as? String,
                let date = record[FriendRecordKeys.date.rawValue] as? Date
                else {
            return nil
        }
        
        self.init(sender: sender, receiver: receiver, status: FriendRequestStatus(rawValue: status) ?? .pending, date: date)
        
    }
}

extension FriendRequest {
    var record: CKRecord {
        let record = CKRecord(recordType: FriendRecordKeys.type.rawValue)
        record[FriendRecordKeys.sender.rawValue] = sender
        record[FriendRecordKeys.receiver.rawValue] = receiver
        record[FriendRecordKeys.status.rawValue] = status.rawValue
        return record
    }
    var id: String {
        record.recordID.recordName
    }
}
