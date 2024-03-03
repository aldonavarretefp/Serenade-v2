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
        .task {
//            userViewModel.fetchUserFromAccountID(accountID: CKRecord.ID(recordName: "_4be12f743d4fce557a754ffe697f5908")) { returnedUser in
//                if let user = returnedUser {
//                    print(user)
//                } else {
//                    print("Error")
//                }
//            }
//            userViewModel.searchUsers(tagName: "sebatoo") { user in
//                if var userR = user {
//                    print(userR)
//                } else {
//                    print("Error")
//                }
//            }
            
            let post = Post(postType: TypeRec(rawValue: "daily")!, sender: userViewModel.user?.accountID, caption: "This is a test", songId: "hello", date: Date(), isAnonymous: false, isActive: true)
            postViewModel.createAPost(post: post)
            print("userViewModel.user: \(userViewModel.user)")
            print("userViewModel.user?.accountID: \(userViewModel.user?.accountID)")
            
            postViewModel.bringAllPostFromUserID(id: CKRecord(recordID: CKRecord.ID(recordName: "_798464902c8d85f4c1b288fe738f5cb5"))) { returnedPosts in
                    print(returnedPosts)
            }

        }
    }
}

#Preview {
    ContentView()
}
