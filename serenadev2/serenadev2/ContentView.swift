//
//  ContentView.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - Properties
    @State var selectedTab: Tabs = .feed
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0){
            
            // Switch to change between the tab that is selected
            switch selectedTab {
                
            // Show the feed view
            case .feed:
                FeedView()
                
            // Show the search view
            case .search:
                SearchView()
            
            // Show the profile view
            case .profile:
                SongDetailView(audioURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/38/be/54/38be54d8-7411-fe31-e15f-c85e7d8515e8/mzaf_15200620892322734212.plus.aac.p.m4a")!, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0x202020), fontColor: Color(hex: 0xffffff)))
            }
            
            // MARK: - Custom tab bar
            CustomTabBar(selectedTab: $selectedTab)
                .zIndex(-1)
        }
    }
}

#Preview {
    ContentView()
}
