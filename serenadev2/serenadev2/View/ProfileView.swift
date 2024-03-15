//
//  ProfileView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 22/02/24.
//

import SwiftUI
import CloudKit

struct ProfileView: View {
    
    // Variables to hide/show the header
    @State var headerHeight: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    @State var lastHeaderOffset: CGFloat = 0
    @State var direction: SwipeDirection = .none
    @State var shiftOffset: CGFloat = 0
    
    // Opacity variables for the button and the header
    @State var headerOpacity: Double = 1.0
    
    @StateObject var postVM: PostViewModel = PostViewModel()
    @EnvironmentObject var userVM: UserViewModel
    
    @State var posts: [Post] = []
    @State var user: User = User(name: "No User", tagName: "nouser", email: "", streak: 0, profilePicture: "", isActive: false, record: CKRecord(recordType: UserRecordKeys.type.rawValue))
    
    @State private var isLoading: Bool = false
    @State var friendsFromUser : [User] = []
    
    @State var isFriend: Bool = false
    @State var isFriendRequestSent: Bool = false
    @State var isFriendRequestReceived: Bool = false
    @State var showFriendRequestButton: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                VStack(spacing: 0) {
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
                                        PostComponentInProfile(post: post, sender: senderUser, song: song)
                                    }
                                    else {
                                        PostComponentInProfile(post: post)
                                    }
                                }
                            }
                        }
                        .padding(.top, headerHeight)
                        .padding([.bottom,.horizontal])
                        .offset(y: -20)
                        .offsetY{ previous, current in
                            // Moving header based on direction scroll
                            if previous > current{
                                // MARK: - Up
                                if direction != .up && current < 0{
                                    shiftOffset = current - headerOffset
                                    direction = .up
                                    lastHeaderOffset = headerOffset
                                }
                                
                                let offset = current < 0 ? (current - shiftOffset) : 0
                                
                                // Checking if it does not goes over header height
                                headerOffset = (-offset < headerHeight ? (offset < 0 ? offset : 0) : -headerHeight)
                                
                                // get the normalized offset so it is always between 0 and 1
                                let normalizedOffset = 100
                                
                                // Calculate the opaciti for the header and the button
                                headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
                                
                            } else {
                                // MARK: - Down
                                if direction != .down{
                                    shiftOffset = current
                                    direction = .down
                                    lastHeaderOffset = headerOffset
                                }
                                
                                let offset = lastHeaderOffset + (current - shiftOffset)
                                headerOffset = (offset > 0 ? 0 : offset)
                                
                                // get the normalized offset so it is always between 0 and 1
                                let normalizedOffset = 100
                                
                                // Calculate the opaciti for the header and the button
                                headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
                                
                            }
                        }
                    }
                    .coordinateSpace(name: "SCROLL")
                    .overlay(alignment: .top) {
                        
                        ProfileBar(friends: $friendsFromUser, user: $user, isFriend: $isFriend, isFriendRequestSent: $isFriendRequestSent, isFriendRequestRecieved: $isFriendRequestReceived, showFriendRequestButton: $showFriendRequestButton, isLoading: $isLoading, isCurrentUser: true)
                            .opacity(headerOpacity)
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
                                                headerHeight = proxy[anchor].height
                                            }
                                    }
                                }
                            }
                            .offset(y: -headerOffset < headerHeight ? headerOffset : (headerOffset < 0 ? headerOffset : 0))
                        
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
                isLoading = true
                friendsFromUser = await userVM.fetchFriendsForUser(user: user)
                isLoading = false
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
        self.user = user
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
        
    }
}
