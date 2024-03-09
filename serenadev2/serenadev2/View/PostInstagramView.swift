//
//  PostInstagramView.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 07/03/24.
//

import SwiftUI

struct PostInstagramView: View {
    
    var sender: User?
    var post: Post?
    var song: SongModel?
    var artwork: Image
    var userImage: Image?
    
    var formattedDate: Text {
        let calendar = Calendar.current
        
        if calendar.isDateInToday(post!.date) {
            return Text(LocalizedStringKey("Today"))
        } else if calendar.isDateInYesterday(post!.date) {
            return Text(LocalizedStringKey("Yesterday"))
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            return Text(dateFormatter.string(from: post!.date))
        }
    }
    
    var body: some View {
        
        VStack{
            Spacer()
            
            HStack(){
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
            
            VStack{
                HStack{
                    if let sender = sender {
                        VStack(alignment: .leading){
                            HStack{
                                if let userImage = userImage {
                                    userImage
                                        .resizable()
                                        .scaledToFit()
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
                                
                                
                                Text("\(sender.tagName)")
                                + Text("'s daily song")
                                    .foregroundStyle(.callout)
                            }
                            
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
                    
                    artwork
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 115)
                        .blur(radius: 20.0)
                        .clipShape(UnevenRoundedRectangle(cornerRadii: .init( bottomLeading: 15.0, bottomTrailing: 15.0)))
                    
                    HStack{
                        artwork
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        
                        VStack(alignment: .leading){
                            if let song = song {
                                Text(song.title)
                                    .font(.title2)
                                    .bold()
                                
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
                        ZStack {
                            if let bgColor = song?.bgColor {
                                Rectangle()
                                    .fill(Color(bgColor))
                                
                                Rectangle()
                                    .fill(Color.card.opacity(0.7))
                            } else {
                                Rectangle()
                                    .fill(Color.card.opacity(0.5))
                            }
                        }
                    }
                }
            }
            .background(.card)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal)
            
            
            
            Spacer()
        }
    }
}

#Preview {
    PostInstagramView(artwork: Image(systemName: "xmark"))
}
