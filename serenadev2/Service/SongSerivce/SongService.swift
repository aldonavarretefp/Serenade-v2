//
//  SongService.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 28/02/24.
//

import Foundation
import MusicKit

/// A service class responsible for fetching songs from the MusicKit API.
class SongService {
    /// Fetches a single song by its identifier from the MusicKit API.
    /// - Parameter id: The identifier of the song to fetch.
    /// - Returns: A `SongModel` instance representing the fetched song.
    /// - Throws: An error if the fetch operation fails.
    class func fetchSongById(_ id: String) async throws -> SongModel {
        let status = await MusicAuthorization.request()
        switch status {
        case .authorized:
            let request = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: MusicItemID(rawValue: id))
            let response = try await request.response()
            guard let song = response.items.first else {
                throw NSError(domain: "SongService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Song not found."])
            }
            return SongModel(
                id: song.id.rawValue,
                title: song.title,
                artists: song.artistName,
                artworkUrlSmall: song.artwork?.url(width: 75, height: 75),
                artworkUrlLarge: song.artwork?.url(width: 500, height: 500),
                bgColor: song.artwork?.backgroundColor,
                priColor: song.artwork?.primaryTextColor,
                secColor: song.artwork?.secondaryTextColor,
                terColor: song.artwork?.tertiaryTextColor,
                quaColor: song.artwork?.quaternaryTextColor,
                previewUrl: song.previewAssets?.first?.url,
                duration: song.duration,
                composerName: song.composerName,
                genreNames: song.genreNames,
                releaseDate: song.releaseDate
            )
        default:
            throw NSError(domain: "SongService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Not authorized to access MusicKit"])
        }
    }
}

