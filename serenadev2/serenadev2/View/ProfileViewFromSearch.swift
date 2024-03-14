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
    @State var friends : [User] = []
    
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
                ProfileBar(isFriendRequestSent: false, isCurrentUser: false, isFriend: isFriend, friends: $friends, user: user)
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
                                    PostComponent(post: post, sender: senderUser, song: song)
                                }
                                else {
                                    PostComponent(post: post)
                                }
                            }
                        }
                    }
                    .padding()
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
        .navigationBarTitleDisplayMode(.inline)
        .onAppear{
            
        }
        .task {
            let user = self.user
            if let posts = await postVM.fetchAllPostsFromUserIDAsync(id: user.record.recordID) {
                
                    postVM.posts = posts
                
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
            
            friends = await userVM.fetchFriendsForUser(user: user)
            print("THIS ARE THE FRIENDS FROM THE SEARCH \(user.name)")
            print("THIS ARE THE FRIENDS ")
            print(friends.count)
            for friend in friends{
                print(friend.tagName)
            }
            
        }
    }
}
