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
//            userViewModel.fetchUserFromAccountID(accountID: CKRecord.ID(recordName: "_4be12f743d4fce557a754ffe697f5908")) { returnedUser in
//                if let user = returnedUser {
//                    print(user)
//                } else {
//                    print("Error")
//                }
//            }
            userViewModel.searchUsers(tagname: "sebatoo") { friends in
                if let friendss = friends {
                    print(friendss)
                } else {
                    print("Error")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
