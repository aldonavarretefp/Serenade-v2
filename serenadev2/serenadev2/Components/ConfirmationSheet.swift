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
    
    var title: Text?    //  For using Text() concatenations and modifiers
    var titleString: String?
    var text: Text?    //  For using Text() concatenations and modifiers
    var string: String?
    var action: Action? //  Action to be performed by the primary button
    var buttonLabel: String
    var buttonColor: Color?
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if title != nil {
                    title
                }
                else if titleString != nil {
                    Text(titleString!)
                }
                else {
                    Text("Sheet title")
                }
            }
            .font(.title3)
            .padding()
            if string != nil {
                Text(string!)
                    .padding(.horizontal)
            }
            else if text != nil {
                text
                    .padding(.horizontal)
            }
            else {
                Text("Sheet text")
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
    ConfirmationSheet(title: Text("Unfriend ") + Text("user.tagName").fontWeight(.semibold) + Text("?"), string: "hello", buttonLabel: "delete", buttonColor: .red)
}
