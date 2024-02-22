//
//  BrandButton.swift
//  serenadev2
//
//  Created by Pedro Daniel Rouin Salazar on 22/02/24.
//

import SwiftUI

// Struct definition for a custom brand button
struct BrandButton : View {
    
    // Environment property to detect color scheme
    @Environment(\.colorScheme) private var colorScheme
    
    // Properties for button customization
    var label: String
    var brandLogo: String
    var fontColor: Color
    var endColor: Color
    var startColor: Color
    var action: () -> Void
    
    // Initializer for the brand button
    init(label: String, brandLogo: String, fontColor: Color,  startColor: Color, endColor: Color, action: @escaping () -> Void) {
        self.label = label
        self.brandLogo = brandLogo
        self.fontColor = fontColor
        self.endColor = endColor
        self.startColor = startColor
        self.action = action
    }
    
    // Body view for the brand button
    var body: some View {
        Button(action: action) {
            VStack{
                HStack {
                    // Geometry reader to adapt image size
                    GeometryReader { geo in
                        Image(brandLogo)
                            .padding(.top, 5)
                            .shadow(color: .black.opacity(0.13), radius: 10, x: 0.0, y: 8.0)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geo.size.width, height: geo.size.height)
                    }
                }
                // Background gradient for the button
                .background(
                    LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .top,
                                   endPoint: .bottom)
                )
                .clipShape(RoundedRectangle(cornerRadius: 15))
                // Label text for the button
                Text(label)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .font(.footnote)
                    .fontWeight(.medium)
            }
        }
    }
}

// Enum to define different types of brand buttons
enum ButtonType: CaseIterable {
    case appleMusic
    case spotify
    case youtubeMusic
    case amazonMusic
    
    // Function to return configured brand buttons based on the enum case
    var configuration: BrandButton {
        switch self {
        case .appleMusic:
            return BrandButton(label: "Apple Music", brandLogo: "AppleMusicBrandLogo", fontColor: .black, startColor: Color("AppleMusicStartColor"), endColor: Color("AppleMusicEndColor")) {
                print("Open Apple Music")
            }
        case .spotify:
            return BrandButton(label: "Spotify", brandLogo: "SpotifyBrandLogo", fontColor: .black, startColor: Color("SpotifyStartColor"), endColor: Color("SpotifyEndColor")) {
                print("Open Spotify")
            }
        case .youtubeMusic:
            return BrandButton(label: "Youtube Music", brandLogo: "YoutubeBrandLogo", fontColor: .black, startColor: Color("YoutubeMusicStartColor"), endColor: Color("YoutubeMusicEndColor")) {
                print("Open Youtube Music")
            }
        case .amazonMusic:
            return BrandButton(label: "Amazon Music", brandLogo: "AmazonMusicBrandLogo", fontColor: .black, startColor: Color("AmazonMusicColor"), endColor: Color("AmazonMusicColor")) {
                print("Open Amazon Music")
            }
        }
    }
}

// Extension to UIScreen to get screen dimensions
extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

// Preview code for BrandButton
#Preview {
    BrandButton(label: "Amazon Music", brandLogo: "AmazonMusicBrandLogo", fontColor: .black, startColor: Color("AmazonMusicColor"), endColor: Color("AmazonMusicColor")) {
        print("Open Amazon Music")
    }
}

