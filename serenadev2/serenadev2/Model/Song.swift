//
//  Song.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 22/02/24.
//

import Foundation
import SwiftUI

struct Song: Identifiable {
    var id: String
    var title: String
    var artist: String
    var album: String
    var coverArt: String
    var color: Color = .red
    var fontColor: Color = .red
}


extension Song {
    init?(data: [String: Any]) {
        guard let id = data["id"] as? String,
        let title = data["title"] as? String,
        let artist = data["artists"] as? String,
        let album = data["album"] as? String,
        let coverArt = data["coverArt"] as? String,
        let color = data["color"] as? Color,
        let fontColor = data["fontColor"] as? Color else {
            return nil
        }
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.coverArt = coverArt
        self.color = color
        self.fontColor = fontColor
    }
}
