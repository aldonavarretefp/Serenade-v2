//
//  Song.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 22/02/24.
//

import Foundation
import SwiftUI

struct SongModel: Identifiable {
    var id: String
    var title: String
    var artist: String
    var album: String
    var coverArt: String
    var color: Color = .red
    var fontColor: Color = .red
}

