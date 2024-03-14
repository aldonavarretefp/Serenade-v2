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
    @State var user : User? = nil
    
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

                self.user = user
                
                userViewModel.friends = await userViewModel.fetchFriendsForUser(user: user)
                print("USER HAS THIS NUMBER OF FRIENDS")
                print(userViewModel.friends.count)
                
                //                userViewModel.fetchUserFromAccountID(accountID: "000758.2f1d6dd1cd4e4563a99a6ad78f20cde3.0946") { returnedUser in
                //                    guard let user = returnedUser else {
                //                        print("No user returned")
                //                        return
                //                    }
                //                    self.user = returnedUser
                //                }

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
