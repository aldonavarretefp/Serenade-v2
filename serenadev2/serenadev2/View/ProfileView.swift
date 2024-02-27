//
//  ProfileView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 22/02/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0){
                    ProfileBar(isFriendRequestSent: false, isCurrentUser: true, isFriend: true, user: sebastian)
                    
                    ScrollView (.vertical, showsIndicators: false){
                        VStack(spacing: 15) {
                            PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0xA28860), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt")
                            PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0xA28860), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt")
                                
                            PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0xA28860), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt")
                            PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0xA28860), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt")
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
