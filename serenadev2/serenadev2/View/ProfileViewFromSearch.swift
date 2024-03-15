//
//  ProfileViewFromSearch.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 07/03/24.
//

import SwiftUI
import CloudKit


struct ProfileViewFromSearch: View {
    
    @StateObject var postVM: PostViewModel = PostViewModel()
    @StateObject var friendRequestsVM: FriendRequestsViewModel = FriendRequestsViewModel()
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

    @State var isFriend: Bool = false
    @State var isFriendRequestSent: Bool = false
    @State var isFriendRequestReceived: Bool = false
    @State var showFriendRequestButton: Bool = false

    @State private var isLoading = false
    @State private var isLoadingStateOfFriendShip = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.viewBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                
                //  PENDING: Check friend requests sent for isFriendRequestSent

                if let user = userVM.user {
                    ProfileBar(friends: $friends, user: $user, isFriend: $isFriend, isFriendRequestSent: $isFriendRequestSent, isFriendRequestRecieved: $isFriendRequestReceived, showFriendRequestButton: $showFriendRequestButton, isLoading: $isLoading, isLoadingStateOfFriendship: $isLoadingStateOfFriendShip, isCurrentUser: isSameUserInSession(fromUser: user, toCompareWith: self.user))
                }

                ScrollView (.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        if postVM.posts.isEmpty {
                            ContentUnavailableView(label: {
                                Label(LocalizedStringKey("No posts"), systemImage: "music.note")
                            }, description: {
                                Text(LocalizedStringKey("Try posting your first one!"))
                            })
                        } else {
                            ForEach(postVM.posts, id: \.self) { post in
                                if let sender = post.sender, let senderUser = postVM.senderDetails[sender.recordID], let song = postVM.songsDetails[post.songId] {
                                    PostComponentInProfile(post: post, sender: senderUser, song: song)
                                }
                                else {
                                    PostComponentInProfile(post: post)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .ignoresSafeArea(.all, edges: .top)
                .refreshable {
                    fetchUserAndFriendRequest()
                    await fetchProfilePosts()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            isLoading = true
            isLoadingStateOfFriendShip = true
            fetchUserAndFriendRequest()
            await fetchProfilePosts()
            
            friends = await userVM.fetchFriendsForUser(user: user)
            isLoading = false
            
        }
    }
    
    func isSameUserInSession(fromUser user1: User, toCompareWith user2: User) -> Bool {
        return user1.accountID == user2.accountID
    }
    
    private func fetchUserAndFriendRequest() {
//        userVM.fetchUserFromRecord(record: self.user.record) { returnedUser in
//            guard let updatedUser = returnedUser else {
//                print("NO USER FROM DB")
//                return
//            }
//            print("Fetched User from DB: \(updatedUser)")
//            self.user = updatedUser
//        }
        let user = self.user
        guard let mainUser = userVM.user else {
            print("No user from userViewModel")
            return
        }
        userVM.fetchUserFromRecord(record: mainUser.record) { returnedUser in
            guard let updatedUser = returnedUser else {
                print("NO USER FROM DB")
                return
            }
            print("Fetched User from DB: \(updatedUser)")
            userVM.user = updatedUser
            self.isFriend = userVM.isFriend(of: user)
            print(String("isFriend: \(self.isFriend)"))
        }
        guard let mainUser = userVM.user else {
            print("No user from userViewModel")
            return
        }
        
        friendRequestsVM.fetchFriendRequest(from: user, for: mainUser) { incomingFriendRequest in
            guard incomingFriendRequest.first != nil else {
                self.isFriendRequestReceived = false
                friendRequestsVM.fetchFriendRequest(from: mainUser, for: user) { outgoingFriendRequest in
                    guard outgoingFriendRequest.first != nil else {
                        self.isFriendRequestSent = false
                        return
                    }
                    self.isFriendRequestSent = true
                }
                self.showFriendRequestButton = true
                isLoadingStateOfFriendShip = false
                return
            }
            self.isFriendRequestReceived = true
            self.showFriendRequestButton = true
            isLoadingStateOfFriendShip = false
        }
    }
    
    private func fetchProfilePosts() async -> Void {
        Task {
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
        }
        
    }
}
