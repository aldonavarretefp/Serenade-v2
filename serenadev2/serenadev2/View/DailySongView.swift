//
//  DailyFromSongView.swift
//  reusbleComponent
//
//  Created by Pedro Daniel Rouin Salazar on 22/02/24.
//

import SwiftUI

struct DailySongView: View {
    
    // MARK: - Environment properties
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var caption: String = ""
    @State var  characterLimit = 100
    @State private var isPresentingSearchSong = false //for modal presentation of SearchSong
    
    @State var song: SongModel? // Optional to handle the case where no song is selected
    
    var isSongFromDaily : Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 30) {
                    Text("Share your song of the day with all of your friends.")
                        .fontWeight(.light)
                        .foregroundStyle(.callout)
                    
                    if let song = song  {
                        
                        if isSongFromDaily {
                            Button(action: {
                                // This will toggle the state variable to present the sheet
                                printSong(song: song)
                                isPresentingSearchSong = true
                            }) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("Selected song")
                                            .font(.callout)
                                        
                                        Spacer()
                                        Text("Change song")
                                            .font(.footnote)
                                            .fontWeight(.light)
                                            .foregroundStyle(.callout)
                                    }
                                    ZStack {
                                        Rectangle()
                                            .fill(.ultraThickMaterial)
                                        
                                        ItemSmall(item: ContentItem(isPerson: false, song: song), showArrow: false)
                                            .padding(.horizontal, 5)
                                    }
                                    //.background(.viewBackground)
                                    .frame(maxHeight: 60)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                }
                                
                            }
                            .sheet(isPresented: $isPresentingSearchSong) {
                                SelectSongView(song: $song)
                                    .presentationDetents([.medium, .large])
                            }
                            .buttonStyle(.plain)
                        }
                        else{
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Selected song")
                                        .font(.callout)
                                    
                                }
                                ZStack {
                                    Rectangle()
                                        .fill(.ultraThickMaterial)
                                    
                                    ItemSmall(item: ContentItem(isPerson: false, song: song), showArrow: false)
                                        .padding(.horizontal, 5)
                                }
                                .frame(maxHeight: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            
                        }
                        
                    } else {
                        // Display a placeholder when no song is selected
                        VStack(alignment: .leading) {
                            SelectSong{
                                isPresentingSearchSong = true
                            }
                            .sheet(isPresented: $isPresentingSearchSong) {
                                SelectSongView(song: $song)
                                    .presentationDetents([.medium, .large])
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Caption")
                                .font(.callout)
                            Spacer()
                            
                            Text("\(caption.count)/\(characterLimit)")
                                .font(.callout)
                                .foregroundColor(caption.count < characterLimit ? (colorScheme == .dark ? .white : .black) : .red)
                        }
                        CaptionView(caption: $caption, characterLimit: $characterLimit, isSongFromDaily: false)
                    }
                    Spacer()
                    // Enable the 'Daily' button only if a song is selected
                    
                    ActionButton(label: "Daily", symbolName: "waveform", fontColor: .white, backgroundColor: .accentColor, isShareDaily: false, isDisabled: song == nil) {
                        print("Shared daily")
                    }
                    
                }
                .padding(.horizontal)
            }
            .ignoresSafeArea(.keyboard)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Daily")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        // Dismiss the full screen
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.white, .clear)
                            .background(.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
    
    
}


func printSong (song: SongModel){
    print("THIS IS THE RECEIVED SONG \(song)")
}

struct CaptionView: View {
    @Binding var caption: String
    @Binding var characterLimit: Int
    var isSongFromDaily: Bool
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        GeometryReader { geo in
            Button(action: {
                isTextFieldFocused = true
            }) {
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color.card) // Change to the actual color
                    
                    TextField("Let your friends know your melody of the day...", text: $caption)
                                .multilineTextAlignment(.leading)
                                .font(.subheadline)
                                .padding()
                                .foregroundColor(.white) // Adjust as needed; white text may not be visible on a light background
                                .focused($isTextFieldFocused)
                                .onSubmit {
                                    // This will dismiss the keyboard
                                    isTextFieldFocused = false
                                }
                                .onReceive(caption.publisher.collect()) {
                                    self.caption = String($0.prefix(characterLimit))
                                }
                                .toolbar {
                                    // The toolbar is conditionally added based on the focus state
                                    if isTextFieldFocused {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            Spacer()
                                            Button("Done") {
                                                isTextFieldFocused = false
                                            }
                                            .foregroundColor(.accentColor)
                                        }
                                    }
                                }
                }
            }
            .frame(width: geo.size.width, height: isSongFromDaily ? geo.size.height * 2/7 : max(geo.size.height * 2/7, 100)) // Adjust the minimum height as needed
            .cornerRadius(10)
        }
    }
}





struct SelectSong: View {
    @Environment(\.colorScheme) private var colorScheme
    var action: () -> Void
    var body: some View {
        Button(action: action)
        {
            HStack(alignment: .center) {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.title3)
                Text("Select song")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.body)
                    .fontWeight(.semibold)
                Spacer()
            }
            .padding(30) // Add some padding inside the button
            .overlay(
                RoundedRectangle(cornerRadius: 10) // The shape of the border
                    .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, dash: [1, 4])) // The dashed style
                    .foregroundColor(colorScheme == .dark ? .white : .black)// The color of the dashed border
            )
            
        }
        
        .foregroundColor(.white) // The color of the content (icon and text)
    }
}




//MARK: Previews

// Define a wrapper view for preview purposes



struct DailyFromSongView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview without a song
            // DailySongView()
            // .previewDisplayName("No Song Selected")
            
            // Preview with a song
            // DailySongView(song: Song(id: "1", title: "See you again (feat. Kali Uchis)", artist: "Tyler, The Creator, Kali Uchis", album: "Example Album", coverArt: "https://i.scdn.co/image/ab67616d0000b2738940ac99f49e44f59e6f7fb3"), isSongFromDaily: true)
            // .previewDisplayName("With Song Selected")
        }
    }
}


