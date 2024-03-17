//
//  FeedNavbar.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 17/03/24.
//

import SwiftUI

struct FeedNavbar: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var postViewModel: PostViewModel
    @StateObject private var friendRequestsVM: FriendRequestsViewModel = FriendRequestsViewModel()
    
    var body: some View {
        // Header
        VStack(spacing: 0) {
            HStack{
                
                // Navigation title
                Text(LocalizedStringKey("Feed"))
                    .font(.title)
                    .bold()
                
                Spacer()
                
                // Navigation link to open notifications view
                NavigationLink(destination: NotificationsView()
                    .toolbarRole(.editor)){
                        if friendRequestsVM.friendRequests.count == 0 {
                            Image(systemName: "bell")
                                .fontWeight(.semibold)
                                .font(.title2)
                        }
                        else {
                            Image(systemName: "bell.badge")
                                .fontWeight(.semibold)
                                .font(.title2)
                                .foregroundStyle(.red, .primary)
                                .symbolRenderingMode(.palette)
                        }
                    }
                    .foregroundStyle(.primary)
            }
            .padding(.bottom, 10)
            .padding([.horizontal, .top])
            
            Divider()
                .padding(.horizontal, -15)
            
            // If the daily post has already been made, show the user's post
            if let dailySong = postViewModel.dailySong {
                DailyPosted(song: dailySong)
                
                Divider()
                    .padding(.horizontal, -15)
            }
        }
    }
}

#Preview {
    FeedNavbar()
}
