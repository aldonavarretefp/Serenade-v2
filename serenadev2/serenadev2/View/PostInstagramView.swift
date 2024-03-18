//
//  PostInstagramView.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 07/03/24.
//

import SwiftUI

struct PostInstagramView: View {
    
    // MARK: - Properties
    var sender: User?
    var post: Post?
    var song: SongModel?
    var artwork: Image
    var userImage: Image?
    
    // MARK: - Body
    var body: some View {
        VStack{
            
            Spacer()
            
            // Label with serenade and logo
            HStack{
                if let priColor = song?.priColor{
                    HStack{
                        Image(systemName: "waveform.circle.fill")
                        
                        Text("Serenade")
                            .bold()
                    }
                    .font(.title2)
                    .foregroundStyle(Color(priColor))
                    .padding(.horizontal)
                } else {
                    HStack{
                        Image(systemName: "waveform.circle.fill")
                        
                        Text("Serenade")
                            .bold()
                    }
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                }
                Spacer()
            }
            .opacity(0.9)
            .padding(.horizontal)
            
            // Post
            VStack{
                HStack{
                    if let sender = sender {
                        VStack(alignment: .leading){
                            HStack{
                                // User profile picture
                                if let userImage = userImage {
                                    userImage
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .padding(.trailing, 5)
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundStyle(.white)
                                        .clipShape(Circle())
                                        .frame(height: 28)
                                }
                                
                                // Username
                                Text("\(sender.tagName)")
                                    .bold()
                                + Text("'s daily song")
                                    .foregroundStyle(.callout)
                            }
                            
                            // Caption of the post
                            if let caption = post?.caption {
                                if caption != "" {
                                    Text(caption)
                                }
                            }
                            
                        }
                        .font(.title2)
                    }
                    Spacer()
                }
                .padding()
                
                ZStack{
                    // Artwork of the shared song in the back
                    artwork
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 130)
                        .blur(radius: 10.0)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                    
                    HStack{
                        // Artwork of the shared song in the front
                        artwork
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        
                        // Song info
                        VStack(alignment: .leading){
                            if let song = song {
                                // Title of the song
                                Text(song.title)
                                    .font(.title2)
                                    .bold()
                                
                                // Artist/s of the song
                                Text(song.artists)
                                    .font(.title3)
                                    .foregroundStyle(.callout)
                            }
                        }
                        .padding(.leading)
                        
                        Spacer()
                    }
                    .padding()
                    .background {
                        Rectangle()
                            .fill(Color.card.opacity(0.7))
                    }
                }
                .frame(height: 130)
            }
            .background(.card)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

#Preview {
    PostInstagramView(artwork: Image("AfterHoursCoverArt"))
}
