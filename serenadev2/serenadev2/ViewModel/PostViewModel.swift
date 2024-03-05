//
//  PostViewModel.swift
//  serenadev2
//
//  Created by Diego Ignacio Nunez Hernandez on 28/02/24.
//

import Foundation
import CloudKit
import Combine

class PostViewModel: ObservableObject {
    @Published var error: String = ""
    @Published var senderDetails: [CKRecord.ID: User] = [:]
    var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func fetchSenderDetails() {
        
    }
    
    func fetchUserFromRecord(record: CKRecord, completion: @escaping (User?) -> Void) {
        let predicate = NSPredicate(format: "recordID == %@", record.recordID)
                let recordType = UserRecordKeys.type.rawValue
                
                CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
                    .receive(on: DispatchQueue.main)
                    .sink { _ in
                        //completion(nil) // Llamada asincrónica fallida, devolver nil
                    } receiveValue: { returnedUsers in
                        let users: [User]? = returnedUsers
                        guard let userR = users?[0] else {
                            completion(nil) // Llamada asincrónica exitosa pero sin usuarios devueltos
                            return
                        }
                        completion(userR) // Llamada asincrónica exitosa con usuario devuelto
                    }
                    .store(in: &cancellables)
    }
    
    func fetchAllPosts(user: User, completion: @escaping ([Post]?) -> Void){
        let userID: CKRecord.Reference = CKRecord.Reference(recordID: user.record.recordID, action: .none)
        if user.friends == nil {
            //            print("NO FRIENDS")
            fetchAllPostsFromUserID(id: user.record.recordID) {(returnedPosts:[Post]?) in
                guard let posts = returnedPosts else {
                    print("No posts")
                    return
                }
                if returnedPosts != nil {
                    for post in posts {
                        let senderRecord = CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: post.sender!.recordID)
                        self.fetchUserFromRecord(record: senderRecord) { (returnedUser: User?) in
                            print(returnedUser ?? "No user")
                            if let returnedUser {
                                DispatchQueue.main.async {
                                    self.senderDetails[returnedUser.record.recordID] = returnedUser
                                }
                            }
                        }                        }
                    }
                    completion(returnedPosts)
                }
            }
        
        else {
//                        print("FRIENDS: \(user.friends!)")
            var userList = user.friends!
            userList.append(userID)
            let predicate = NSPredicate(format: "sender IN %@ && isActive == 1", userList)
            let recordType = PostRecordKeys.type.rawValue
            
            CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { returnedPosts in
                    let posts: [Post]? = returnedPosts
                    guard posts != nil else {
                        completion(nil)
                        return
                    }
                    completion(posts)
                }
                .store(in: &cancellables)
        }
    }
    
    func fetchAllPostsFromUserID(id: CKRecord.ID, completion: @escaping ([Post]?) -> Void){
        let recordToMatch = CKRecord.Reference(recordID: id, action: .none)
        let predicate = NSPredicate(format: "sender == %@ && isActive == 1", recordToMatch)
        //        print("FETCH POSTS PREDICATE: \(predicate)\n")
        let recordType = PostRecordKeys.type.rawValue
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { returnedPosts in
                let posts: [Post]? = returnedPosts
                guard posts != nil else {
                    completion(nil)
                    return
                }
                completion(posts)
            }
            .store(in: &cancellables)
    }
    
    func createAPost(post: Post){
        let recordToMatch = CKRecord.Reference(recordID: post.sender!.recordID, action: .none)
        let newPost = Post(postType: post.postType, sender: recordToMatch, receiver: post.receiver, caption: post.caption, songId: post.songId, date: post.date, isAnonymous: post.isAnonymous, isActive: post.isActive)
        CloudKitUtility.add(item: newPost) { _ in }
    }
}

