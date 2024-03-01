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
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(icon == "xmark" ? .secondaryButton : .accentColor)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .buttonStyle(.plain)
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
