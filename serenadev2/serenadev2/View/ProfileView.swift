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
    @State var direction: SwipeDriection = .none
    @State var shiftOffset: CGFloat = 0
    
    // Opacity variables for the button and the header
    @State var headerOpacity: Double = 1.0
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0){
                    
                    ScrollView (.vertical, showsIndicators: false){
                        VStack(spacing: 15) {
                            PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: SongModel(
                                id: "1",
                                title: "Robbers",
                                artists: "The 1975",
                                artworkUrlSmall: URL(string: "https://example.com/small.jpg"),
                                artworkUrlLarge: URL(string: "https://is5-ssl.mzstatic.com/image/thumb/Music124/v4/f4/bc/71/f4bc7194-a92a-8f73-1b81-154adc503ecb/00602537497119.rgb.jpg/1500x1500bb.jpg"),
                                bgColor: CGColor(srgbRed: 0.12549, green: 0.12549, blue: 0.12549, alpha: 1),
                                priColor: CGColor(srgbRed: 0.898039, green: 0.894118, blue: 0.886275, alpha: 1),
                                secColor: CGColor(srgbRed: 0.815686, green: 0.807843, blue: 0.8, alpha: 1),
                                terColor: CGColor(srgbRed: 0.745098, green: 0.741176, blue: 0.733333, alpha: 1),
                                quaColor: CGColor(srgbRed: 0.67451, green: 0.670588, blue: 0.662745, alpha: 1),
                                previewUrl: URL(string: "https://example.com/preview.mp3"),
                                duration: 295.502,
                                composerName: "Greg Kurstin & Adele Adkins",
                                genreNames: ["Pop"],
                                releaseDate: Date(timeIntervalSince1970: 1445558400))), profileImg: "AfterHourCoverArt")
                            
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
                    .overlay(alignment: .top){
                        ProfileBar(isFriendRequestSent: false, isCurrentUser: true, isFriend: true, user: sebastian)
                            .opacity(headerOpacity)
                            .padding(.top, safeArea().top)
                        //                            .background(colorScheme == .dark ? .black : .white)
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

#Preview {
    ProfileView()
}
