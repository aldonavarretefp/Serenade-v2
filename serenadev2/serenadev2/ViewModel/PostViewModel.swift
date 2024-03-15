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

enum PostViewModelError: String, Error {
    case fetchedMoreThanOnePostWithSameID = "Didn't fetch post"
}


class PostViewModel: ObservableObject {
    @Published var senderDetails: [CKRecord.ID: User] = [:]
    @Published var songsDetails: [String: SongModel] = [:]
    @Published var posts: [Post] = []
    @Published var dailyPost: Post?
    @Published var dailySong: SongModel? = nil
    @Published var isDailyPosted: Bool = true
    @Published var hasPostedYesterday: Bool = true
    @Published var streak: Int = 0
    
    private var fetchCursor: CKQueryOperation.Cursor?
    private var isFetching: Bool = false
    private var hasMorePosts: Bool = true
    
    var cancellables = Set<AnyCancellable>()
    
    func fetchSenderDetails(for recordID: CKRecord.ID) {
        // Use CloudKit to fetch the CKRecord for the given recordID
        // Then initialize a User object with the fetched CKRecord and store it in `userDetails`
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { [weak self] record, error in
            guard let self = self else { return }
            guard let record = record, error == nil else {
                print("Error fetching user details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let user = User(record: record) {
                DispatchQueue.main.async {
                    self.senderDetails[recordID] = user
                }
            }
        }
    }
    
    
    //MARK: AsyncFunc
    func fetchSenderDetailsAsync(for recordID: CKRecord.ID) async {
        do {
            let predicate = NSPredicate(format: "recordID == %@", recordID)
            let users: [User] = try await CloudKitUtility.fetch(predicate: predicate, recordType: UserRecordKeys.type.rawValue)
            if users.count > 0 {
                let user = users[0]
                DispatchQueue.main.async {
                    self.senderDetails[recordID] = user
                }
            }
        } catch {
            print("Error fetching user details: \(error.localizedDescription)")
        }
    }
    
    func fetchAllPostsFromUserIDAsync(id: CKRecord.ID, customPredicate: NSPredicate? = nil) async -> [Post]? {
        let recordToMatch = CKRecord.Reference(recordID: id, action: .none)
        
        var predicate: NSPredicate
        if let customPredicate {
            predicate = customPredicate
        } else {
            predicate = NSPredicate(format: "sender == %@ && isActive == 1", recordToMatch)
        }
        
        let recordType = PostRecordKeys.type.rawValue
        let sortDescriptions: [NSSortDescriptor] = [.init(key: "date", ascending: false)]
        
        do {
            let posts: [Post] = try await CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptions: sortDescriptions)
            return posts
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
            return nil
        }
    }
    
    func fetchAllPostsAsync(user: User) async {
        let userID: CKRecord.Reference = CKRecord.Reference(recordID: user.record.recordID, action: .none)
        if user.friends.count == 0 {
            // Now call an async version of `fetchAllPostsFromUserID`
            let calendar = Calendar.current
            let now = Date()
            let startOfDay = calendar.startOfDay(for: now)
            
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) else {
                return
            }
            let recordToMatch = CKRecord.Reference(recordID: user.record.recordID, action: .none)
            let predicate = NSPredicate(format: "sender == %@ && date >= %@ && date < %@ && isActive == 1", recordToMatch, startOfDay as NSDate, endOfDay as NSDate)
            
            if let posts = await fetchAllPostsFromUserIDAsync(id: user.record.recordID, customPredicate: predicate) {
                await MainActor.run {
                    self.posts = posts
                }
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
            
            let calendar = Calendar.current
            let now = Date()
            let startOfDay = calendar.startOfDay(for: now)
            
            guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) else {
                return
            }
            
            let predicate = NSPredicate(format: "sender IN %@ && date >= %@ && date < %@ && isActive == 1", userList, startOfDay as NSDate, endOfDay as NSDate)
            let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]
            let recordType = PostRecordKeys.type.rawValue
            
            do {
                let posts: [Post] = try await CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptions: sortDescriptors)
                
                DispatchQueue.main.async {
                    self.posts = posts
                }
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
    
    func fetchPost(byRecordID recordID: CKRecord.ID) async -> Post? {
        let predicate = NSPredicate(format: "recordID == %@", recordID)
        let recordType = PostRecordKeys.type.rawValue
        do {
            let posts: [Post] = try await CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            if posts.count >= 2 {
                print("Fetched more than one post with the same ID")
                throw PostViewModelError.fetchedMoreThanOnePostWithSameID
            }
            if posts.count == 1 {
                return posts[0]
            }
            return nil
        } catch {
            print("Error fetching posts: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func hasPostFromDate(date: Date, user: User) async -> (Bool, Post?) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) else {
            return (false, nil)
        }
        
        guard let userPosts = await fetchAllPostsFromUserIDAsync(id: user.record.recordID), let newestPost = userPosts.first else {
            return (false, nil)
        }
        // Check if the newest post (first in the sorted array) is within the target date range
        let newestPostLiesOnTimeFrame: Bool = newestPost.date >= startOfDay && newestPost.date <= endOfDay
        if newestPostLiesOnTimeFrame {
            return (true, newestPost)
        }
        return (false, nil)
    }
    
    func verifyDailyPostForUser(user: User) async -> Void {
        let today: Date = .now
        let (hasPostedToday, newestPost) = await self.hasPostFromDate(date: today, user: user)
        if hasPostedToday {
            self.isDailyPosted = true
            do {
                if let newestPost {
                    let song: SongModel = try await SongService.fetchSongById(newestPost.songId)
                    await MainActor.run {
                        self.dailySong = song
                    }
                }
            } catch let error {
                print("ERROR: hasPostFromDate \(error.localizedDescription)")
            }
        } else {
            self.isDailyPosted = false
        }
    }
    
    func verifyPostFromYesterdayForUser(user: User) async -> Void {
        guard let yesterday: Date = Calendar.current.date(byAdding: .day, value: -1, to: .now) else {
            print("Couldn't create yesterday date")
            return
        }
        let (hasPostedYesterday, _) = await self.hasPostFromDate(date: yesterday, user: user)
        if hasPostedYesterday {
            self.hasPostedYesterday = true
        } else {
            self.hasPostedYesterday = false
        }
    }
    
}


extension PostViewModel {
    
    func fetchPostsPaginated() {
        guard !isFetching && hasMorePosts else { return }
        isFetching = true
        
        Task {
            do {
                let (newPosts, newCursor): ([Post], CKQueryOperation.Cursor?) = try await CloudKitUtility.fetch(
                    predicate: NSPredicate(value: true), // Example predicate, adjust as needed
                    recordType: "Post",
                    resultsLimit: 10, // Adjust based on your desired page size
                    cursor: fetchCursor)
                for post in newPosts {
                    guard let sender = post.sender else { return }
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
                DispatchQueue.main.async {
                    self.posts.append(contentsOf: newPosts)
                    self.fetchCursor = newCursor
                    // If no new cursor is returned, it means there are no more posts to fetch.
                    self.hasMorePosts = newCursor != nil
                    self.isFetching = false
                }
            } catch {
                print("An error occurred: \(error)")
                DispatchQueue.main.async {
                    self.isFetching = false
                    // Handle error, e.g., by showing an alert to the user
                }
            }
        }
    }
}


extension PostViewModel {
    func fetchMorePostsIfNeeded(currentPost post: Post) {
        guard let lastPost = posts.last, lastPost == post, hasMorePosts else { return }
        self.fetchPostsPaginated()
    }
}


