//
//  FeedView.swift
//  prueba
//
//  Created by Alejandro Oliva Ochoa on 22/02/24.
//

import SwiftUI

struct FeedView: View {
    
    // MARK: - Environment properties
    // Color scheme of the phone
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Variables
    // Check if the daily is already posted
    @State var isDailyPosted: Bool = true
    
    // Variables to hide/show the header
    @State var headerHeight: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    @State var lastHeaderOffset: CGFloat = 0
    @State var direction: SwipeDriection = .none
    @State var shiftOffset: CGFloat = 0
    
    // Opacity variables for the button and the header
    @State var headerOpacity: Double = 1.0
    @State var dailyButtonOpacity: Double = 1.0
    
    // Posts array to see some hardcoded posts
    let posts: [PostView] = [
        PostView(post: Post(id: "1", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "1", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0xA28860), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt"),
        
        PostView(post: Post(id: "2", type: .daily, sender: "John", receiver: "receiver", caption: "Check out this amazing song!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "2", title: "Entropy", artist: "The Beach Bunny", album: "Unknown", coverArt: "entropy", color: Color(hex: 0xAEA6F6), fontColor: Color(hex: 0x202020))), profileImg: "entropy"),
        
        PostView(post: Post(id: "3", type: .daily, sender: "Emily", receiver: "receiver", caption: "Missing Mac Miller!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "3", title: "Love Lost", artist: "Mac Miller", album: "Unknown", coverArt: "mac", color: Color(hex: 0xFEE6E1), fontColor: Color(hex: 0xFF0506))), profileImg: "mac"),
        
        PostView(post: Post(id: "4", type: .daily, sender: "Michael", receiver: "receiver", caption: "Classic vibes!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "4", title: "Robbers", artist: "The 1975", album: "Unknown", coverArt: "the19", color: Color(hex: 0x333333), fontColor: Color(hex: 0xffffff))), profileImg: "the19"),
        
        PostView(post: Post(id: "5", type: .daily, sender: "Sophia", receiver: "receiver", caption: "Throwback!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "5", title: "See you again (feat. Kali Uchis)", artist: "Tyler, The Creator, Kali Uchis", album: "Flowerboy", coverArt: "tyler", color: Color(hex: 0xD5881C), fontColor: Color(hex: 0xffffff))), profileImg: "tyler"),
        
        PostView(post: Post(id: "6", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "1", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0xA28860), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt"),
        
        PostView(post: Post(id: "7", type: .daily, sender: "John", receiver: "receiver", caption: "Check out this amazing song!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "2", title: "Entropy", artist: "The Beach Bunny", album: "Unknown", coverArt: "entropy", color: Color(hex: 0xAEA6F6), fontColor: Color(hex: 0x202020))), profileImg: "entropy"),
        
        PostView(post: Post(id: "8", type: .daily, sender: "Emily", receiver: "receiver", caption: "Missing Mac Miller!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "3", title: "Love Lost", artist: "Mac Miller", album: "Unknown", coverArt: "mac", color: Color(hex: 0xFEE6E1), fontColor: Color(hex: 0xFF0506))), profileImg: "mac"),
        
        PostView(post: Post(id: "9", type: .daily, sender: "Michael", receiver: "receiver", caption: "Classic vibes!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "4", title: "Robbers", artist: "The 1975", album: "Unknown", coverArt: "the19", color: Color(hex: 0x333333), fontColor: Color(hex: 0xffffff))), profileImg: "the19"),
        
        PostView(post: Post(id: "10", type: .daily, sender: "Sophia", receiver: "receiver", caption: "Throwback!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "5", title: "See you again (feat. Kali Uchis)", artist: "Tyler, The Creator, Kali Uchis", album: "Flowerboy", coverArt: "tyler", color: Color(hex: 0xD5881C), fontColor: Color(hex: 0xffffff))), profileImg: "tyler")
    ]
    
    // MARK: - Body
    var body: some View {
        ZStack (alignment: .top){
            // Background of the view
            Color.viewBackground
                .ignoresSafeArea()
            
            ZStack (alignment: .bottom){
                
                // Scrollview with all the posts
                ScrollView (.vertical, showsIndicators: false){
                    VStack (spacing: 15){
                        
                        ForEach(posts, id: \.post.id) { postView in
                            PostView(post: postView.post, profileImg: postView.profileImg)
                            
                        }
                    }
                    .padding(.top, headerHeight)
                    .padding(.bottom)
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
                    .padding(.horizontal)
                    
                    // This spacer puts space at the bottom of the list if the post daily button is shown
                    Spacer()
                        .frame(height: isDailyPosted ? 0 : 80)
                    
                }
                .coordinateSpace(name: "SCROLL")
                .overlay(alignment: .top){
                    VStack(spacing: 12){
                        
                        // Header
                        VStack(spacing: 0){
                            HStack{
                                
                                // Navigation title
                                Text("Feed")
                                    .font(.title)
                                    .bold()
                                
                                Spacer()
                                
                                // Navigation link to open notifications view
                                NavigationLink(destination: EmptyView()){
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
                                DailyPosted(song: Song(id: "2", title: "Entropy", artist: "The Beach Bunny", album: "Unknown", coverArt: "entropy", color: Color(hex: 0xAEA6F6), fontColor: Color(hex: 0x202020)))
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
                    ActionButton(label: "Share daily song", symbolName: "waveform", fontColor: .white, backgroundColor: .purple, isShareDaily: true) {
                        print("Daily button tapped")
                    }
                    .opacity(dailyButtonOpacity)
                    .padding()
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
    }
}

// MARK: - Swipe direction
enum SwipeDriection{
    case up
    case down
    case none
}

#Preview {
    FeedView()
}
