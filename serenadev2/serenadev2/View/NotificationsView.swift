//
//  NotificationsView.swift
//  serenadev2
//
//  Created by Alejandro Oliva Ochoa on 01/03/24.
//

import SwiftUI

struct NotificationsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.viewBackground
                    .ignoresSafeArea()
                
                VStack{
                    ScrollView{
                        VStack(spacing: 35){
                            NotificationItem(user: User(name: "Sebastian Leon", email: "mail@domain.com", streak: 15, profilePicture: "AfterHoursCoverArt", isActive: true, tagName: "sebatoo"))
                            
                            NotificationItem(user: User(name: "Sebastian Leon", email: "mail@domain.com", streak: 15, profilePicture: "AfterHoursCoverArt", isActive: true, tagName: "sebatoo"))
                        }
                        .padding()
                    }
                }
                .toolbarBackground(.black)
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(colorScheme == .light ? .white : .black,for: .navigationBar)
            .navigationTitle("Notifications")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NotificationsView()
}
