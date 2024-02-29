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
    var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    func bringAllPosts(){
        
    }
    
    func bringAllPostFromUserID(id: CKRecord.Reference){
        
    }
    
    
    func createAPost(post: Post){
        
    }
    
    
}

