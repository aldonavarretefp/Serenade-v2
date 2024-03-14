//
//  DailyFromSongView.swift
//  reusbleComponent
//
//  Created by Pedro Daniel Rouin Salazar on 22/02/24.
//

import SwiftUI
import CloudKit

struct DailySongView: View {
    
    // MARK: - Environment properties
    @Environment(\.dismiss) var dismiss
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var caption: String = ""
    @State var  characterLimit = 150
    @State private var isPresentingSearchSong = false //for modal presentation of SearchSong
    @State private var isLoading: Bool = false
    @State var song: SongModel? // Optional to handle the case where no song is selected
    //State fot the caption
    @FocusState var isTextEditorFocused : Bool
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var postViewModel: PostViewModel
    
    var isSongFromDaily : Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        hideKeyboard()
                    }
                VStack(alignment: .leading, spacing: 30) {
                    Text(LocalizedStringKey("DailyDescription"))
                        .fontWeight(.light)
                        .foregroundStyle(.callout)
                    
                    if let song = song  {
                        
                        if isSongFromDaily {
                            Button(action: {
                                
                                isPresentingSearchSong = true
                            }) {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(LocalizedStringKey("SelectedSong"))
                                            .font(.callout)
                                        
                                        Spacer()
                                        Text(LocalizedStringKey("ChangeSong"))
                                            .font(.footnote)
                                            .fontWeight(.light)
                                            .foregroundStyle(.callout)
                                    }
                                    ZStack {
                                        Rectangle()
                                            .fill(.ultraThickMaterial)
                                        
                                        ItemSmall(item: ContentItem(isPerson: false, song: song), showArrow: false, comesFromDaily: true)
                                            .padding(.horizontal, 5)
                                    }
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
                                    Text(LocalizedStringKey("SelectedSong"))
                                        .font(.callout)
                                    
                                }
                                ZStack {
                                    Rectangle()
                                        .fill(.ultraThickMaterial)
                                    
                                    ItemSmall(item: ContentItem(isPerson: false, song: song), showArrow: false, comesFromDaily: true)
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
                            Text(LocalizedStringKey("Caption"))
                                .font(.callout)
                            Spacer()
                            
                            Text("\(caption.count)/\(characterLimit)")
                                .font(.callout)
                                .foregroundColor(caption.count < characterLimit ? .callout : .red)
                        }
                        CaptionView(caption: $caption, characterLimit: $characterLimit, isSongFromDaily: false, isTextEditorFocused: $isTextEditorFocused)
                    }
                    Spacer()
                    // Enable the 'Daily' button only if a song is selected
                    
                    ActionButton(label: LocalizedStringKey("Daily"), symbolName: "waveform", fontColor: .white, backgroundColor: .accentColor, isShareDaily: false, isDisabled: song == nil || isLoading || postViewModel.isDailyPosted || (postViewModel.dailySong != nil), isLoading: isLoading) {
                        
                        guard var user = userViewModel.user, let song = song else {
                            print("ERROR: User does not exist")
                            return
                        }
                        caption = sanitizeText(caption)
                        let reference = CKRecord.Reference(recordID: user.record.recordID, action: .none)
                        let post = Post(postType: .daily, sender: reference, caption: self.caption,  songId: song.id, date: Date.now, isAnonymous: false, isActive: true)
                        
                        isLoading = true
                        Task {
                            await postViewModel.verifyDailyPostForUser(user: user)
                            await postViewModel.verifyPostFromYesterdayForUser(user: user)
                            if postViewModel.hasPostedYesterday == false && postViewModel.isDailyPosted == false {
                                user.streak = 0
                            }
                            
                            createAPost(user: user, post: post)
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
            }
            .ignoresSafeArea(.keyboard)
            .gesture(
                DragGesture()
                    .onChanged{gesture in
                        if gesture.translation.height > 0 {
                            // El usuario está arrastrando hacia abajo
                            
                            isTextEditorFocused = false // Cambia el estado de la otra variable
                        }
                    }
                
                
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(LocalizedStringKey("Daily"))
                        .font(.title3)
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
    
    
    func createAPost(user: User, post: Post) {
        var user = user
        // User has tapped on the daily button
        postViewModel.createAPost(post: post) {
            postViewModel.dailySong = song
            postViewModel.isDailyPosted = true
            user.streak += 1
            userViewModel.updateUser(updatedUser: user)
            userViewModel.addPostToUser(sender: user, post: post)
            isLoading = false
            self.dismiss()
            print("Shared daily")
        }
    }
    
}

struct CaptionView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var caption: String
    @Binding var characterLimit: Int
    var isSongFromDaily: Bool
    //@FocusState private var isTextFieldFocused: Bool
    @FocusState.Binding var isTextEditorFocused : Bool
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                Rectangle()
                    .fill(Color.card) // Change this to your actual color variable
                TextEditor(text: $caption)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                //.lineLimit(3)
                    .padding(4)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear) // Set background color to clear
                    .foregroundColor(colorScheme == .light ? .black : .white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .focused($isTextEditorFocused)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onChange(of: caption) {
                        if caption.count > characterLimit {
                            caption = String(caption.prefix(characterLimit))
                        }
                    }
                
                
                
                if caption.isEmpty {
                    Text(LocalizedStringKey ("PlaceholderCaption"))
                        .font(.subheadline)
                        .foregroundColor(.callout) // Placeholder text color
                        .padding()
                        .opacity(isTextEditorFocused ? 0 : 1)
                }
            }
            .frame(width: geo.size.width, height: isSongFromDaily ? geo.size.height * 2/7 : max(geo.size.height * 2/7, 100))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onTapGesture {
                isTextEditorFocused = true
                print($isTextEditorFocused)
            }
        }
    }
}
//function to get the final trimmed caption
extension View{
    
    func sanitizeText(_ text: String) -> String {
        // Esto reemplazará los saltos de línea con puntos
        let replacedText = text.replacingOccurrences(of: "\\n+", with: " ", options: .regularExpression)
        
        return replacedText
    }
    
}

struct SelectSong: View {
    @Environment(\.colorScheme) private var colorScheme
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center) {
                Spacer()
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.title3)
                Text(LocalizedStringKey("SelectSong"))
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


