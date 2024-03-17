//
//  OpenWithViewModel.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import Foundation

final class OpenWithViewModel: ObservableObject{
    
    // MARK: - Properties
    @Published var firstTimeEntering: Bool
    
    // Property to receive an array of ButtonType
    // which specifies the different types of buttons that can be displayed in the BrandsGrid
    var buttonTypes: [ButtonType]
    var songTitle : String
    var songArtist: String
    var songId: String
    var filteredButtons: [ButtonType]
    
    init(buttonTypes: [ButtonType], songTitle: String, songArtist: String, songId: String) {
        self.buttonTypes = buttonTypes
        self.songTitle = songTitle
        self.songArtist = songArtist
        self.songId = songId
        
        self.filteredButtons = buttonTypes.filter {
            if $0 == .appleMusic {
                return UserDefaults.standard.bool(forKey: "selectedAppleMusic")
            } else if $0 == .spotify {
                return UserDefaults.standard.bool(forKey: "selectedSpotify")
            } else if $0 == .youtubeMusic {
                return UserDefaults.standard.bool(forKey: "selectedYouTubeMusic")
            } else {
                // If none of the above conditions are met, return false (or true depending on what you need)
                return false
            }
        }
        
        // Initialization of the selection state with the value stored in UserDefaults
        self.firstTimeEntering = UserDefaults.standard.bool(forKey: "firstTimeEntering")
    }
}
