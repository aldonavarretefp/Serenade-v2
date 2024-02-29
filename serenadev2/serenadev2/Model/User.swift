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
    case accountID
    case name
    case tagName
    case email
    case friends
    case posts
    case streak
    case profilePicture
    case isActive
}

struct User: Hashable, CloudKitableProtocol {
    var accountID: CKRecord.Reference?
    var name: String
    var tagName: String
    var email: String
    var friends: [CKRecord.Reference]?
    var posts: [CKRecord.Reference]?
    var streak: Int
    var profilePicture: String
    var isActive: Bool
}

extension User {
    init?(record: CKRecord) {
        guard let accountID = record[UserRecordKeys.accountID.rawValue] as? CKRecord.Reference,
              let name = record[UserRecordKeys.name.rawValue] as? String,
              let tagName = record[UserRecordKeys.tagName.rawValue] as? String,
              let email = record[UserRecordKeys.email.rawValue] as? String,
              let friends = record[UserRecordKeys.friends.rawValue] as? [CKRecord.Reference]?,
              let posts = record[UserRecordKeys.posts.rawValue] as? [CKRecord.Reference]?,
              let streak = record[UserRecordKeys.streak.rawValue] as? Int,
              let profilePicture = record[UserRecordKeys.profilePicture.rawValue] as? String,
              let isActive = record[UserRecordKeys.isActive.rawValue] as? Bool else {
            return nil
        }
        
        self.init(accountID: accountID,name: name, tagName: tagName, email: email, friends: friends, posts: posts, streak: streak, profilePicture: profilePicture, isActive: isActive)
    }
}

extension User {
    var record: CKRecord {
        let record = CKRecord(recordType: UserRecordKeys.type.rawValue)
        record[UserRecordKeys.accountID.rawValue] = accountID
        record[UserRecordKeys.name.rawValue] = name
        record[UserRecordKeys.tagName.rawValue] = tagName
        record[UserRecordKeys.email.rawValue] = email
        record[UserRecordKeys.friends.rawValue] = friends
        record[UserRecordKeys.posts.rawValue] = posts
        record[UserRecordKeys.streak.rawValue] = streak
        record[UserRecordKeys.profilePicture.rawValue] = profilePicture
        record[UserRecordKeys.isActive.rawValue] = isActive
        return record
    }
    
    var id: String {
        (accountID?.recordID.recordName)!
    }
}
