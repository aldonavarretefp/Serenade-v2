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
                VStack(spacing: 0) {
                    ProfileBar(isFriendRequestSent: false, isCurrentUser: true, isFriend: true, user: sebastian)
                    ScrollView {
                        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: .blue, fontColor: .red)), profileImg: "")
                            .padding([.top, .leading, .trailing])
                        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: .blue, fontColor: .red)), profileImg: "")
                            .padding(.horizontal)
                            .padding(.top, 5)
                        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: .blue, fontColor: .red)), profileImg: "")
                            .padding(.horizontal)
                            .padding(.top, 5)
                        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: .blue, fontColor: .red)), profileImg: "")
                            .padding(.horizontal)
                            .padding(.top, 5)
                    }
                }
            }
        }
        
    }
}

#Preview {
    ProfileView()
}
