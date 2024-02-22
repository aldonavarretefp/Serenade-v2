//
//  User.swift
//  Serenade
//
//  Created by Diego Ignacio Nunez Hernandez on 08/12/23.
//

import Foundation

// MARK: - User model
struct User: Identifiable, Decodable {
    var id: String
    var name: String
    var username: String
    var email: String
    var friends: [String]
    var posts: [String]
    var streak: Int
    var queue: [String]
    var profilePictue: String
    var notifications: [String]
    var isActive: Bool
    var tagName: String
}

extension User {
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
              let name = data["name"] as? String,
              let email = data["email"] as? String,
              let friends = data["friends"] as? [String],
              let posts = data["posts"] as? [String],
              let streak = data["streak"] as? Int,
              let queue = data["queue"] as? [String],
              let profilePictue = data["profileImageUrl"] as? String,
              let notifications = data["notifications"] as? [String],
              let isActive = data["isActive"] as? Bool,
              let tagName = data["tagName"] as? String,
              let username = data["tagName"] as? String else
              {
            return nil
        }

        self.id = id
        self.name = name
        self.email = email
        self.friends = friends
        self.posts = posts
        self.streak = streak
        self.queue = queue
        self.profilePictue = profilePictue
        self.notifications = notifications
        self.isActive = isActive
        self.tagName = tagName
        self.username = username
    }
}
