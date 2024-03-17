//
//  FeedView.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 22/02/24.
//

import SwiftUI
import CloudKit

struct FeedView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var postViewModel: PostViewModel
    @StateObject private var pushNotificationsVM: PushNotificationViewModel = PushNotificationViewModel()
    @StateObject private var friendRequestsVM: FriendRequestsViewModel = FriendRequestsViewModel()
    @StateObject private var headerViewModel = HeaderViewModel()
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    // Opacity variables for the button and the header
    @State var dailyButtonOpacity: Double = 1.0
    @State var isDailySheetOpened: Bool = false
    
    // MARK: - Body
    var body: some View {
        
        NavigationStack {
            ZStack (alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                ZStack (alignment: .bottom) {
                    ScrollView (.vertical, showsIndicators: false) {
                        LazyVStack (spacing: 15) {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .offset(y: -50)
                            if postViewModel.posts.isEmpty {
                                ContentUnavailableView(label: {
                                    Label(LocalizedStringKey("No posts"), systemImage: "music.note")
                                }, description: {
                                    Text(LocalizedStringKey("Try posting your first one!"))
                                })
                            } else {
                                ForEach(postViewModel.posts, id: \.self) { post in
                                    // Ensure PostView can handle nil or incomplete data gracefully
                                    if let sender = post.sender, let senderUser = postViewModel.senderDetails[sender.recordID], let song = postViewModel.songsDetails[post.songId] {
                                        PostComponent(post: post, sender: senderUser, song: song)
                                    }
                                    else {
                                        PostComponent(post: post)
                                    }
                                }
                            }
                            
                        }
                        .padding(.top, postViewModel.dailySong != nil ? 190 : headerViewModel.headerHeight)
                        .padding([.bottom, .horizontal])
                        .offset(y: -20)
                        .offsetY{ previous, current in
                            // Moving header based on direction scroll
                            if previous > current {
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
                                let normalizedOffset = headerViewModel.headerOffset / (postViewModel.isDailyPosted ? 100 : 50)
                                
                                // Calculate the opaciti for the header and the button
                                headerViewModel.headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
                                dailyButtonOpacity = max(0.3, 1.0 + Double(normalizedOffset))
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
                                let normalizedOffset = headerViewModel.headerOffset / (postViewModel.isDailyPosted ? 100 : 50)
                                
                                // Calculate the opaciti for the header and the button
                                headerViewModel.headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
                                withAnimation {
                                    dailyButtonOpacity = 1.0
                                }
                            }
                        }
                        Spacer()
                            .frame(height: postViewModel.isDailyPosted ? 0 : 80)
                        
                        
                    }
                    .onAppear {
                        fetchUpdatedUser()
                    }
                    .refreshable {
                        print("Fetching post again...")
                        fetchUpdatedUser()
                        Task {
                            await fetchAllSongs()
                        }
                    }
                    .coordinateSpace(name: "SCROLL")
                    .overlay(alignment: .top){
                        VStack(spacing: 12){
                            // The navbar of the feed is overlay because it will move with the content
                            FeedNavbar()
                        }
                        .opacity(headerViewModel.headerOpacity)
                        .padding(.top, safeArea().top)
                        .background(colorScheme == .dark ? .black : .white)
                        .padding(.bottom)
                        .anchorPreference(key: HeaderBoundsKey.self, value: .bounds){$0}
                        .overlayPreferenceValue(HeaderBoundsKey.self){ value in
                            GeometryReader{ proxy in
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
                    // If the daily post has not yet been made, show the button to do it
                    if postViewModel.dailySong == nil && !postViewModel.isDailyPosted {
                        ActionButton(label: LocalizedStringKey("ShareDailyButton"), symbolName: "waveform", fontColor: .white, backgroundColor: .purple, isShareDaily: true, isDisabled: false) {
                            isDailySheetOpened.toggle()
                        }
                        .opacity(dailyButtonOpacity)
                        .fullScreenCover(isPresented: $isDailySheetOpened) {
                            DailySongView(isSongFromDaily: true)
                            
                        }
                        .padding()
                    }
                }
                // This overlay is to show a bar behind the status bar
                .overlay(alignment: .top) {
                    Color.clear
                        .background()
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 0)
                }
            }
        }
        
        .task {
            if let user = userViewModel.user {
                await fetchAllSongs()
                pushNotificationsVM.requestNotificationPermissions()
                //pushNotificationsVM.unsubscribeToNotifications()
                //pushNotificationsVM.subscribeToNotifications(user: user)
            }
        }
    }
    
    private func fetchAllSongs() async -> Void {
        Task {
            if let user = userViewModel.user {
                print("Fetching post again...")
                await postViewModel.fetchAllPostsAsync(user: user)
            }
        }
    }
    
    private func fetchUpdatedUser() {
        guard let mainUser = userViewModel.user else {
            print("No user from userViewModel")
            return
        }
        userViewModel.fetchUserFromRecord(record: mainUser.record) { returnedUser in
            guard let updatedUser = returnedUser else {
                print("NO USER FROM DB")
                return
            }
            print("Fetched User from DB: \(updatedUser)")
            userViewModel.user = updatedUser
            friendRequestsVM.fetchFriendRequestsForUser(user: updatedUser)
        }
    }
}

//#Preview {
//    FeedView()
//}

