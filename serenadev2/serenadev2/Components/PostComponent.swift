//
//  PostComponent.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 09/03/24.
//

import SwiftUI
import IGStoryKit
import CloudKit

struct PostComponent: View {
    
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
    
    @State var artworkToShare: Image?
    @State var userImageToShare: Image?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0){
            // User info
            HStack{
                if let sender, let asset = sender.profilePictureAsset {
                    AsyncImage(url: asset.fileURL) { phase in
                        switch phase {
                        case .success(let img):
                            img
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                                .onAppear{
                                    DispatchQueue.main.async {
                                        userImageToShare = img
                                    }
                                }
                            
                        default:
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(height: 28)
                        }
                    }
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
                    Text(LocalizedStringKey("LoadingSender")).fontWeight(.bold).foregroundStyle(colorScheme == .light ? .black : .white) + Text(LocalizedStringKey("TypePostDaily"))
                }
                Spacer()
                formattedDate
            }
            .padding()
            
            // Caption
            if let postCaption = post.caption {
                if postCaption != "" {
                    Text(postCaption)
                        .padding([.horizontal, .bottom])
                }
            }
            
            ZStack{
                
                // Back card song cover art
                if self.imageLoaded {
                    artworkToShare!
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 115)
                        .blur(radius: 20.0)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                } else {
                    Rectangle()
                        .fill(Color(.callout))
                        .frame(height: 115)
                        .blur(radius: 20.0)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                }
                
                ZStack{
                    Rectangle()
                        .fill(.card.opacity(0.7))
                    
                    HStack{
                        if let song {
                            AsyncImage(url: song.artworkUrlMedium, transaction: Transaction(animation: .spring(response: 0.5, dampingFraction: 0.6))) { phase in
                                switch phase {
                                case .empty:
                                    Rectangle()
                                        .fill(Color((song.bgColor)!))
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                        .transition(.opacity.animation(.easeIn(duration: 0.5)))
                                        .onAppear {
                                            withAnimation{
                                                self.imageLoaded = true
                                                artworkToShare = image
                                            }
                                        }
                                    
                                case .failure(_):
                                    Rectangle()
                                        .fill(Color((song.bgColor)!))
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                default:
                                    Rectangle()
                                        .fill(Color((song.bgColor)!))
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(song.title)
                                    .fontWeight(.bold)
                                Text(song.artists)
                                    .font(.footnote)
                                    .foregroundStyle(colorScheme == .light ? Color(hex: 0x2b2b2b) : .callout)
                            }
                            .padding(.leading, 5)
                            .lineLimit(2)
                            
                            Spacer()
                            
                            if let colorPri = song.priColor, let colorBg = song.bgColor {
                                Button{
                                    if imageLoaded {
                                        let postViewInstance = PostInstagramView(sender: self.sender, post: post, song: self.song, artwork: artworkToShare!, userImage: userImageToShare)
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
                                }
                                .buttonStyle(.plain)
                                .padding()
                            }
                        } else {
                            Rectangle()
                                .fill(Color(.callout))
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            VStack(alignment: .leading) {
                                Text(LocalizedStringKey("LoadingSongTitle"))
                                    .fontWeight(.bold)
                                Text(LocalizedStringKey("LoadingSongArtist"))
                                    .font(.footnote)
                                    .foregroundStyle(colorScheme == .light ? Color(hex: 0x2b2b2b) : .callout)
                            }
                            .padding(.leading, 5)
                            .lineLimit(2)
                            
                            Spacer()
                        }
                    }
                    .padding([.vertical, .leading])
                }
                // On tap gesture to open the info of the passed song
                .onTapGesture {
                    if song != nil {
                        isSongInfoDisplayed = true
                    }
                }
                .fullScreenCover(isPresented: $isSongInfoDisplayed){
                    if let song {
                        SongDetailView(song: song)
                    }
                }
                
                
            }
            
        }
        .font(.subheadline)
        .background(.card)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0.0), radius: 18, y: 5)
    }
    
    func shareImageToInstagramStory(image: UIImage) {
        if UIImage(named: "frameInstagram") != nil {
            guard let song = song, let topColor = song.bgColor, let bottomColor = song.quaColor else {
                return
            }
            let story = IGStory(contentSticker: image, background: .gradient(colorTop: UIColor(cgColor: topColor), colorBottom: UIColor(cgColor: bottomColor)))
            
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
        controller.view.bounds = CGRect(origin: .zero, size: CGSize(width: viewSize.width + 250, height: viewSize.height + 400))
        return controller.view.asImage()
    }
}

#Preview {
    PostComponent(post: Post(postType: .daily, caption: "Hello world", songId: "songId", date: Date(), isAnonymous: false, isActive: true))
}
