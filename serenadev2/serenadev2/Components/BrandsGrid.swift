//
//  BrandsGrid.swift
//  serenadev2
//
//  Created by Pedro Daniel Rouin Salazar on 22/02/24.
//

import SwiftUI

// Extension to chunk an array into subarrays of a specified size
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

// View struct to display a grid of brand buttons
struct BrandsGrid: View {
    
    // Array of button types to display
    var buttonTypes: [ButtonType]
    var songTitle: String
    var songArtist: String
    var songId: String
    
    var body: some View {
        // Chunk the buttonTypes array into subarrays of up to 3 elements
        let chunks = buttonTypes.chunked(into: 3)
        
        // Main grid view to display the buttons
        Grid(horizontalSpacing: 20, verticalSpacing: 20) {
            // Iterate over each chunk of buttonTypes
            ForEach(Array(chunks.enumerated()), id: \.offset) { _, chunk in
                // Grid row to contain the buttons in the current chunk
                GridRow {
                    // Iterate over each button type in the current chunk
                    ForEach(chunk, id: \.self) { buttonType in
                        // Get the configuration for the current button type
                        let config = buttonType.configuration(songTitle: self.songTitle, songArtist: self.songArtist, songId: self.songId)
                        // Create and display the brand button with the configuration properties
                        BrandButton(label: config.label, brandLogo: config.brandLogo, fontColor: config.fontColor, startColor: config.startColor, endColor: config.endColor, action: config.action)
                            .frame(maxWidth: .infinity) // Ensure the buttons are evenly spaced
                    }
                }
                // Set the maximum height for each row based on the screen height
                .frame(minHeight: UIScreen.screenHeight / 8, maxHeight: UIScreen.screenHeight / 7)
            }
        }
    }
}

#Preview {
    BrandsGrid(buttonTypes: [.appleMusic, .spotify, .youtubeMusic], songTitle: "Runaway", songArtist: "Ye", songId: "")
}
