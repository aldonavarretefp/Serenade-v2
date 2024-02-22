//
//  Post.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 20/02/24.
//

import SwiftUI

struct PostView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var post: Post
    
    var formattedDate: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(post.date) {
            return "Today"
        } else if calendar.isDateInYesterday(post.date) {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: post.date)
        }
    }
    
    var body: some View {
        
        let strokeGradient = LinearGradient(gradient: Gradient(colors: [(colorScheme == .light ? Color.black : Color.white).opacity(0.46), (colorScheme == .light ? Color.black : Color.white).opacity(0.23)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.card)
                .shadow(radius: colorScheme == .light ? 30 : 0)
                .opacity(0.3)
            VStack(alignment: .leading) {
                HStack {
                    if (post.senderUser?.profilePictue != nil) {
                        Image("person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(height: 30)
                    }
                    else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(height: 30)
                    }
                    Text(post.sender).fontWeight(.bold).foregroundStyle(colorScheme == .light ? .black : .white) + Text("'s daily song")
                    Spacer()
                    Text(formattedDate)
                        .font(.caption)
                }
                .foregroundStyle(.callout)
                .padding([.top, .leading, .trailing])
                .padding(.bottom, post.caption == "" ? 5 : 0)
//                Spacer()
                if post.caption != "" {
                    Text(post.caption!)
                        .lineLimit(4)
                        .padding(.horizontal)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                }
                Image(post.song!.coverArt)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 95)
                    .blur(radius: 20.0)
                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
            }
            ZStack(alignment: .leading) {
                UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0))
                    .fill(.card)
                    .strokeBorder(strokeGradient, lineWidth: 1)
                    .frame(height: 95)
                    .opacity(0.7)
                    
                HStack {
                    Image(post.song!.coverArt)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding()
                    VStack(alignment: .leading) {
                        Text(post.song!.title)
                            .fontWeight(.bold)
                        Text(post.song!.artist)
                            .font(.caption)
                            .foregroundStyle(colorScheme == .light ? .black : .callout)
                    }
                    .padding(.trailing)
                    .lineLimit(2)
                }
                .frame(height: 95)
            }
            .onTapGesture {
//                SongDetailSheet(song: post.song)
            }
        }
        .font(.footnote)
        .padding([.top, .leading, .trailing])
    }
}

#Preview {
    ScrollView {
        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!! Give it a listen right now, you won't regret it!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears Save Your Tears Save Your Tears Save Your Tears Save Your Tears Save Your Tears", artist: "The Weeknd The Weeknd The Weeknd The Weeknd The Weeknd The Weeknd The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt")))
        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt")))
        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt")))
        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt")))
    }
}
