//
//  ProfileBar.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 19/02/24.
//

import SwiftUI

struct ProfileBar: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var isSettingsSheetDisplayed: Bool = false
    @State var isUnfriendSheetDisplayed: Bool = false
    @State var isFriendRequestSent: Bool = false
    @State var isCurrentUser: Bool = true
    @State var isFriend: Bool? = true
    
    var body: some View {
        NavigationStack {
            HStack(alignment: .top) {
                ZStack(alignment: .top) {
                    if false {
//                        user.profile_picture
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .clipShape(Circle())
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "flame.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                                .foregroundStyle(.accent)
                            Text("10")  // user.streak
                                .bold()
                                .font(.title3)
                        }                        .padding(5)
                        .background(Color.card.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0), radius: 12.5, x: 0, y: 4)
                        .offset(y: 5)
                    }
                }
                .padding(.trailing)
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            
                            Text("Name Surname")    // user.name
                                .font(.title2)
                                .bold()
                            
                            Text("Username")    // user.username
                                .font(.footnote)
                                .foregroundStyle(.callout)
                            Spacer()
                        }
                        Spacer()
                        if isCurrentUser {
                            Button(action: {
                                isSettingsSheetDisplayed = true
                            }, label: {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            })
                            
                            //                                        .sheet(isPresented: $isSettingsSheetDisplayed){
                            //                                            SettingsView(passedDarkMode: $darkModeToggle)
                            //                                        }
                            .padding(5)
                            .foregroundStyle(.primary)
                        }
                        else {
                            Spacer()
                                .frame(width: 25, height: 25)
                                .padding(5)
                        }
                    }
                    HStack {
                        VStack {
                            Text("55")
                            Text("Posts")
                        }
                        VStack {
                            Text("100")
                            Text("Friends")
                        }
                        .padding(.horizontal)
                        Spacer()
                        if !isCurrentUser {
                            if !isFriend! {
                                if !isFriendRequestSent {
                                    Button(action: {
                                        //                                    sendFriendRequest()
                                        isFriendRequestSent = true
                                    }, label: {
                                        ZStack {
                                            Capsule()
                                            Text("Add friend")
                                                .foregroundStyle(.white)
                                                .fontWeight(.bold)
                                                .font(.headline)
                                        }
                                    })
                                }
                                else {
                                    ZStack {
                                        Capsule()
                                            .fill(.secondaryButton)
                                        Text("Pending")
                                        //                                        .foregroundStyle(.callout)
                                            .fontWeight(.bold)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            else {
                                Button(action: {
                                    isUnfriendSheetDisplayed = true
                                }, label: {
                                    ZStack {
                                        Capsule()
                                            .fill(.secondaryButton)
                                        Image(systemName: "person.fill.checkmark")
                                            .foregroundStyle(colorScheme == .light ? .black : .white)
                                            .font(.headline)
                                    }
                                })
                                .sheet(isPresented: $isUnfriendSheetDisplayed, content: {
                                    UnfriendSheet(isFriend: $isFriend)
                                        .presentationDetents([.fraction(0.3)])
                                })
                            }
                        }
                    }
                    .font(.footnote)
                }
            }
            .padding()
            .frame(height: 130)
            .background()
        }
    }
}

#Preview {
    ProfileBar()
}
