//
//  FeedView.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 22/02/24.
//

import SwiftUI
import CloudKit

// MARK: - Swipe direction
enum SwipeDirection{
    case up
    case down
    case none
}

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

struct FeedView: View {
    @State var userId: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) ?? "")
    @State var userName: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userName) ?? "")
    @State var userEmail: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail) ?? "")
    
    @EnvironmentObject var userViewModel: UserViewModel
    @StateObject var postViewModel: PostViewModel = PostViewModel()
    @StateObject var pushNotificationsVM: PushNotificationViewModel = PushNotificationViewModel()
    
    // MARK: - Environment properties
    // Color scheme of the phone
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Variables
    // Check if the daily is already posted
    @State var isDailyPosted: Bool = false
    
    // Variables to hide/show the header
    @State var headerHeight: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    @State var lastHeaderOffset: CGFloat = 0
    @State var direction: SwipeDirection = .none
    @State var shiftOffset: CGFloat = 0
    
    // Opacity variables for the button and the header
    @State var headerOpacity: Double = 1.0
    @State var dailyButtonOpacity: Double = 1.0
    @State var isDailySheetOpened: Bool = false
    
    // MARK: - Body
    var body: some View {
        
        NavigationStack{
            ZStack (alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                ZStack (alignment: .bottom) {
                    ScrollView (.vertical, showsIndicators: false) {
                        VStack (spacing: 15) {
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
                        .padding(.top, headerHeight)
                        .padding([.bottom, .horizontal])
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
                                let normalizedOffset = headerOffset / (isDailyPosted ? 100 : 50)
                                
                                // Calculate the opaciti for the header and the button
                                headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
                                dailyButtonOpacity = max(0.3, 1.0 + Double(normalizedOffset))
                                
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
                                let normalizedOffset = headerOffset / (isDailyPosted ? 100 : 50)
                                
                                // Calculate the opaciti for the header and the button
                                headerOpacity = max(0.0, 1.0 + Double(normalizedOffset))
                                withAnimation{
                                    dailyButtonOpacity = 1.0
                                }
                            }
                        }
                        
                        Spacer()
                            .frame(height: isDailyPosted ? 0 : 80)
                        
                        
                    }
                    .refreshable {
                        print("Fetching post again...")
                        let userID = UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) ?? ""
                        Task {
                            if let user = userViewModel.user {
                                print("Fetching posts...")
                                await postViewModel.fetchAllPostsAsync(user: user)
                            }
                        }
                    }
                    .coordinateSpace(name: "SCROLL")
                    .overlay(alignment: .top){
                        VStack(spacing: 12){
                            // Header
                            VStack(spacing: 0) {
                                HStack{
                                    
                                    // Navigation title
                                    Text(LocalizedStringKey("Feed"))
                                        .font(.title)
                                        .bold()
                                    
                                    Spacer()
                                    
                                    // Navigation link to open notifications view
                                    NavigationLink(destination: NotificationsView()
                                        .toolbarRole(.editor)){
                                        Image(systemName: "bell")
                                            .fontWeight(.semibold)
                                            .font(.title2)
                                    }
                                    .foregroundStyle(.primary)
                                }
                                .padding(.bottom, 10)
                                .padding([.horizontal, .top])
                                
                                Divider()
                                    .padding(.horizontal, -15)
                                
                                // If the daily post has already been made, show the user's post
                                if isDailyPosted {
                                    DailyPosted(song: SongModel(
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
                                        releaseDate: Date(timeIntervalSince1970: 1445558400)))
                                }
                                
                                Divider()
                                    .padding(.horizontal, -15)
                            }
                        }
                        .opacity(headerOpacity)
                        .padding(.top, safeArea().top)
                        .background(colorScheme == .dark ? .black : .white)
                        .padding(.bottom)
                        
                        .anchorPreference(key: HeaderBoundsKey.self, value: .bounds){$0}
                        
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
                    .ignoresSafeArea(.all, edges: .top)
                    // If the daily post has not yet been made, show the button to do it
                    if !isDailyPosted {
                        ActionButton(label: LocalizedStringKey("ShareDailyButton"), symbolName: "waveform", fontColor: .white, backgroundColor: .purple, isShareDaily: true, isDisabled: false) {
                            isDailySheetOpened.toggle()
                        }
                        .opacity(dailyButtonOpacity)
                        .fullScreenCover(isPresented: $isDailySheetOpened){
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
            let userID = UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) ?? ""
            print("UserID: ", userID)
            Task {
                if let user = userViewModel.user {
                    pushNotificationsVM.requestNotificationPermissions()
                    pushNotificationsVM.subscribeToNotifications(user: user)
                    print("Fetching posts...")
                    await postViewModel.fetchAllPostsAsync(user: user)
                }
            }
        }
    }
}

#Preview {
    FeedView()
}

