//
//  Song.swift
//  Serenade
//
//  Created by Gustavo Sebastian Leon Cortez on 08/12/23.
//

import Foundation

struct Song: Identifiable, Decodable {
    var id: String
    var title: String
    var artist: String
    var album: String
    var coverArt: String?
}


extension Song {
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
        let title = data["title"] as? String,
        let artist = data["artists"] as? String,
        let album = data["album"] as? String,
        let coverArt = data["coverArt"] as? String else {
            return nil
        }
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.coverArt = coverArt
    }
}
