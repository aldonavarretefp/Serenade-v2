//
//  NotificationItem.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//

import SwiftUI

struct NotificationItem: View {
    
    // MARK: - Properties
    var user: User
    
    // MARK: - Body
    var body: some View {
        HStack{
            Image(user.profilePicture)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .clipShape(Circle())
                .padding(.trailing, 5)
            
            Text(user.tagName)
                .fontWeight(.semibold)
                .font(.subheadline)
            + Text(" wants to be your friend")
            
            Spacer()
            
            HStack{
                NotificationActionButton(icon: "checkmark"){
                    print("Check")
                }
                
                NotificationActionButton(icon: "xmark"){
                    print("xmark")
                }
            }
            .padding(.leading)
        }
    }
}

#Preview {
    NotificationItem(user: User(name: "Sebastian Leon", email: "mail@domain.com", streak: 15, profilePicture: "AfterHoursCoverArt", isActive: true, tagName: "sebatoo"))
}
