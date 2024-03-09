//
//  PostViewModel.swift
//  serenadev2
//
//  Created by Diego Ignacio Nunez Hernandez on 28/02/24.
//

import Foundation
import CloudKit
import Combine
import SwiftUI

class PostViewModel: ObservableObject {
    @Published var senderDetails: [CKRecord.ID: User] = [:]
    @Published var songsDetails: [String: SongModel] = [:]
    @Published var posts: [Post] = []
    var cancellables = Set<AnyCancellable>()
    
    func fetchSenderDetails(for recordID: CKRecord.ID) {
        // Use CloudKit to fetch the CKRecord for the given recordID
        // Then initialize a User object with the fetched CKRecord and store it in `userDetails`
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { [weak self] record, error in
            guard let record = record, error == nil else {
                print("Error fetching user details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let user = User(record: record) {
                DispatchQueue.main.async {
                    self?.senderDetails[recordID] = user
                }
            }
        }
    }
    
    //MARK: AsyncFunc
    
    func fetchSenderDetailsAsync(for recordID: CKRecord.ID) async {
        do {
            let record = try await CKContainer.default().publicCloudDatabase.record(for: recordID)
            if let user = User(record: record) {
                
                DispatchQueue.main.async {
                    self.senderDetails[recordID] = user
                }
                
            }
        } catch {
            print("Error fetching user details: \(error.localizedDescription)")
        }
    }
    
    func fetchAllPostsFromUserIDAsync(id: CKRecord.ID) async -> [Post]? {
        let recordToMatch = CKRecord.Reference(recordID: id, action: .none)
        let predicate = NSPredicate(format: "sender == %@ && isActive == 1", recordToMatch)
        let recordType = PostRecordKeys.type.rawValue
        
        do {
            let posts: [Post] = try await CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            sortPostsByDate()
            return posts
        } catch {
            print("Error fetching posts: \(error)")
            return nil
        }
    }
    
    func fetchAllPostsAsync(user: User) async {
        let userID: CKRecord.Reference = CKRecord.Reference(recordID: user.record.recordID, action: .none)
        
        // Your logic to determine if user.friends is nil remains the same
        if user.friends.count == 0 {
            // Now call an async version of `fetchAllPostsFromUserID`
            if let posts = await fetchAllPostsFromUserIDAsync(id: user.record.recordID) {
                DispatchQueue.main.async {
                    
                        self.posts = posts
                    
                }
                sortPostsByDate()
                for post in posts {
                    guard let sender = post.sender else {
                        print("Post has no sender")
                        return
                    }
                    // Make sure `fetchSenderDetails` is also async if it performs asynchronous operations
                    await fetchSenderDetailsAsync(for: sender.recordID)
                    let result = await SongHistoryManager.shared.fetchSong(id: post.songId)
                    switch result {
                    case .success(let songModel):
                        DispatchQueue.main.async {
                            self.songsDetails[post.songId] = songModel
                        }
                    default:
                        print("ERROR: Couldn't bring song details")
                        break;
                    }
                    
                }
            }
        } else {
            let userFriends = user.friends
            var userList = userFriends
            userList.append(userID)
            
            let predicate = NSPredicate(format: "sender IN %@ && isActive == 1", userList)
            let recordType = PostRecordKeys.type.rawValue
            
            do {
                let posts: [Post] = try await CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
                DispatchQueue.main.async {
                    self.posts = posts
                }
                sortPostsByDate()
                for post in posts {
                    guard let sender = post.sender else {
                        print("Post has no sender")
                        return
                    }
                    // Make sure `fetchSenderDetails` is also async if it performs asynchronous operations
                    await fetchSenderDetailsAsync(for: sender.recordID)
                    let result = await SongHistoryManager.shared.fetchSong(id: post.songId)
                    switch result {
                    case .success(let songModel):
                        DispatchQueue.main.async {
                            self.songsDetails[post.songId] = songModel
                        }
                    default:
                        print("ERROR: Couldn't bring song details")
                        break;
                    }
                    
                }
            } catch {
                print("Error fetching posts: \(error)")
            }
            
        }
    }
    
    //MARK: Closure Functions
    
    func fetchAllPosts(user: User) {
        let userID: CKRecord.Reference = CKRecord.Reference(recordID: user.record.recordID, action: .none)
        if user.friends.count == 0 {
            fetchAllPostsFromUserID(id: user.record.recordID) { (returnedPosts:[Post]?) in
                guard let posts = returnedPosts else {
                    print("No posts")
                    return
                }
                DispatchQueue.main.async {
                    self.posts = posts
                }
                for post in posts {
                    guard let sender = post.sender else {
                        print("Post has no sender")
                        return
                    }
                    self.fetchSenderDetails(for: sender.recordID)
                    self.sortPostsByDate()
                }
            }
        }
        else {
            var userList = user.friends
            userList.append(userID)
            
            let predicate = NSPredicate(format: "sender IN %@ && isActive == 1", userList)
            let recordType = PostRecordKeys.type.rawValue
            
            CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    
                } receiveValue: { (returnedPosts: [Post]?) in
                    guard let posts = returnedPosts else {
                        print("No returned posts userfriends is NIL")
                        return
                    }
                    DispatchQueue.main.async {
                        self.posts = posts
                    }
                    self.sortPostsByDate()
                }
                .store(in: &cancellables)
        }
    }
    
    func fetchUserFromRecord(record: CKRecord, completion: @escaping (User?) -> Void) {
        let predicate = NSPredicate(format: "recordID == %@", record.recordID)
        let recordType = UserRecordKeys.type.rawValue
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                //completion(nil) // Llamada asincrónica fallida, devolver nil
            } receiveValue: { (returnedUsers: [User]?) in
                guard let users = returnedUsers, users.count != 0 else {
                    completion(nil) // Llamada asincrónica exitosa pero sin usuarios devueltos
                    return
                }
                let userR = users[0]
                completion(userR) // Llamada asincrónica exitosa con usuario devuelto
            }
            .store(in: &cancellables)
    }
    
    func fetchAllPostsFromUserID(id: CKRecord.ID, completion: @escaping ([Post]?) -> Void){
        let recordToMatch = CKRecord.Reference(recordID: id, action: .none)
        let predicate = NSPredicate(format: "sender == %@ && isActive == 1", recordToMatch)
        
        let recordType = PostRecordKeys.type.rawValue
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { (returnedPosts: [Post]?) in
                guard let posts = returnedPosts else {
                    return
                }
                completion(posts)
                for post in posts {
                    guard let sender = post.sender else {
                        print("Post has no sender")
                        return
                    }
                    self.fetchSenderDetails(for: sender.recordID)
                    self.sortPostsByDate()
                }
                
            }
            .store(in: &cancellables)
    }
    
    func createAPost(post: Post, completionHandler: @escaping (() -> Void) ){
        let recordToMatch = CKRecord.Reference(recordID: post.sender!.recordID, action: .none)
        let newPost = Post(postType: post.postType, sender: recordToMatch, receiver: post.receiver, caption: post.caption, songId: post.songId, date: post.date, isAnonymous: post.isAnonymous, isActive: post.isActive)
        CloudKitUtility.add(item: newPost) { _ in
            completionHandler()
        }
    }
    
    func sortPostsByDate() {
        DispatchQueue.main.async {
            self.posts.sort {$0.date > $1.date}
        }
    }
}

