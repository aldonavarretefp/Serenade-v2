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
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        
        TabView {
            Group{
                FeedView()
                    .tabItem {
                        Image("feed.fill")
                        Text("Feed")
                    }
                SearchView()
                    .tabItem {
                        Label("Search", systemImage: "magnifyingglass")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(colorScheme == .light ? .white : .black, for: .tabBar)
            
        }
        
//        VStack(spacing: 0){
//            // Switch to change between the tab that is selected
//            switch selectedTab {
//
//            // Show the feed view
//            case .feed:
//                FeedView()
//
//            // Show the search view
//            case .search:
//                SearchView()
//
//            // Show the profile view
//            case .profile:
//                ProfileView()
//            }
//
//            // MARK: - Custom tab bar
//            CustomTabBar(selectedTab: $selectedTab)
//                .zIndex(-1)
//        }
    }
}

#Preview {
    ContentView()
}
