//
//  Post.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 20/02/24.
//

import SwiftUI

struct Post: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var sender: String
    var senderProfilePicture: String?
    var caption: String
    var date: Date
    var songTitle: String
    var songArtist: String
    var songCoverArt: String
    
    var formattedDate: String {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
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
                    if (senderProfilePicture != nil) {
                        Image(senderProfilePicture!)
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
                    Text(sender).fontWeight(.bold).foregroundStyle(colorScheme == .light ? .black : .white) + Text("'s daily song")
                    Spacer()
                    Text(formattedDate)
                        .font(.caption)
                }
                .foregroundStyle(.callout)
                .padding([.top, .leading, .trailing])
//                Spacer()
                if caption != "" {
                    Text(caption)
                        .lineLimit(4)
                        .padding(.horizontal)
                        .padding(.top, 5)
                        .padding(.bottom, 10)
                }
                Image(songCoverArt)
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
                    Image(songCoverArt) //  song.coverArt
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding()
                    VStack(alignment: .leading) {
                        Text(songTitle)  //  song.title
                            .fontWeight(.bold)
                        Text(songArtist) //  song.artist
                            .font(.caption)
                            .foregroundStyle(colorScheme == .light ? .black : .callout)
                    }
                }
                .frame(height: 95)
            }
            .onTapGesture {
//                SongDetailSheet(song: song)
            }
        }
        .font(.footnote)
        .padding([.top, .leading, .trailing])
    }
}

#Preview {
    ScrollView {
        Post(sender: "sebatoo", caption: "This is the best song I've ever heard!!! Give it a listen right now, you won't regret it!!", date: Date(), songTitle: "Save Your Tears", songArtist: "The Weeknd", songCoverArt: "AfterHoursCoverArt")
        Post(sender: "sebatoo", caption: "This is the best song I've ever heard!!!", date: Date(), songTitle: "Save Your Tears", songArtist: "The Weeknd", songCoverArt: "AfterHoursCoverArt")
        Post(sender: "sebatoo", caption: "This is the best song I've ever heard!!!", date: Date(), songTitle: "Save Your Tears", songArtist: "The Weeknd", songCoverArt: "AfterHoursCoverArt")
        Post(sender: "sebatoo", caption: "This is the best song I've ever heard!!!", date: Date(), songTitle: "Save Your Tears", songArtist: "The Weeknd", songCoverArt: "AfterHoursCoverArt")
    }
}
