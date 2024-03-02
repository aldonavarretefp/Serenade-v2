//
//  NotificationActionButton.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//

import SwiftUI

struct NotificationActionButton: View {
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Properties
    var icon: String
    var receivedAction: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: receivedAction){
            Image(systemName: icon)
        }
        .bold()
        .font(.footnote)
        .padding(.vertical, icon == "xmark" ? 11 : 10)
        .padding(.horizontal, icon == "xmark" ? 25 : 23)
        .background(icon == "xmark" ? .secondaryButton : .accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .buttonStyle(.plain)
        .foregroundStyle(icon == "xmark" ? (colorScheme == .light ? .black : .white) : .white)
    }
}

#Preview {
    
    Group{
        HStack{
            NotificationActionButton(icon: "checkmark"){
                print("Hello")
            }
            
            NotificationActionButton(icon: "xmark"){
                print("Hello")
            }
        }
        
    }
    
    
}
