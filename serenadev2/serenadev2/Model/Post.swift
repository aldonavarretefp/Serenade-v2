//
//  Post.swift
//  Serenade
//
//  Created by Alejandro Oliva Ochoa on 08/12/23.
//

import Foundation

enum TypeRec: String, CaseIterable, Decodable {
    case daily, serenade, recommendation
    var id: String {
        return self.rawValue
    }
}

// MARK: - Post model
struct Post: Identifiable, Decodable, Equatable, Hashable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.date < rhs.date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)        
    }
    
    var id: String
    var type: TypeRec
    var sender: String
    var receiver: String
    var caption: String?
    var songId: String
    var date: Date
    var isAnonymous: Bool
    var isDeleted: Bool
    var senderUser: User?
    var receiverUser: User?
    var song: Song?
}
