//
//  ContentView.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 19/02/24.
//

import SwiftUI
import CloudKit

struct ContentView: View {
    
    // MARK: - Properties
    @State var selectedTab: Tabs = .feed
    @EnvironmentObject var userViewModel: UserViewModel
    
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
        .task {
            userViewModel.createUser(user: User(name: "diego", tagName: "x", email: "diego@gmail.com", friends: nil, posts: nil, streak: 100, profilePicture: "", isActive: true))
            //print(userViewModel.users)
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
