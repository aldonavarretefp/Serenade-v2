//
//  ActionButton.swift
//
//  Created by Pedro Daniel Rouin Salazar on 19/02/24.
//

import SwiftUI

struct ActionButton: View {
    
    // Accessing the color scheme environment variable
    @Environment(\.colorScheme) private var colorScheme
    
    // Properties for the button
    var label: LocalizedStringKey    // Text to display on the button
    var symbolName: String           // Name of the SF Symbol to display on the button
    var fontColor: Color             // Color of the text on the button
    var backgroundColor: Color      // Background color of the button
    var isShareDaily : Bool          // Boolean indicating if it's a share daily button
    var isDisabled : Bool
    var isLoading: Bool?
    
    var action: () -> Void           // Action to perform when the button is tapped
    var materialEffect : Material = .thinMaterial  // Material effect for the button
    
    
    var body: some View {
        // Conditionally choose between share daily button and standard button
        if isShareDaily {
            shareDailyButton
        } else {
            standardButton
        }
    }
    
    // View for the share daily button
    private var shareDailyButton: some View {
        let strokeGradient = LinearGradient(gradient:
                                                Gradient(colors: [
                                                    (colorScheme == .light ?
                                                     (Color.black).opacity(0.60) : Color.white).opacity(0.20),
                                                    (colorScheme == .light ?
                                                     (Color.black).opacity(0.52) : Color.white).opacity(0.12)]),
                                            startPoint: .topLeading, endPoint: .bottomTrailing)
        return Button(action: action) {
            HStack {
                
                Image(systemName: symbolName)
                    .font(.title3)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .fontWeight(.medium)
                Text(label)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .fontWeight(.bold)
                
                
            }
        }
        .padding(.horizontal)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.clear)
                .strokeBorder(strokeGradient, lineWidth: 1)
        )
        .background(materialEffect)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.13), radius: 25, x: 0, y: 4)
    }
    
    // View for the standard button
    private var standardButton: some View {
        Button(action: action) {
            // Content of the button
            HStack {
                Spacer()
                if let isLoading, isLoading == true {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .fontWeight(.medium)
                        .font(.title3)
                } else {
                    Image(systemName: symbolName)
                        .font(.title3)
                        .foregroundColor(fontColor)
                        .fontWeight(.medium)
                    Text(label)
                        .foregroundColor(fontColor)
                        .fontWeight(.bold)
                }
                Spacer()
            }
        }
        .padding()
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .disabled(isDisabled)
        .opacity(isDisabled == true ? 0.5:1)
    }
}


struct ActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview Daily button tapped
            ActionButton(label: "Daily", symbolName: "waveform", fontColor: .white, backgroundColor: .accentColor, isShareDaily: false, isDisabled: false) {
                print("Daily button")
                
            }
            .previewDisplayName("Daily button")
            
            // Preview Open with button
            ActionButton(label: "Share daily song", symbolName: "waveform", fontColor: .white, backgroundColor: .accentColor , isShareDaily: true, isDisabled: true ) {
                print("Open with button")
            }
            .previewDisplayName("Open with button")
            
            // Preview Daily button disabled
            ActionButton(label: "Daily", symbolName: "waveform", fontColor: .white, backgroundColor: .accentColor, isShareDaily: false, isDisabled: true ) {
                print("Daily button")
                
            }
            .previewDisplayName("Daily button disabled")
        }
    }
}


