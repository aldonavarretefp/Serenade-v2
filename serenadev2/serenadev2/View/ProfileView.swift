//
//  ProfileView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 22/02/24.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userVM: UserViewModel
    @StateObject private var postVM = PostViewModel()
    @StateObject private var headerViewModel = HeaderViewModel()
    @StateObject private var loadingStateViewModel = LoadingStateViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            // Background of the view
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Scroll to show all the posts of the user
                    ScrollView (.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 15) {
                            if postVM.posts.isEmpty {
                                ContentUnavailableView(label: {
                                    Label(LocalizedStringKey("No posts"), systemImage: "music.note")
                                }, description: {
                                    Text(LocalizedStringKey("Try posting your first one!"))
                                })
                            } else {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .offset(y: -50)
                                ForEach(postVM.posts, id: \.self) { post in
                                    // Ensure PostView can handle nil or incomplete data gracefully
                                    if let sender = post.sender, let senderUser = postVM.senderDetails[sender.recordID], let song = postVM.songsDetails[post.songId] {
                                        // When the sender is loaded show the post component
                                        PostComponentInProfile(post: post, sender: senderUser, song: song)
                                    }
                                    else {
                                        // While the sender loads show the post component with a shimmer effect
                                        // This shimmer effect occurs when no sender is passed to the post component
                                        PostComponentInProfile(post: post)
                                    }
                                }
                            }
                        }
                        .padding(.top, headerViewModel.headerHeight)
                        .padding([.bottom,.horizontal])
                        .offset(y: -20)
                        .offsetY{ previous, current in
                            // Moving header based on direction scroll
                            if previous > current{
                                // MARK: - Up
                                if headerViewModel.direction != .up && current < 0{
                                    headerViewModel.shiftOffset = current - headerViewModel.headerOffset
                                    headerViewModel.direction = .up
                                    headerViewModel.lastHeaderOffset = headerViewModel.headerOffset
                                }
                                
                                let offset = current < 0 ? (current - headerViewModel.shiftOffset) : 0
                                
                                // Checking if it does not goes over header height
                                headerViewModel.headerOffset = (-offset < headerViewModel.headerHeight ? (offset < 0 ? offset : 0) : -headerViewModel.headerHeight)
                                
                                // get the normalized offset so it is always between 0 and 1
                                let normalizedOffset = 100
                                
                                // Calculate the opaciti for the header and the button
                                headerViewModel.headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
                                
                            } else {
                                // MARK: - Down
                                if headerViewModel.direction != .down{
                                    headerViewModel.shiftOffset = current
                                    headerViewModel.direction = .down
                                    headerViewModel.lastHeaderOffset = headerViewModel.headerOffset
                                }
                                
                                let offset = headerViewModel.lastHeaderOffset + (current - headerViewModel.shiftOffset)
                                headerViewModel.headerOffset = (offset > 0 ? 0 : offset)
                                
                                // get the normalized offset so it is always between 0 and 1
                                let normalizedOffset = 100
                                
                                // Calculate the opaciti for the header and the button
                                headerViewModel.headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
                            }
                        }
                    }
                    .coordinateSpace(name: "SCROLL")
                    .overlay(alignment: .top) {
                        ProfileBar(friends: $profileViewModel.friendsFromUser, user: $profileViewModel.user, isFriend: $profileViewModel.isFriend, isFriendRequestSent: $profileViewModel.isFriendRequestSent, isFriendRequestRecieved: $profileViewModel.isFriendRequestReceived, showFriendRequestButton: $profileViewModel.showFriendRequestButton, isLoading: $loadingStateViewModel.isLoading, isLoadingStateOfFriendship: .constant(false), isCurrentUser: true)
                            .opacity(headerViewModel.headerOpacity)
                            .padding(.top, safeArea().top)
                            .padding(.bottom)
                            .anchorPreference(key: HeaderBoundsKey.self, value: .bounds){ $0 }
                        // Get the header height
                            .overlayPreferenceValue(HeaderBoundsKey.self) { value in
                                GeometryReader { proxy in
                                    if let anchor = value {
                                        Color.clear
                                            .onAppear(){
                                                // MARK: - Retreiving rect using proxy
                                                headerViewModel.headerHeight = proxy[anchor].height
                                            }
                                    }
                                }
                            }
                            .offset(y: -headerViewModel.headerOffset < headerViewModel.headerHeight ? headerViewModel.headerOffset : (headerViewModel.headerOffset < 0 ? headerViewModel.headerOffset : 0))
                        
                    }
                    .ignoresSafeArea(.all, edges: .top)
                    .refreshable {
                        await fetchProfileUserAndPosts()
                    }
                }
            }
            // This overlay is to show a bar behind the status bar
            .overlay(alignment: .top) {
                Color.clear
                    .background()
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 0)
            }
            .onAppear{
            }
            .task {
                await fetchProfileUserAndPosts()
                loadingStateViewModel.isLoading = true
                profileViewModel.friendsFromUser = await userVM.fetchFriendsForUser(user: profileViewModel.user)
                loadingStateViewModel.isLoading = false
//                for friend in friendsFromUser{
//                    print("THIS ARE THE UPDATED FRIENDS")
//                    print(friend.tagName)
//                }
            }
        }
    }
    private func fetchProfileUserAndPosts() async -> Void {
        guard let user = userVM.user else {
            print("No user in userViewModel")
            return
        }
        userVM.fetchUserFromRecord(record: user.record) { returnedUser in
            guard let updatedUser = returnedUser else {
                print("NO USER FROM DB")
                return
            }
            print("Fetched User from DB: \(updatedUser)")
            userVM.user = returnedUser
        }
        guard let user = userVM.user else {
            print("No user in userViewModel")
            return
        }
        profileViewModel.user = user
        Task{
            if let posts = await postVM.fetchAllPostsFromUserIDAsync(id: user.record.recordID) {
                postVM.posts = posts
                //                    postVM.sortPostsByDate()
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
        
    }
}
