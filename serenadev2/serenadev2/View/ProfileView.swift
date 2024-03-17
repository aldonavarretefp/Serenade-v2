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
    
    @StateObject private var profileViewModel: ProfileViewModel = ProfileViewModel()
    
    
    @State var user: User = User(name: "No User", tagName: "nouser", email: "", streak: 0, profilePicture: "", isActive: false, record: CKRecord(recordType: UserRecordKeys.type.rawValue))
    @State var posts: [Post] = []
    
    
    
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
                                    if let sender = post.sender, let senderUser = postVM.senderDetails[sender.recordID.recordName], let song = postVM.songsDetails[post.songId] {
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
                        .padding(.top, profileViewModel.headerHeight)
                        .padding([.bottom,.horizontal])
                        .offset(y: -20)
                        .offsetY{prev,curr in profileViewModel.adjustOffsets(previous: prev, current: curr)}
                    }
                    .coordinateSpace(name: "SCROLL")
                    .overlay(alignment: .top) {
                        if let user = userVM.user {
                            UserProfileBar(user: user)
                        }
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
            userVM.user = returnedUser
        }
        guard let user = userVM.user else {
            print("No user in userViewModel")
            return
        }
        profileViewModel.user = user
        await postVM.fetchAllPostsFromUserID(id: user.record.recordID)
    }
}

extension ProfileView {
    @ViewBuilder
    func UserProfileBar(user: User) -> some View {
        ProfileBar(friends: $profileViewModel.friendsFromUser, user: .constant(user), isFriend: $profileViewModel.isFriend, isFriendRequestSent: $profileViewModel.isFriendRequestSent, isFriendRequestRecieved: $profileViewModel.isFriendRequestReceived, showFriendRequestButton: $profileViewModel.showFriendRequestButton, isLoading: $loadingStateViewModel.isLoading, isLoadingStateOfFriendship: .constant(false), isCurrentUser: true)
            .opacity(profileViewModel.headerOpacity)
            .padding(.top, safeArea().top)
            .padding(.bottom)
            .anchorPreference(key: HeaderBoundsKey.self, value: .bounds){ $0 }
            .overlayPreferenceValue(HeaderBoundsKey.self) { value in
                GeometryReader { proxy in
                    if let anchor = value {
                        Color.clear
                            .onAppear(){
                                // MARK: - Retreiving rect using proxy
                                profileViewModel.headerHeight = proxy[anchor].height
                            }
                    }
                }
            }
            .offset(y: -profileViewModel.headerOffset < profileViewModel.headerHeight ? profileViewModel.headerOffset : (profileViewModel.headerOffset < 0 ? profileViewModel.headerOffset : 0))
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
        
    }
}
