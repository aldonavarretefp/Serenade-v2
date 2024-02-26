//
//  UnfriendSheet.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 20/02/24.
//

import SwiftUI

struct UnfriendSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Binding var isFriend: Bool?
    
    var user: User
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Text("Unfriend ") + Text(user.tagName).fontWeight(.semibold) + Text("?")
            }
            .font(.title3)
            .padding()
            Text("Are you sure you want to delete ") + Text(user.tagName).fontWeight(.semibold) + Text(" from your friend list?")
            Spacer()
            HStack {
                Button(action: {dismiss()}, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.secondaryButton)
                            .frame(height: 40)
//                            .padding(5)
                        Text("Cancel")
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                    }
                })
                Button(action: {
//                    removeFriend()
                    isFriend? = false
                    dismiss()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 40)
//                            .padding(5)
                        Text("Delete friend")
                            .foregroundStyle(.white)
                    }
                })
            }
            .fontWeight(.semibold)
            .padding()
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: 350)
        .padding(.horizontal)
        .font(.subheadline)
    }
}

#Preview {
    UnfriendSheet(isFriend: .constant(true), user: sebastian)
}
