//
//  ProfileViewFromSearch.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 07/03/24.
//

import SwiftUI
import CloudKit


struct ProfileViewFromSearch: View {
    
    // MARK: - ViewModel
    @EnvironmentObject var userVM: UserViewModel
    @StateObject var postVM: PostViewModel = PostViewModel()
    @StateObject var friendRequestsVM: FriendRequestsViewModel = FriendRequestsViewModel()
    @StateObject private var loadingStateViewModel = LoadingStateViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    // MARK: - Properties
    // Received user as parameter
    @State var user: User
    @State var friends: [User] = []
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.viewBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0){
                
                //  PENDING: Check friend requests sent for isFriendRequestSent
                if let userInSession = userVM.user {
                    ProfileBar(friends: $friends, user: $user, isFriend: $profileViewModel.isFriend, isFriendRequestSent: $profileViewModel.isFriendRequestSent, isFriendRequestRecieved: $profileViewModel.isFriendRequestReceived, showFriendRequestButton: $profileViewModel.showFriendRequestButton, isLoading: $loadingStateViewModel.isLoading, isLoadingStateOfFriendship: $loadingStateViewModel.isLoadingStateOfFriendShip, isCurrentUser: userVM.isSameUserInSession(fromUser: userInSession, toCompareWith: self.user))
                }

                // Scroll view to show all the posts
                ScrollView (.vertical, showsIndicators: false) {
                    LazyVStack(spacing: 15) {
                        if postVM.posts.isEmpty { // If no posts show a message
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
            loadingStateViewModel.isLoading = true
            loadingStateViewModel.isLoadingStateOfFriendShip = true
            fetchUserAndFriendRequest()
            await fetchProfilePosts()
            
            friends = await userVM.fetchFriendsForUser(user: user)
            loadingStateViewModel.isLoading = false
            
        }
    }
    
    // MARK: - Functions to load properly the posts
    private func fetchUserAndFriendRequest() {
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
            profileViewModel.isFriend = userVM.isFriend(of: user)
            print(String("isFriend: \(profileViewModel.isFriend)"))
        }
        guard let mainUser = userVM.user else {
            print("No user from userViewModel")
            return
        }
        
        friendRequestsVM.fetchFriendRequest(from: user, for: mainUser) { incomingFriendRequest in
            guard incomingFriendRequest.first != nil else {
                profileViewModel.isFriendRequestReceived = false
                friendRequestsVM.fetchFriendRequest(from: mainUser, for: user) { outgoingFriendRequest in
                    guard outgoingFriendRequest.first != nil else {
                        profileViewModel.isFriendRequestSent = false
                        return
                    }
                    profileViewModel.isFriendRequestSent = true
                }
                profileViewModel.showFriendRequestButton = true
                loadingStateViewModel.isLoadingStateOfFriendShip = false
                return
            }
            profileViewModel.isFriendRequestReceived = true
            profileViewModel.showFriendRequestButton = true
            loadingStateViewModel.isLoadingStateOfFriendShip = false
        }
    }
    
    private func fetchProfilePosts() async {
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
