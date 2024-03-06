//
//  Post.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 20/02/24.
//

import SwiftUI
import IGStoryKit
import CloudKit

struct PostView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var isSongInfoDisplayed: Bool = false
    
    @State private var imageLoaded = false
    
    
    var post: Post
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
    var sender: User?
    var song: SongModel?
    
    var body: some View {
        
        //let strokeGradient = LinearGradient(gradient: Gradient(colors: [(colorScheme == .light ? Color.black : Color.white).opacity(0.46), (colorScheme == .light ? Color.black : Color.white).opacity(0.23)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 15)
                .fill(.card)
                .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0.0), radius: 18, y: 5)
            VStack(alignment: .leading) {
                HStack {
                    if let sender, sender.profilePicture != "" {
                        Image(sender.profilePicture)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(height: 28)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(height: 28)
                    }
                    
                    if let sender , sender.tagName != "" {
                        Text(sender.tagName).fontWeight(.bold).foregroundStyle(colorScheme == .light ? .black : .white) + Text(LocalizedStringKey("TypePostDaily"))
                    }
                    else {
                        Text("user").fontWeight(.bold).foregroundStyle(colorScheme == .light ? .black : .white) + Text(LocalizedStringKey("TypePostDaily"))
                    }
                    Spacer()
                    formattedDate
                }
                .foregroundStyle(.callout)
                .padding([.top, .leading, .trailing])
                .padding(.bottom, post.caption == "" ? 5 : 0)
                //                Spacer()
                if let postCaption = post.caption {
                    if postCaption != "" {
                        Text(postCaption)
                            .lineLimit(4)
                            .padding(.horizontal)
                            .padding(.top, 2)
                            .padding(.bottom, 2)
                    }
                }
                //                Image()
                //                    .resizable()
                //                    .aspectRatio(contentMode: .fill)
                //                    .frame(height: 95)
                //                    .blur(radius: 20.0)
                //                    .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                
                // Back card song cover art
                if let song {
                    AsyncImage(url: song.artworkUrlMedium, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color((song.bgColor)!))
                                .frame(height: 95)
                                .blur(radius: 20.0)
                                .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                        case .success(let image):
                            image
                                .resizable()
                                .onAppear {
                                    self.imageLoaded = true
                                    print("image loaded")
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 95)
                                .blur(radius: 20.0)
                                .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                                .transition(.opacity.animation(.easeIn(duration: 0.5)))
                                
                        case .failure(_):
                            Rectangle()
                                .fill(Color((song.bgColor)!))
                                .frame(height: 95)
                                .blur(radius: 20.0)
                                .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                        default:
                            Rectangle()
                                .fill(Color((song.bgColor)!))
                                .frame(height: 95)
                                .blur(radius: 20.0)
                                .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                        }
                    }
                }
                else {
                    Rectangle()
                        .fill(Color(.callout))
                        .frame(height: 95)
                        .blur(radius: 20.0)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
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
                    //                    VStack(alignment: .leading) {
                    //                        Text(post.song!.title)
                    //                            .fontWeight(.bold)
                    //                        Text(post.song!.artist)
                    //                            .font(.footnote)
                    //                            .foregroundStyle(colorScheme == .light ? Color(hex: 0x2b2b2b) : .callout)
                    if let song {
                        AsyncImage(url: song.artworkUrlMedium, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                            switch phase {
                            case .empty:
                                Rectangle()
                                    .fill(Color((song.bgColor)!))
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
                                    .fill(Color((song.bgColor)!))
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                    .padding()
                            default:
                                Rectangle()
                                    .fill(Color((song.bgColor)!))
                                    .frame(width: 70, height: 70)
                                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                    .padding()
                            }
                        }
                        
                        
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .fontWeight(.bold)
                            Text(song.artists)
                                .font(.footnote)
                                .foregroundStyle(colorScheme == .light ? Color(hex: 0x2b2b2b) : .callout)
                        }
                        .padding(.trailing)
                        .lineLimit(2)
                    }
                    else {
                        Rectangle()
                            .fill(Color(.callout))
                            .frame(width: 70, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .padding()
                        VStack(alignment: .leading) {
                            Text("Song Title")
                                .fontWeight(.bold)
                            Text("Artist")
                                .font(.footnote)
                                .foregroundStyle(colorScheme == .light ? Color(hex: 0x2b2b2b) : .callout)
                        }
                        .padding(.trailing)
                        .lineLimit(2)
                    }
                    
                    
                    if let colorPri = song?.priColor, let colorBg = song?.bgColor {
                        Spacer()
                        
                        VStack{
                            Spacer()
                            
                            Button{
                                if imageLoaded {
                                    let postViewInstance = PostView(post: post, sender: sender, song: song).environmentObject(userViewModel)
                                    let image = snapshot(postViewInstance)
                                    shareImageToInstagramStory(image: image)
                                } else {
                                    print("Image not loaded yet")
                                }
                            } label : {
                                
                                Image(systemName: "square.and.arrow.up.circle.fill")
                                    .bold()
                                    .font(.title)
                                    .symbolRenderingMode(.palette)
                                    .foregroundStyle(Color(colorPri), Color(colorBg))
                                
                                    .padding([.horizontal, .top])
                                    .padding(.bottom, 12)
                            }
                            .buttonStyle(.plain)
                        }
                    } else {
                        
                    }
                    
                    
                }
                .frame(height: 95)
            }
            // On tap gesture to open the info of the passed song
            .onTapGesture {
                if song != nil {
                    isSongInfoDisplayed = true
                }
            }
            .fullScreenCover(isPresented: $isSongInfoDisplayed){
                //                SongDetailView(audioURL: URL(string: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview115/v4/38/be/54/38be54d8-7411-fe31-e15f-c85e7d8515e8/mzaf_15200620892322734212.plus.aac.p.m4a")!, song: post.song!)
                if let song {
                    SongDetailView(song: song)
                }
            }
        }
        .font(.subheadline)
        .task {
            print("POSTVIEW: ")
            print(self.post)
            print(self.sender ?? "NO SENDER")
            //            let senderRecord = CKRecord(recordType: UserRecordKeys.type.rawValue, recordID: post.sender!.recordID)
            //            userViewModel.fetchUserFromRecord(record: senderRecord) { (returnedUser: User?) in
            //                print(returnedUser ?? "No user")
            //                if returnedUser != nil {
            //                    sender = returnedUser!
            //                }
            //            }
            //            songViewModel.fetchSong(id: post.songId) { song in
            //                self.song = songViewModel.song
            //            }
            //
        }
    }
    
    func shareImageToInstagramStory(image: UIImage) {
        // Ensure "frameInstagram" exists in your asset catalog
        if let backgroundImage = UIImage(named: "frameInstagram") {
            let story = IGStory(contentSticker: image, background: .image(image: backgroundImage))
            
            let dispatcher = IGDispatcher(story: story, facebookAppID: "instagram-stories")
            
            dispatcher.start()
        } else {
            // Handle the error if the image does not exist in your assets
            print("Background image not found in assets.")
        }
    }
    
    func snapshot<Content: View>(_ view: Content, asImageWithScale scale: CGFloat = 1.0) -> UIImage {
        let controller = UIHostingController(rootView: view.background(.clear))
        
        // Transparent background
        controller.view.backgroundColor = .clear
        
        let viewSize = controller.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .defaultHigh)
        controller.view.bounds = CGRect(origin: .zero, size: CGSize(width: viewSize.width + 200, height: viewSize.height + 75))
        return controller.view.asImage()
    }
    
    
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
    }
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
        PostView(post: Post(postType: .daily, songId: "songId", date: Date(), isAnonymous: false, isActive: true))
    }
}
