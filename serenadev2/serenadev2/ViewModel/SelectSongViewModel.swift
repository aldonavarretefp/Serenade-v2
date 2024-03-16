//
//  SelectSongViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 16/03/24.
//

import Foundation
import SwiftUI

class SelectSongViewModel: ObservableObject {
    @Binding var song: SongModel?
    
    init(song: Binding<SongModel?>) {
        self._song = song
    }
    
    func updateSelectedSong(from item: ContentItem) {
        guard let songDetails = item.song else {
            print("Failed to unwrap item.song")
            return
        }
        
        self.song = songDetails
    }
}
