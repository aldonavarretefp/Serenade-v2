//
//  SongService.swift
//  serenadev2
//
//  Created by Aldo Yael Navarrete Zamora on 13/12/23.
//

import Foundation
import CloudKit

class SongService {
    
    static let database = CKContainer(identifier: Config.containerIdentifier).publicCloudDatabase

    static func saveSong(song: Song, completion: @escaping (Result<Song, Error>) -> Void) {
        let record = CKRecord(recordType: "Song")
        record["id"] = song.id as CKRecordValue
        record["title"] = song.title as CKRecordValue
        record["artist"] = song.artist as CKRecordValue
        let database = CKContainer.default().publicCloudDatabase
        database.save(record) { (savedRecord, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let savedRecord = savedRecord else {
                completion(.failure(NSError(domain: "CloudKitSaveError", code: 0, userInfo: nil)))
                return
            }
            let savedSong = Song(id: savedRecord["id"] ?? "", title: savedRecord["title"] ?? "", artist: savedRecord["artist"] ?? "", album: savedRecord["album"] ?? "", coverArt: savedRecord["coverArt"] ?? "")
            completion(.success(savedSong))
        }
    }
    
}
