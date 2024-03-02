//
//  ActionSheet.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 26/02/24.
//

import SwiftUI

struct ConfirmationSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    typealias Action = () -> Void
    
    var titleStart: LocalizedStringKey
    var titleEnd: LocalizedStringKey?
    var user: String?
    var descriptionStart: LocalizedStringKey
    var boldMessage: LocalizedStringKey?
    var descriptionEnd: LocalizedStringKey?
    var buttonLabel: LocalizedStringKey
    var buttonColor: Color?
    var action: Action? //  Action to be performed by the primary button
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack{
                if let user = user {
                    if let titleEnd = titleEnd {
                        Text(titleStart)
                        
                        + Text(user)
                            .fontWeight(.semibold)
                        + Text(titleEnd)
                    } else {
                        Text(titleStart)
                        
                        + Text(user)
                            .fontWeight(.semibold)
                    }
                } else {
                    Text(titleStart)
                        .fontWeight(.semibold)
                }
            }
            .font(.title3)
            .padding()
            
            if let user = user {
                if let descriptionEnd = descriptionEnd {
                    Text(descriptionStart)
                        + Text(user)
                            .bold()
                        + Text(descriptionEnd)
                } else {
                    Text(descriptionStart)
                        + Text(user)
                            .bold()
                }
            } else if let boldMessage = boldMessage {
                if let descriptionEnd = descriptionEnd {
                    Text(descriptionStart)
                        + Text(boldMessage)
                            .bold()
                        + Text(descriptionEnd)
                } else {
                    Text(descriptionStart)
                        + Text(boldMessage)
                            .bold()
                }
            } else {
                if let descriptionEnd = descriptionEnd {
                    Text(descriptionStart)
                        + Text(descriptionEnd)
                } else {
                    Text(descriptionStart)
                }
            }
            
            Spacer()
            HStack {
                Button(action: {dismiss()}, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.secondaryButton)
                            .frame(height: 40)
                        Text("Cancel")
                            .foregroundStyle(colorScheme == .light ? .black : .white)
                    }
                })
                Button(action: {
                    if action != nil { action!() }
                    dismiss()
                }, label: {
                    ZStack {
                        if buttonColor != nil {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(buttonColor!)
                                .frame(height: 40)
                        }
                        else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.accent)
                                .frame(height: 40)
                        }
                        Text(buttonLabel)
                            .foregroundStyle(.white)
                    }
                })
            }
            .fontWeight(.semibold)
            .padding()
        }
        .multilineTextAlignment(.center)
        //        .frame(maxWidth: 350)
        .padding(.horizontal)
        .font(.subheadline)    }
}

#Preview {
    ConfirmationSheet(titleStart: LocalizedStringKey("UnfriendTitleStart"), titleEnd: LocalizedStringKey("UnfriendTitleEnd"), user: "alex10liva", descriptionStart: LocalizedStringKey("UnfriendDescriptionStart"), descriptionEnd: LocalizedStringKey("UnfriendDescriptionEnd"), buttonLabel: "DeleteFriend")
}
