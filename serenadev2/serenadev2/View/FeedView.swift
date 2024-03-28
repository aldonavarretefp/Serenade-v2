//
//  FeedView.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 22/02/24.
//

import SwiftUI
import CloudKit

let songObj: SongModel = SongModel(
    id: "1",
    title: "Hello",
    artists: "Adele",
    artworkUrlSmall: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/62/bc/87/62bc8791-2a12-4b01-8928-d601684a951c/634904074005.png/100x100bb.jpg"), artworkUrlMedium: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/62/bc/87/62bc8791-2a12-4b01-8928-d601684a951c/634904074005.png/500x500bb.jpg"),
    artworkUrlLarge: URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/62/bc/87/62bc8791-2a12-4b01-8928-d601684a951c/634904074005.png/1000x1000bb.jpg"),
    bgColor: CGColor(srgbRed: 0.12549, green: 0.12549, blue: 0.12549, alpha: 1),
    priColor: CGColor(srgbRed: 0.898039, green: 0.894118, blue: 0.886275, alpha: 1),
    secColor: CGColor(srgbRed: 0.815686, green: 0.807843, blue: 0.8, alpha: 1),
    terColor: CGColor(srgbRed: 0.745098, green: 0.741176, blue: 0.733333, alpha: 1),
    quaColor: CGColor(srgbRed: 0.67451, green: 0.670588, blue: 0.662745, alpha: 1),
    previewUrl: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview116/v4/5e/46/de/5e46de64-70d7-01a9-438f-8395a0e41b58/mzaf_15694838464598234027.plus.aac.p.m4a"), albumTitle: "",
    duration: 295.502,
    composerName: "Greg Kurstin & Adele Adkins",
    genreNames: ["Pop"],
    releaseDate: Date(timeIntervalSince1970: 1445558400))

class FeedViewModel: ObservableObject {
    // MARK: - Variables
    // Variables to hide/show the header
    @Published var headerHeight: CGFloat = 0
    @Published var headerOffset: CGFloat = 0
    @Published var lastHeaderOffset: CGFloat = 0
    @Published var direction: SwipeDirection = .none
    @Published var shiftOffset: CGFloat = 0
    
    // Opacity variables for the button and the header
    @Published var headerOpacity: Double = 1.0
    @Published var dailyButtonOpacity: Double = 1.0
    @Published var isDailySheetOpened: Bool = false
    
}

struct FeedView: View {
    // MARK: - Environment objects
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    // Opacity variables for the button and the header
    @State var dailyButtonOpacity: Double = 1.0
    @State var isDailySheetOpened: Bool = false
    @StateObject var pushNotificationsVM: PushNotificationViewModel = PushNotificationViewModel()
    @StateObject var friendRequestsVM: FriendRequestsViewModel = FriendRequestsViewModel()
    @StateObject var feedVM: FeedViewModel = FeedViewModel()
    @StateObject private var headerViewModel = HeaderViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack (alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                ZStack (alignment: .bottom) {
                    ScrollView (.vertical, showsIndicators: false) {
                        LazyVStack (spacing: 15) {
                            if postViewModel.posts.isEmpty {
                                ContentUnavailableView(label: {
                                    Label(LocalizedStringKey("No posts"), systemImage: "music.note")
                                }, description: {
                                    Text(LocalizedStringKey("Try posting your first one!"))
                                })
                            } else {
                                ForEach(postViewModel.posts, id: \.self) { post in
                                    // Ensure PostView can handle nil or incomplete data gracefully
                                    if let sender = post.sender, let senderUser = postViewModel.senderDetails[sender.recordID.recordName], let song = postViewModel.songsDetails[post.songId] {
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
                                    feedVM.dailyButtonOpacity = 1.0
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
                            await fetchAllPosts()
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
                                        .onAppear() {
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
                            feedVM.isDailySheetOpened.toggle()
                        }
                        .opacity(feedVM.dailyButtonOpacity)
                        .fullScreenCover(isPresented: $feedVM.isDailySheetOpened) {
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
    }
    
    private func fetchAllPosts() async -> Void {
        Task {
            if let user = userViewModel.user {
                await postViewModel.fetchAllPosts(user: user)
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
            userViewModel.user = updatedUser
            friendRequestsVM.fetchFriendRequestsForUser(user: updatedUser)
        }
    }
}
