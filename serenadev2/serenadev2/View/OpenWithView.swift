//
//  OpenWithView.swift
//  Created by Pedro Daniel Rouin Salazar on 21/02/24.
//

import SwiftUI

// View that displays a list of buttons within a navigation stack.
// Each button represents a music streaming platform where a song can be listened to.
struct OpenWithView : View {
    
    // MARK: - Environment properties
    @Environment(\.dismiss) var dismiss
    // Property to receive an array of ButtonType.
    // which specifies the different types of buttons that can be displayed in the BrandsGrid.
    var buttonTypes: [ButtonType]
    var songTitle : String
    var songArtist: String
    var songId: String
    
    @State var selectedAppleMusic = UserDefaults.standard.bool(forKey: "selectedAppleMusic")
    @State var selectedSpotify = UserDefaults.standard.bool(forKey: "selectedSpotify")
    @State var selectedYouTubeMusic = UserDefaults.standard.bool(forKey: "selectedYouTubeMusic")
    @State var firstTimeEntering = UserDefaults.standard.bool(forKey: "firstTimeEntering")
    
    var body: some View {
       
        NavigationStack {
            
            let filteredButtons = buttonTypes.filter {
                if $0 == .appleMusic {
                    return UserDefaults.standard.bool(forKey: "selectedAppleMusic")
                } else if $0 == .spotify {
                    return UserDefaults.standard.bool(forKey: "selectedSpotify")
                } else if $0 == .youtubeMusic {
                    return UserDefaults.standard.bool(forKey: "selectedYouTubeMusic")
                } else {
                    // Si ninguna de las condiciones anteriores se cumple, devolver false (o true según lo que necesites)
                    return false
                }
            }
            
            
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
                        
                        if !firstTimeEntering {
                            BrandsGrid(buttonTypes: buttonTypes, songTitle: songTitle, songArtist: songArtist, songId: songId)
                        } else {
                            BrandsGrid(buttonTypes: filteredButtons, songTitle: songTitle, songArtist: songArtist, songId: songId)
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

