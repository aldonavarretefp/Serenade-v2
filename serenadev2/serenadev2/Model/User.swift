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
    var record: CKRecord
}

extension User {
    init?(record: CKRecord) {
        print(record)
        guard let accountID = record[UserRecordKeys.accountID.rawValue] as? CKRecord.Reference? else {
            return nil
        }
        guard let name = record[UserRecordKeys.name.rawValue] as? String else {
            print("Didn't find property name")
            return nil
        }
        guard let tagName = record[UserRecordKeys.tagName.rawValue] as? String else {
            print("Didn't find property tagName")
            return nil
        }
        guard let email = record[UserRecordKeys.email.rawValue] as? String else {
            print("Didn't find property email")
            return nil
        }
        guard let friends = record[UserRecordKeys.friends.rawValue] as? [CKRecord.Reference]? else {
            print("Didn't find property friends")
            return nil
        }
        guard let posts = record[UserRecordKeys.posts.rawValue] as? [CKRecord.Reference]? else {
            print("Didn't find property posts")
            return nil
        }
        guard let streak = record[UserRecordKeys.streak.rawValue] as? Int else {
            print("Didn't find property streak")
            return nil
        }
        guard let profilePicture = record[UserRecordKeys.profilePicture.rawValue] as? String else {
            print("Didn't find property profilePicture")
            return nil
        }
        guard let isActive = record[UserRecordKeys.isActive.rawValue] as? Bool else {
            print("Didn't find property isActive")
            return nil
        }
        
        self.init(accountID: accountID, name: name, tagName: tagName, email: email, friends: friends, posts: posts, streak: streak, profilePicture: profilePicture, isActive: isActive, record: record)
    }
}

extension User {
    
    var id: String {
        (accountID?.recordID.recordName)!
    }
}
