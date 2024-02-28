//
//  User.swift
//  Serenade
//
//  Created by Diego Ignacio Nunez Hernandez on 08/12/23.
//

import Foundation
import CloudKit

enum UserRecordKeys: String {
    case type = "User"
    case name
    case username
    case email
    case friends
    case posts
    case streak
    case queue
    case profilePicture
    case notifications
    case isActive
    case tagName
    case friendRequestSent
    case friendRequestReceived
}

struct User: Identifiable {
    var id: CKRecord.ID?
    var name: String
    var email: String
    var friends: [CKRecord.Reference]?
    var posts: [CKRecord.Reference]?
    var streak: Int
    var profilePicture: String
    var isActive: Bool
    var tagName: String
    var friendRequestSent: [CKRecord.Reference]?
    var friendRequestReceived: [CKRecord.Reference]?
}

extension User {
    init?(record: CKRecord) {
        guard let name = record[UserRecordKeys.name.rawValue] as? String,
                let email = record[UserRecordKeys.email.rawValue] as? String,
              let friends = record[UserRecordKeys.friends.rawValue] as? [CKRecord.Reference]?,
                let posts = record[UserRecordKeys.posts.rawValue] as? [CKRecord.Reference]?,
                let streak = record[UserRecordKeys.streak.rawValue] as? Int,
                let profilePicture = record[UserRecordKeys.profilePicture.rawValue] as? String,
                let isActive = record[UserRecordKeys.isActive.rawValue] as? Bool,
              let tagName = record[UserRecordKeys.tagName.rawValue] as? String,
              let friendRequestSent = record[UserRecordKeys.friendRequestSent.rawValue] as? [CKRecord.Reference]?,
              let friendRequestReceived = record[UserRecordKeys.friendRequestReceived.rawValue] as? [CKRecord.Reference]? else {
            return nil
        }
        
        self.init(id: record.recordID, name: name, email: email, friends: friends, posts: posts, streak: streak, profilePicture: profilePicture, isActive: isActive, tagName: tagName, friendRequestSent: friendRequestSent, friendRequestReceived: friendRequestReceived)
    }
}

extension User {
    var record: CKRecord {
        let record = CKRecord(recordType: UserRecordKeys.type.rawValue)
        
        record[UserRecordKeys.name.rawValue] = name
        record[UserRecordKeys.email.rawValue] = email
        record[UserRecordKeys.friends.rawValue] = friends
        record[UserRecordKeys.posts.rawValue] = posts
        record[UserRecordKeys.streak.rawValue] = streak
        record[UserRecordKeys.profilePicture.rawValue] = profilePicture
        record[UserRecordKeys.isActive.rawValue] = isActive
        record[UserRecordKeys.tagName.rawValue] = tagName
        record[UserRecordKeys.friendRequestSent.rawValue] = friendRequestSent
        record[UserRecordKeys.friendRequestReceived.rawValue] = friendRequestReceived
        
        return record
        
    }
}
