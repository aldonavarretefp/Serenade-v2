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
    case couldNotFetchSenderDetails
}


class PostViewModel: ObservableObject {
    var posts: [Post] = []
    @Published var dailyPost: Post?
    @Published var dailySong: SongModel? = nil
    @Published var songsDetails: [String: SongModel] = [:]
    @Published var senderDetails: [String: User] = [:]
    var isDailyPosted: Bool = true
    var hasPostedYesterday: Bool = true
    var streak: Int = 0
    
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
                    self.senderDetails[recordID.recordName] = user
                }
            }
        }
    }
    
    deinit {
        self.songsDetails = [:]
        self.senderDetails = [:]
    }
    
    //MARK: AsyncFunc
    func fetchSenderDetails(for recordID: CKRecord.ID) async throws {
        if self.senderDetails[recordID.recordName] != nil {
            return
        }
        do {
            let predicate = NSPredicate(format: "recordID == %@", recordID)
            let users: [User] = try await CloudKitUtility.fetch(predicate: predicate, recordType: UserRecordKeys.type.rawValue)
            if users.count > 0 {
                let user = users.first
                DispatchQueue.main.async {
                    self.senderDetails[recordID.recordName] = user
                }
            }
        } catch {
            throw PostViewModelError.couldNotFetchSenderDetails
        }
    }
    
    func fetchAllPostsFromUserID(id: CKRecord.ID, customPredicate: NSPredicate? = nil) async {
        let recordToMatch = CKRecord.Reference(recordID: id, action: .none)
        let recordType = PostRecordKeys.type.rawValue
        var predicate: NSPredicate
        if let customPredicate {
            predicate = customPredicate
        } else {
            predicate = NSPredicate(format: "sender == %@ && isActive == 1", recordToMatch)
        }
        let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let posts: [Post] = try await CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptions: sortDescriptors)
            
            await MainActor.run {
                self.posts = posts
            }
            
            await fetchDetailsForPosts(posts)
        } catch {
            print("Error fetching posts: \(error)")
        }
    }
    
    func fetchAllPostsFromUserID2(id: CKRecord.ID, customPredicate: NSPredicate? = nil) async -> [Post] {
        let recordToMatch = CKRecord.Reference(recordID: id, action: .none)
        let recordType = PostRecordKeys.type.rawValue
        var predicate: NSPredicate
        if let customPredicate {
            predicate = customPredicate
        } else {
            predicate = NSPredicate(format: "sender == %@ && isActive == 1", recordToMatch)
        }
        let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let posts: [Post] = try await CloudKitUtility.fetch(predicate: predicate, recordType: recordType, sortDescriptions: sortDescriptors)
            
            return posts
        } catch {
            print("Error fetching posts: \(error)")
            return []
        }
    }
    
    
    private func createPredicateForPosts(user: User, userList: [CKRecord.Reference]) -> NSPredicate {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) else {
            fatalError("Error calculating end of day")
        }
        
        print(startOfDay, endOfDay)
        
        if userList.isEmpty {
            let recordToMatch = CKRecord.Reference(recordID: user.record.recordID, action: .none)
            return NSPredicate(format: "sender == %@ && date >= %@ && date < %@ && isActive == 1", recordToMatch, startOfDay as NSDate, endOfDay as NSDate)
        } else {
            return NSPredicate(format: "sender IN %@ && date >= %@ && date < %@ && isActive == 1", userList, startOfDay as NSDate, endOfDay as NSDate)
        }
    }
    
    func fetchAllPosts(user: User) async {
        var userList: [CKRecord.Reference] = user.friends
        userList.append(CKRecord.Reference(recordID: user.record.recordID, action: .none))
        
        let predicate = createPredicateForPosts(user: user, userList: userList)
        
        let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            
            let posts: [Post] = try await CloudKitUtility.fetch(predicate: predicate, recordType: PostRecordKeys.type.rawValue, sortDescriptions: sortDescriptors)
            
            await MainActor.run {
                self.posts = posts
            }
            
            await fetchDetailsForPosts(posts)
        } catch {
            print("Error fetching posts: \(error)")
        }
    }
    
    private func fetchDetailsForPosts(_ posts: [Post]) async {
        await withThrowingTaskGroup(of: Void.self) { group in
            // First, fetch sender details concurrently
            for post in posts  {
                guard let sender = post.sender else {
                    return
                }
                group.addTask {
                    try await self.fetchSenderDetails(for: sender.recordID)
                }
            }
            
            // Then, fetch song details concurrently
            for post in posts {
                group.addTask {
                    if self.songsDetails[post.songId] == nil {
                        let result = await SongHistoryManager.shared.fetchSong(id: post.songId)
                        await self.handleSongFetchResult(result, for: post.songId)
                    }
                }
            }
        }
    }
    
    private func handleSongFetchResult(_ result: Result<SongModel, Error>, for songId: String) async {
        await MainActor.run {
            switch result {
            case .success(let songModel):
                self.songsDetails[songId] = songModel
            case .failure(let error):
                print("ERROR: Couldn't fetch song details for songId \(songId): \(error)")
            }
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
    
    func createAPost(post: Post, completionHandler: @escaping (() -> Void) ) {
        guard let sender = post.sender else { return }
        let recordToMatch = CKRecord.Reference(recordID: sender.recordID, action: .none)
        let newPost = Post(postType: post.postType, sender: recordToMatch, receiver: post.receiver, caption: post.caption, songId: post.songId, date: post.date, isAnonymous: post.isAnonymous, isActive: post.isActive)
        CloudKitUtility.add(item: newPost) { result in
            switch result {
            case .success(let success):
                completionHandler()
                break;
            case .failure(let error):
                print("Couldn't add the record...", error.localizedDescription)
            }
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
        let posts = await fetchAllPostsFromUserID2(id: user.record.recordID)
        
        guard let newestPost = posts.first else {
            return (false, nil)
        }
        // Check if the newest post (first in the sorted array) is within the target date range
        let newestPostLiesOnTimeFrame: Bool = newestPost.date >= startOfDay && newestPost.date <= endOfDay
        if newestPostLiesOnTimeFrame {
            return (true, newestPost)
        }
        return (false, nil)
    }
    
    func verifyUserStreak(user: User) async -> Int {
        let today = Date.now
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)!
        
        let (hasPostedToday, newestPost) = await hasPostFromDate(date: today, user: user)
        let hasPostedYesterday = await hasPostFromDate(date: yesterday, user: user).0
    
        // Determine the new streak value
        switch (hasPostedYesterday, hasPostedToday) {
        case (false, false):
            // If no posts both today and yesterday, streak ends
            self.isDailyPosted = false
            self.hasPostedYesterday = false
            return 0
        case (true, false):
            // Posted yesterday, but not today: keep streak unchanged
            self.isDailyPosted = false
            return user.streak
        case (let hasPostedYesterday, true):
            // Posted today: get the last song to pin
            do {
                if let newestPost {
                    let song: SongModel = try await SongService.fetchSongById(newestPost.songId)
                    await MainActor.run {
                        self.dailySong = song
                        self.isDailyPosted = true
                        self.hasPostedYesterday = hasPostedYesterday
                    }
                }
            } catch let error {
                print("ERROR: hasPostFromDate \(error.localizedDescription)")
            }
            return user.streak
            
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
                    try await fetchSenderDetails(for: sender.recordID)
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
            } catch let error {
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


