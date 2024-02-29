//
//  Post.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 20/02/24.
//

import SwiftUI

struct PostView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var isSongInfoDisplayed: Bool = false
    
    var post: Post
    
    // Quitar despues
    var profileImg: String
    
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
                    
                    
                    Text(post.sender).fontWeight(.bold).foregroundStyle(colorScheme == .light ? .black : .white) + Text("'s daily song")
                    Spacer()
                    Text(formattedDate)
                        .font(.footnote)
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
                
                // Back card song cover art
                AsyncImage(url: post.song?.artworkUrlSmall, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
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
                    AsyncImage(url: post.song?.artworkUrlSmall, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
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
                SongDetailView(song: post.song!)
            }
        }
        .font(.subheadline)
    }
}

#Preview {
    ScrollView {
        PostView(post: Post(id: "id", type: .daily, sender: "sebatoo", receiver: "receiver", caption: "This is the best song I've ever heard!!! Give it a listen right now, you won't regret it!!", songId: "songId", date: Date(), isAnonymous: false, isDeleted: false, song: SongModel(
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
            releaseDate: Date(timeIntervalSince1970: 1445558400))), profileImg: "AfterHoursCoverArt")
    }
}
