//
//  ProfileViewFromSearch.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 07/03/24.
//

import SwiftUI
import CloudKit

struct ProfileViewFromSearch: View {
    
    @EnvironmentObject var postVM: PostViewModel
    @EnvironmentObject var userVM: UserViewModel
    
    @State var posts: [Post] = []
    @State var user: User
    
    func isFriendCheck(user: User) -> Bool {
        if userVM.user!.friends.contains(where: { $0 == user.record.recordID }) {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.viewBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                let isFriend = userVM.isFriend(of: user)
                //  PENDING: Check friend requests sent for isFriendRequestSent
                ProfileBar(isFriendRequestSent: false, isCurrentUser: false, isFriend: isFriend, user: user)
                
                ScrollView (.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        if postVM.posts.isEmpty {
                            ContentUnavailableView(label: {
                                Label(LocalizedStringKey("No posts"), systemImage: "music.note")
                            }, description: {
                                Text(LocalizedStringKey("Try posting your first one!"))
                            })
                        } else {
                            ForEach(postVM.posts, id: \.self) { post in
                                // Ensure PostView can handle nil or incomplete data gracefully
                                if let sender = post.sender, let senderUser = postVM.senderDetails[sender.recordID], let song = postVM.songsDetails[post.songId] {
                                    PostView(post: post, sender: senderUser, song: song)
                                }
                                else {
                                    PostView(post: post)
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                    .padding(.horizontal)
                }
                .ignoresSafeArea(.all, edges: .top)
//                .ignoresSafeArea(.all)
                .refreshable {
                    let user = self.user
                    if let posts = await postVM.fetchAllPostsFromUserIDAsync(id: user.record.recordID) {
                        postVM.posts = posts
                        postVM.sortPostsByDate()
                        for post in posts {
                            print("Post: ", post.songId)
                            guard let sender = post.sender else {
                                print("Post has no sender")
                                return
                            }
                            // Make sure `fetchSenderDetails` is also async if it performs asynchronous operations
                            await postVM.fetchSenderDetailsAsync(for: sender.recordID)
                            let result = await SongHistoryManager.shared.fetchSong(id: post.songId)
                            switch result {
                            case .success(let songModel):
                                postVM.songsDetails[post.songId] = songModel
                            default:
                                print("ERROR: Couldn't bring song details")
                                break;
                            }
                        }
                    }
                }
            }
        }
        // This overlay is to show a bar behind the status bar
        //            .overlay(alignment: .top) {
        //                Color.clear
        //                    .background()
        //                    .ignoresSafeArea(edges: .top)
        //                    .frame(height: 0)
        //            }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            let user = self.user
            if let posts = await postVM.fetchAllPostsFromUserIDAsync(id: user.record.recordID) {
                postVM.posts = posts
                postVM.sortPostsByDate()
                for post in posts {
                    print("Post: ", post.songId)
                    guard let sender = post.sender else {
                        print("Post has no sender")
                        return
                    }
                    // Make sure `fetchSenderDetails` is also async if it performs asynchronous operations
                    await postVM.fetchSenderDetailsAsync(for: sender.recordID)
                    let result = await SongHistoryManager.shared.fetchSong(id: post.songId)
                    switch result {
                    case .success(let songModel):
                        postVM.songsDetails[post.songId] = songModel
                    default:
                        print("ERROR: Couldn't bring song details")
                        break;
                    }
                }
            }
        }
    }
}
