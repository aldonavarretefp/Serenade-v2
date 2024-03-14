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
    @EnvironmentObject var postViewModel: PostViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        
        TabView {
            Group{
                FeedView()
                    .tabItem {
                        Image("feed.fill")
                        Text(LocalizedStringKey("Feed"))
                    }
                SearchView()
                    .tabItem {
                        Label(LocalizedStringKey("Search"), systemImage: "magnifyingglass")
                    }
                ProfileView()
                    .tabItem {
                        Label(LocalizedStringKey("Profile"), systemImage: "person.fill")
                    }
            }
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(colorScheme == .light ? .white : .black, for: .tabBar)
            .task {
                guard var user = userViewModel.user else {
                    print("NO USER FROM PROFILE")
                    return
                }
                await postViewModel.fetchAllPostsAsync(user: user)
                await postViewModel.verifyDailyPostForUser(user: user)
                await postViewModel.verifyPostFromYesterdayForUser(user: user)
                if postViewModel.hasPostedYesterday == false && postViewModel.isDailyPosted == false {
                    user.streak = 0
                    userViewModel.updateUser(updatedUser: user)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
