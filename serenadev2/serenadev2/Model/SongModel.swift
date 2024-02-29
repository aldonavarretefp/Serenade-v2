//
//  SongModel.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 28/02/24.
//

import Foundation
import SwiftUI

struct SongModel: Identifiable, Hashable {
    var id: String
    let title: String
    let artists: String
    let artworkUrlSmall: URL?
    let artworkUrlLarge: URL?
    let bgColor: CGColor?
    let priColor: CGColor?
    let secColor: CGColor?
    let terColor: CGColor?
    let quaColor: CGColor?
    let previewUrl: URL?
    let albumTitle: String?
    let duration: TimeInterval?
    let composerName: String?
    let genreNames: [String]
    let releaseDate: Date?
}
