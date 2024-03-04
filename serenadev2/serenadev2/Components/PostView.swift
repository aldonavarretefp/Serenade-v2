//
//  Post.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 20/02/24.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        Text("")
    }
/*
    @Environment(\.colorScheme) var colorScheme
    @State var isSongInfoDisplayed: Bool = false
    @EnvironmentObject var userViewModel: UserViewModel
    
    var post: Post
    
    // Quitar despues
    var profileImg: String
    
    var formattedDate: Text {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(post.date) {
            return Text(LocalizedStringKey("Today"))
        } else if calendar.isDateInYesterday(post.date) {
            return Text(LocalizedStringKey("Yesterday"))
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return Text(dateFormatter.string(from: post.date))
        }
    }
    
    var body: some View {
        
        //let strokeGradient = LinearGradient(gradient: Gradient(colors: [(colorScheme == .light ? Color.black : Color.white).opacity(0.46), (colorScheme == .light ? Color.black : Color.white).opacity(0.23)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.card)
                .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0.0), radius: 18, y: 5)
            VStack(alignment: .leading) {
                HStack {
                    Image(profileImg)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(height: 28)
                    
                    let userSender = userViewModel.fetchUserFromAccountID(accountID: post.sender.recordID)
                    Text(userSender?.tagName ?? "").fontWeight(.bold).foregroundStyle(colorScheme == .light ? .black : .white) + Text("'s daily song")
                    
                    Text(post.sender).fontWeight(.bold).foregroundStyle(colorScheme == .light ? .black : .white) + Text(LocalizedStringKey("TypePostDaily"))
                    Spacer()
                    formattedDate
                }
                .foregroundStyle(.callout)
                .padding([.top, .leading, .trailing])
                .padding(.bottom, post.caption == "" ? 5 : 0)
                //                Spacer()
                if post.caption != "" {
                    Text(post.caption!)
                        .lineLimit(4)
                        .padding(.horizontal)
                        .padding(.top, 2)
                        .padding(.bottom, 2)
                }
//                Image()
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: 95)
//                    .blur(radius: 20.0)
//                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                
                // Back card song cover art
                AsyncImage(url: post.song?.artworkUrlMedium, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color((post.song?.bgColor)!))
                            .frame(height: 95)
                            .blur(radius: 20.0)
                            .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 95)
                            .blur(radius: 20.0)
                            .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                            .transition(.opacity.animation(.easeIn(duration: 0.5)))
                    case .failure(_):
                        Rectangle()
                            .fill(Color((post.song?.bgColor)!))
                            .frame(height: 95)
                            .blur(radius: 20.0)
                            .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                    default:
                        Rectangle()
                            .fill(Color((post.song?.bgColor)!))
                            .frame(height: 95)
                            .blur(radius: 20.0)
                            .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                    }
                }
            }
            ZStack(alignment: .leading) {
                UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0))
                //                    .fill(Color((post.song?.bgColor)!).opacity(0.5))
                    .fill(.card.opacity(0.7))
                    .frame(height: 95)
                
                HStack {
//                    Image(post.song!.coverArt)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 70, height: 70)
//                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
//                        .padding()
                    VStack(alignment: .leading) {
//                        Text(post.song!.title)
//                            .fontWeight(.bold)
//                        Text(post.song!.artist)
//                            .font(.footnote)
//                            .foregroundStyle(colorScheme == .light ? Color(hex: 0x2b2b2b) : .callout)
                    AsyncImage(url: post.song?.artworkUrlMedium, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color((post.song?.bgColor)!))
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                .padding()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                .padding()
                                .transition(.opacity.animation(.easeIn(duration: 0.5)))
                        case .failure(_):
                            Rectangle()
                                .fill(Color((post.song?.bgColor)!))
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                .padding()
                        default:
                            Rectangle()
                                .fill(Color((post.song?.bgColor)!))
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                .padding()
                        }
                    }
                    
                    
                    VStack(alignment: .leading) {
                        Text(post.song!.title)
                            .fontWeight(.bold)
                        Text(post.song!.artists)
                            .font(.footnote)
                            .foregroundStyle(colorScheme == .light ? Color(hex: 0x2b2b2b) : .callout)
                    }
                    .padding(.trailing)
                    .lineLimit(2)
                }
                .frame(height: 95)
            }
            // On tap gesture to open the info of the passed song
            .onTapGesture {
                isSongInfoDisplayed = true
            }
            .fullScreenCover(isPresented: $isSongInfoDisplayed){
//                SongDetailView(audioURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/38/be/54/38be54d8-7411-fe31-e15f-c85e7d8515e8/mzaf_15200620892322734212.plus.aac.p.m4a")!, song: post.song!)
                SongDetailView(song: post.song!)
            }
        }
        .font(.subheadline)
    }
 */
}

//#Preview {
//    ScrollView {
//        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!! Give it a listen right now, you won't regret it!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears Save Your Tears Save Your Tears Save Your Tears Save Your Tears Save Your Tears", artist: "The Weeknd The Weeknd The Weeknd The Weeknd The Weeknd The Weeknd The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0x202020), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt")
//        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0x202020), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt")
//        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0x202020), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt")
//        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: Song(id: "id", title: "Save Your Tears", artist: "The Weeknd", album: "After Hours", coverArt: "AfterHoursCoverArt", color: Color(hex: 0x202020), fontColor: Color(hex: 0xffffff))), profileImg: "AfterHoursCoverArt")
//    }
//}
#Preview {
    ScrollView {
        PostView()
    }
}
