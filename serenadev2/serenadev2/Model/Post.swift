//
//  Post.swift
//  Serenade
//
//  Created by Alejandro Oliva Ochoa on 08/12/23.
//

import Foundation
import CloudKit

enum PostRecordKeys: String {
    case type = "Post"
    case postType
    case sender
    case receiver
    case caption
    case songId
    case date
    case isAnonymous
    case isActive
}

enum TypeRec: String, CaseIterable, Decodable {
    case daily = "daily"
    case serenade = "serenade"
    case recommendation = "recommendation"
}

// MARK: - Post model
struct Post: Hashable, CloudKitableProtocol, Identifiable {
    var postType: TypeRec
    var sender: CKRecord.Reference?
    var receiver: CKRecord.Reference?
    var caption: String?
    var songId: String
    var date: Date
    var isAnonymous: Bool
    var isActive: Bool
}

extension Post {
    init?(record: CKRecord) {
        guard
            let postTypeString = record[PostRecordKeys.postType.rawValue] as? String,
            let postType = TypeRec(rawValue: postTypeString),
            let sender = record[PostRecordKeys.sender.rawValue] as? CKRecord.Reference?,
            let receiver = record[PostRecordKeys.receiver.rawValue] as? CKRecord.Reference?,
            let caption = record[PostRecordKeys.caption.rawValue] as? String?,
            let songId = record[PostRecordKeys.songId.rawValue] as? String,
            let date = record[PostRecordKeys.date.rawValue] as? Date,
            let isAnonymous = record[PostRecordKeys.isAnonymous.rawValue] as? Bool,
            let isActive = record[PostRecordKeys.isActive.rawValue] as? Bool 
        else {
            return nil
        }
        
        self.init(postType: postType, sender: sender, receiver: receiver, caption: caption, songId: songId, date: date, isAnonymous: isAnonymous, isActive: isActive)
    }
}

extension Post {
    var record: CKRecord {
        let record = CKRecord(recordType: PostRecordKeys.type.rawValue)
        record[PostRecordKeys.postType.rawValue] = postType.rawValue
        record[PostRecordKeys.sender.rawValue] = sender
        record[PostRecordKeys.receiver.rawValue] = receiver
        record[PostRecordKeys.caption.rawValue] = caption
        record[PostRecordKeys.songId.rawValue] = songId
        record[PostRecordKeys.isAnonymous.rawValue] = isAnonymous
        record[PostRecordKeys.isActive.rawValue] = isActive
        record[PostRecordKeys.date.rawValue] = date
        return record
    }
    
    var id: String {
        record.recordID.recordName
    }
}
