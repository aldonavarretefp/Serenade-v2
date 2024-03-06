//
//  SongHistoryManager.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 04/03/24.
//

import Foundation
import SwiftUI
import MusicKit

class SongHistoryManager: ObservableObject {
    static let shared = SongHistoryManager()
    
    private var history: [String] = UserDefaults.standard.stringArray(forKey: "SongHistory") ?? []
    @Published var song: SongModel?
    @Published var error: Error?
    
    func addToHistory(_ receivedId: String) {
        // If the song is in the history, remove it
        if let index = history.firstIndex(where: { $0 == receivedId }) {
            history.remove(at: index)
        }
        
        // Add the song at the top of the array
        history.insert(receivedId, at: 0)
        
        // Limit the search history
        if history.count > 25 {
            history.removeLast()
        }
        
        // Save the updated history to UserDefaults
        UserDefaults.standard.set(history, forKey: "SongHistory")
    }
    
    func fetchSong(id: String) async -> Result<SongModel, Error> {
        do {
            let fetchedSong = try await SongService.fetchSongById(id)
            return .success(fetchedSong)
        } catch {
            return .failure(error)
        }
    }
    
    func getHistory() async -> [SongModel] {
        var songs: [SongModel] = []
        
        for historyId in history {
            let result = await fetchSong(id: historyId)
            switch result {
            case .success(let song):
                songs.append(song)
            case .failure(let error):
                print("Error fetching song with ID \(historyId): \(error)")
            }
        }
        
        return songs
    }
    
    // Removed the song when tapped
    func removeSong(songId: String?) {
        if let index = history.firstIndex(where: { $0 == songId }) {
            history.remove(at: index)
            
            // Save the updated history to UserDefaults
            UserDefaults.standard.set(history, forKey: "SongHistory")
        }
    }
}
