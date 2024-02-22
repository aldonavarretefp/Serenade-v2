//
//  UserService.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 20/02/24.
//

import Foundation

//
//  UserService.swift
//  Serenade
//
//  Created by Aldo Yael Navarrete Zamora on 13/12/23.
//

import Foundation


/*
 This class is used to fetch the user from the database.
 // MARK: - User model
 struct User: Identifiable, Decodable {
 var id: String
 var name: String
 var email: String
 var friends: [String]
 var posts: [String]
 var streak: Int
 var queue: [String]
 var profilePictue: String
 var notifications: [String]
 var isActive: Bool
 }
 */

class UserService {
//    
//    static let db = Firestore.firestore()
//    static func fetchUser(withId id: String, completionHandler: @escaping (Result<User, Error>) -> Void) {
//
//        db.collection("users").document(id).getDocument { (snapshot, error) in
//            if let error = error {
//                completionHandler(.failure(error))
//                return
//            }
//            guard let data = snapshot?.data() else {
//                completionHandler(.failure(NSError(domain: "UserDataNotFound", code: -1, userInfo: nil)))
//                return
//            }
//            guard let user = User(data: data) else {
//                completionHandler(.failure(NSError(domain: "DecodingError", code: -1, userInfo: nil)))
//                return
//            }
//            completionHandler(.success(user))
//        }
//    }
//    
//    static func saveUser(user: User, completionHandler: @escaping((Error?) -> Void) ) {
//        let userData: [String: Any] = [
//            "name": user.name,
//            "username": user.username,
//            "tagName": user.tagName,
//            "profileImageUrl": user.profilePictue,
//            "streak": user.streak
//        ]
//        db.collection("users").document(user.id).setData(userData, merge: true) { error in
//            if let error {
//                completionHandler(error)
//                return
//            }
//            completionHandler(nil)
//        }
//    }
//    
//    static func appendPostIdToUserPostsWithUserId(userId: String, postId: String, completionHandler: @escaping((Error?) -> Void)) {
//        let updateData = ["posts": FieldValue.arrayUnion([postId])]
//        db.collection("users").document(userId).setData(updateData, merge: true) { error in
//            if let error {
//                completionHandler(error)
//            }
//            completionHandler(nil)
//        }
//    }
}
