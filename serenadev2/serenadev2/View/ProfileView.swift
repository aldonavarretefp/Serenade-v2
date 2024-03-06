//
//  ProfileView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 22/02/24.
//

import SwiftUI

struct ProfileView: View {
    
    // Variables to hide/show the header
    @State var headerHeight: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    @State var lastHeaderOffset: CGFloat = 0
    @State var direction: SwipeDirection = .none
    @State var shiftOffset: CGFloat = 0
    
    // Opacity variables for the button and the header
    @State var headerOpacity: Double = 1.0
    
    @EnvironmentObject var postVM: PostViewModel
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var authManager: AuthManager
    
    @State var posts: [Post] = []
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0){
                    
                    ScrollView (.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            ForEach(posts) { post in
                                PostView(post: post)
                            }
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
                                }
                            }
                            
                        }
                        .padding(.top, headerHeight)
                        .padding(.bottom)
                        .padding(.horizontal)
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
                        if let user = userVM.user {
                            
                            
                            ProfileBar(isFriendRequestSent: false, isCurrentUser: true, isFriend: true, user: user)
                                .opacity(headerOpacity)
                                .padding(.top, safeArea().top)
                            
                                .padding(.bottom)
                                .anchorPreference(key: HeaderBoundsKey.self, value: .bounds){$0}
                                .environmentObject(authManager)
                            
                            // Get the header height
                                .overlayPreferenceValue(HeaderBoundsKey.self){ value in
                                    GeometryReader{ proxy in
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
                    }
                    .ignoresSafeArea(.all, edges: .top)
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
                guard let user = userVM.user else {
                    print("NO USER FROM PROFILE")
                    return
                }
                postVM.fetchAllPostsFromUserID(id: user.record.recordID) { posts in
                    
                    guard let posts else {
                        print("Didn't fetch any posts")
                        return
                    }
                    
                    self.posts = posts
                    print(posts)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}


