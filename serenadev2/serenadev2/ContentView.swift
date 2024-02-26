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
        
        TabView {
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
