//
//  DailyFromSongView.swift
//  reusbleComponent
//
//  Created by Pedro Daniel Rouin Salazar on 22/02/24.
//

import SwiftUI
import CloudKit



struct DailySongView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @EnvironmentObject private var postViewModel: PostViewModel
    @StateObject private var dailySongViewModel = DailySongViewModel()
    @StateObject private var loadingStateViewModel = LoadingStateViewModel()
    
    // MARK: - Environment properties
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    // Optional to handle the case where no song is selected
    @State var selectedSongBinding: SongModel?
    //State fot the caption
    @FocusState var isTextEditorFocused : Bool
    var isSongFromDaily : Bool
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                
                // Background of the view
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isTextEditorFocused = false
                    }
                
                
                VStack(alignment: .leading, spacing: 30) {
                    Text(LocalizedStringKey("DailyDescription"))
                        .fontWeight(.light)
                        .foregroundStyle(.callout)
                    
                    if let song = selectedSongBinding  {
                        
                        // If comes from daily show button to open the sheet to search for a song
                        if isSongFromDaily {
                            Button(action: {
                                dailySongViewModel.toggleIsPresentingSearchSong()
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
                            .sheet(isPresented: $dailySongViewModel.isPresentingSearchSong) {
                                SelectSongView(song: $selectedSongBinding)
                                    .presentationDetents([.medium, .large])
                            }
                            .buttonStyle(.plain)
                        }
                        else{ // If it doesnt comes from daily show the current selected song
                            
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
                                dailySongViewModel.toggleIsPresentingSearchSong()
                            }
                            .sheet(isPresented: $dailySongViewModel.isPresentingSearchSong) {
                                SelectSongView(song: $selectedSongBinding)
                                    .presentationDetents([.medium, .large])
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(LocalizedStringKey("Caption"))
                                .font(.callout)
                            Spacer()
                            
                            Text("\(dailySongViewModel.caption.count)/\(dailySongViewModel.characterLimit)")
                                .font(.callout)
                                .foregroundColor(dailySongViewModel.caption.count < dailySongViewModel.characterLimit ? .callout : .red)
                        }
                        CaptionComponent(caption: $dailySongViewModel.caption, characterLimit: $dailySongViewModel.characterLimit, isSongFromDaily: false, isTextEditorFocused: $isTextEditorFocused)
                    }
                    Spacer()
                    // Enable the 'Daily' button only if a song is selected
                    
                    ActionButton(label: LocalizedStringKey("Daily"), symbolName: "waveform", fontColor: .white, backgroundColor: .accentColor, isShareDaily: false, isDisabled: selectedSongBinding == nil || loadingStateViewModel.isLoading || postViewModel.isDailyPosted || (postViewModel.dailySong != nil), isLoading: loadingStateViewModel.isLoading) {
                        
                        guard var user = userViewModel.user, let song = selectedSongBinding else {
                            print("ERROR: User does not exist")
                            return
                        }
                        dailySongViewModel.caption = sanitizeText(dailySongViewModel.caption)
                        let reference = CKRecord.Reference(recordID: user.record.recordID, action: .none)
                        let post = Post(postType: .daily, sender: reference, caption: dailySongViewModel.caption,  songId: song.id, date: Date.now, isAnonymous: false, isActive: true)
                        
                        loadingStateViewModel.isLoading = true
                        Task {
                            await postViewModel.verifyDailyPostForUser(user: user)
                            await postViewModel.verifyPostFromYesterdayForUser(user: user)
                            if postViewModel.hasPostedYesterday == false && postViewModel.isDailyPosted == false {
                                user.streak = 0
                            }
                            createPost(user: user, post: post)
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
            }
            .ignoresSafeArea(.keyboard)
            .gesture(
                DragGesture()
                    .onChanged{ gesture in
                        if gesture.translation.height > 0 {
                            // Drag to down
                            
                            isTextEditorFocused = false // Change the state to close the keyboard
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
    
    
    func createPost(user: User, post: Post) {
        var user = user
        // User has tapped on the daily button
        postViewModel.createAPost(post: post) {
            postViewModel.dailySong = selectedSongBinding
            postViewModel.isDailyPosted = true
            user.streak += 1
            userViewModel.updateUser(updatedUser: user)
            userViewModel.addPostToUser(sender: user, post: post)
            loadingStateViewModel.isLoading = false
            self.dismiss()
            print("Shared daily")
        }
    }
    
}
