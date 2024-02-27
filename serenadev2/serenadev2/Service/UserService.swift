//
//  UserService.swift
//  Serenade
//
//  Created by Aldo Yael Navarrete Zamora on 13/12/23.
//

import Foundation
import CloudKit

enum UserServiceError: Error {
    case couldNotFetchUser(String)
    case couldNotAddFriend(String)
}

class UserService {
    
    static let database = CKContainer(identifier: Config.containerIdentifier).publicCloudDatabase
    
    static func createUser(user: User) async throws {
        try await database.save(user.record)
    }
    
    static func fetchUserWithId(id: CKRecord.ID) async throws -> User {
        let recordID = id
        let record = try await database.record(for: recordID)
        guard let user = User(record: record) else {
            throw UserServiceError.couldNotFetchUser("No se pudo traer al usuario")
        }
        return user
    }
    /*
        This method will append a friend from the friendsRequestReceived array to the friends array of the user with the idFromUser and remove the friend from the friendsRequestReceived array.
    */
//    static func sendFriendRequestTo(user: User, fromUser: User) async throws {
//            guard let fromUserId = fromUser.id, let newFriendId = fromUser.id else {
//                throw UserServiceError.couldNotAddFriend("Could not get ids from users")
//            }
//            
//            // Creating a new friend request record
//            let friendRequestRecord = CKRecord(recordType: "FriendRequest")
//            
//            // Setting references for fromUser and toUser
//            friendRequestRecord["fromUser"] = CKRecord.Reference(recordID: fromUserId, action: .none)
//            friendRequestRecord["toUser"] = CKRecord.Reference(recordID: newFriendId, action: .none)
//            
//            // Optionally set the status and timestamp
//            friendRequestRecord["status"] = "pending" as CKRecordValue
//            friendRequestRecord["timestamp"] = Date() as CKRecordValue
//            
//            do {
//                try await database.save(friendRequestRecord)
//            } catch {
//        
//                throw error
//            }
//        }
    
    static func deleteFriendFromUserWithId(id: String, friendId: String) {
        
    }
    
    static func inactivateUserWithId(id: String) {
        
    }
    
    static func fetchFriendsFromUserWithId(id: String) {
        
    }
    
    static func updateUserWithId(id: String, updatedUser: User) {
        
    }
    
    // Example conversion method (needs to be implemented based on your User struct)
//    private static func convertRecordToUser(_ record: CKRecord) -> User {
//        // Extract values from the record and initialize a User instance
//        let id = record.recordID
//        let name = record["name"] as? String ?? ""
//        let email = record["email"] as? String ?? ""
//        let friends = record["friends"] as? [CKRecord.Reference] ?? []
//        let posts = record["posts"] as? [CKRecord.Reference] ?? []
//        let streak = record["streak"] as? Int ?? 0
//        let profilePicture = record["profilePicture"] as? String ?? ""
//        let tagName = record["tagName"] as? String ?? ""
//        let isActive = record["isActive"] as? Bool ?? false
//        
//        return User(id: id, name: name, tagName: tagName, email: email, friends: friends, posts: posts, streak: streak, profilePicture: profilePicture, isActive: isActive)
//    }
    
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
