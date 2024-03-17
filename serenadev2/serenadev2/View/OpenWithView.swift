//
//  OpenWithView.swift
//  Created by Pedro Daniel Rouin Salazar on 21/02/24.
//

import SwiftUI

// View that displays a list of buttons within a navigation stack.
// Each button represents a music streaming platform where a song can be listened to.
struct OpenWithView : View {
    
    // MARK: - ViewModel
    @StateObject private var openWithViewModel: OpenWithViewModel
    
    // MARK: - Environment properties
    @Environment(\.dismiss) var dismiss
    
    // Initializer to pass the parameters to the openWithviewModel
    init(buttonTypes: [ButtonType], songTitle: String, songArtist: String, songId: String) {
        
        // Create an instance of the viewModel with the received parameters
        self._openWithViewModel = StateObject(wrappedValue: OpenWithViewModel(buttonTypes: buttonTypes, songTitle: songTitle, songArtist: songArtist, songId: songId))
    }
    
    
    var body: some View {
        
        NavigationStack {
            ZStack{
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 30){
                    // A text view displaying instructions or information to the user.
                    HStack{
                        Text(LocalizedStringKey("OpenWithDescription"))
                            .fontWeight(.light)
                            .foregroundStyle(.callout)
                        
                        Spacer()
                    }
                    
                    HStack{
                        // This is where the BrandsGrid view is placed, passing in the buttonTypes array.
                        // BrandsGrid is a custom view responsible for displaying the buttons.
                        Spacer()
                        
                        if !openWithViewModel.firstTimeEntering {
                            BrandsGrid(buttonTypes: openWithViewModel.buttonTypes, songTitle: openWithViewModel.songTitle, songArtist: openWithViewModel.songArtist, songId: openWithViewModel.songId)
                        } else {
                            BrandsGrid(buttonTypes: openWithViewModel.filteredButtons, songTitle: openWithViewModel.songTitle, songArtist: openWithViewModel.songArtist, songId: openWithViewModel.songId)
                        }
                        Spacer()
                    }
                    
                    // A spacer is used to push all preceding content to the top.
                    Spacer()
                }
                // Toolbar is used to add navigation bar items.
                .toolbar{
                    // Toolbar item placed on the leading side of the navigation bar.
                    ToolbarItem(placement: .navigationBarLeading){
                        Text(LocalizedStringKey("OpenWith"))
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    // Toolbar item placed on the trailing side of the navigation bar
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
                // Adds horizontal padding to the VStack content.
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    OpenWithView(buttonTypes: [.appleMusic, .spotify, .youtubeMusic, .amazonMusic, .spotify], songTitle: "Runaway", songArtist: "Ye", songId: "")
}

