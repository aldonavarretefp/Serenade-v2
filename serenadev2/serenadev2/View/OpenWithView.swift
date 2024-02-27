//
//  OpenWithView.swift
//  Created by Pedro Daniel Rouin Salazar on 21/02/24.
//

import SwiftUI

// View that displays a list of buttons within a navigation stack.
// Each button represents a music streaming platform where a song can be listened to.
struct OpenWithView : View {
    // Property to receive an array of ButtonType.
    // which specifies the different types of buttons that can be displayed in the BrandsGrid.
    var buttonTypes: [ButtonType]

    var body: some View {
       
        NavigationStack {
            
            ZStack{
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .ignoresSafeArea()
                VStack(alignment: .leading){
                    // A text view displaying instructions or information to the user.
                    Text("Listen to this song on the following music streaming platforms")
                        .font(.title3) // Sets the font size and style.
                        .fontWeight(.light) // Sets the weight of the font to light.
                    
                    // This is where the BrandsGrid view is placed, passing in the buttonTypes array.
                    // BrandsGrid is a custom view responsible for displaying the buttons.
                    BrandsGrid(buttonTypes: buttonTypes)
                    
                    // A spacer is used to push all preceding content to the top.
                    Spacer()
                }
                // Toolbar is used to add navigation bar items.
                .toolbar{
                    // Toolbar item placed on the leading side of the navigation bar.
                    ToolbarItem(placement: .navigationBarLeading){
                        Text("Open with")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    // Toolbar item placed on the trailing side of the navigation bar
                    ToolbarItem(placement: .navigationBarTrailing){
                        // An image view displaying a system icon.
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                // Adds horizontal padding to the VStack content.
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    OpenWithView(buttonTypes: [.appleMusic, .spotify, .youtubeMusic, .amazonMusic, .spotify])
}

