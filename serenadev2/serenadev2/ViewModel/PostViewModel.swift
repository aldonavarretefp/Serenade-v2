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
    @Published var postID: CKRecord.ID?
    @Published var error: String = ""
    var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func bringAllPosts(){
        
    }
    
    func bringAllPostFromUserID(id: CKRecord.Reference, completion: @escaping ([Post]?) -> Void){
        let predicate = NSPredicate(format: "sender == %@", id)
        let recordType = UserRecordKeys.type.rawValue
        
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { returnedPosts in
                let posts: [Post]? = returnedPosts
                guard let postss = posts else {
                    completion(nil)
                    return
                }
                completion(postss)
            }
            .store(in: &cancellables)
    }
    
    
    func createAPost(post: Post){
        let newPost = Post(postType: post.postType, sender: post.sender, receiver: post.receiver, caption: post.caption, songId: post.songId, date: post.date, isAnonymous: post.isAnonymous, isActive: post.isActive)
        CloudKitUtility.add(item: newPost) { _ in }
    }
    
    
}

