//
//  ProfileBar.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 19/02/24.
//

import SwiftUI

struct ProfileBar: View {
    var body: some View {
        NavigationStack {
            HStack(alignment: .top) {
                ZStack(alignment: .top) {
                    if false {
//                        KFImage(URL(string: imageUrl))
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(height: 100)
//                            .clipShape(Circle())
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
                                //.foregroundStyle(.accent)
//                            Text("\(userModel.user?.streak ?? 0)")
                            Text("10")
                                .bold()
                                .font(.title3)
                        }
                        
                        .padding(5)
                        //.background(Color.colorCard.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        //.shadow(color: .black.opacity(colorScheme == .light ? 0.13 : 0), radius: 12.5, x: 0, y: 4)
                        .offset(y: 5)
                    }
                }
                .padding(.trailing)
                VStack(alignment: .leading) {
                    
                    Text("Name Surname")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.callout)
                    
                    if false {
//                        Text("\(username)")
//                            .font(.footnote)
//                            .foregroundStyle(.secondary)
                    } else {
                        Text("Username")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
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
                    }
                    .font(.footnote)
                }
                Spacer()
//                Button(action: {
//                    isSettingsSheetDisplayed = true
//                }, label: {
//                    Image(systemName: "gearshape.fill")
//                })
//                .sheet(isPresented: $isSettingsSheetDisplayed){
//                    SettingsView(passedDarkMode: $darkModeToggle)
//                }
//                .padding(5)
//                .foregroundStyle(.primary)
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
