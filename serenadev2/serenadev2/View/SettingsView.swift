//
//  SettingsView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 23/02/24.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var isStreamingServiceSheetDisplayed: Bool = false
    @State var isInfoSheetDisplayed: Bool = false
    @State var isLogOutSheetDisplayed: Bool = false
    @State var isDeleteAccountSheetDisplayed: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                VStack(spacing: 10) {
                    GroupBox {
                        NavigationLink(destination: EditProfileView(user: sebastian).toolbarRole(.editor), label: {
                            Image(systemName: "square.and.pencil")
                                .foregroundStyle(.accent)
                            Text("Edit profile")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.callout)
                        })
                    }
                    .backgroundStyle(.card)
                    .foregroundStyle(.primary)
                    
                    GroupBox {
                        Button(action: { isStreamingServiceSheetDisplayed = true }, label: {
                            Image(systemName: "star")
                                .foregroundStyle(.accent)
                            Text("Favorite streaming apps")
                            Spacer()
                        })
                        .sheet(isPresented: $isStreamingServiceSheetDisplayed, content: {
                            StreamingAppPickerSheet()
                                .presentationDetents([.fraction(0.85)])
                        })
                    }
                    .backgroundStyle(.card)
                    .foregroundStyle(.primary)
                    Spacer()
                    GroupBox {
                        Button(action: { isLogOutSheetDisplayed = true }, label: {
                            Spacer()
                            Text("Log out")
                            Spacer()
                        })
                        .sheet(isPresented: $isLogOutSheetDisplayed, content: {
                            ConfirmationSheet(title: Text("Log out").fontWeight(.semibold), string: "Are you sure you want to log out?", action: {/*logOut()*/}, buttonLabel: "Log out")
                                .presentationDetents([.fraction(0.3)])
                        })
                    }
                    .backgroundStyle(.card)
                    .foregroundStyle(.primary)
                    
                    GroupBox {
                        Button(role: .destructive, action: { isDeleteAccountSheetDisplayed = true }, label: {
                            Spacer()
                            Text("Delete account")
                            Spacer()
                        })
                        .sheet(isPresented: $isDeleteAccountSheetDisplayed, content: {
                            ConfirmationSheet(title: Text("Delete account").fontWeight(.semibold), text: Text("Deleting your account is permanent. You will not be able to recover your data. Are you sure you want to ") + Text("delete your account").fontWeight(.semibold) + Text("?"), action: {/*deleteAccount()*/}, buttonLabel: "Delete account", buttonColor: .red)
                                .presentationDetents([.fraction(0.3)])
                        })
                    }
                    .backgroundStyle(.card)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { isInfoSheetDisplayed = true }, label: {
                            Image(systemName: "info.circle")
//                                .font(.title3)
//                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.accent)
                                .fontWeight(.bold)
                        })
                        .foregroundStyle(.primary)
                        .sheet(isPresented: $isInfoSheetDisplayed, content: {
                            AppInfoSheet()
                                .presentationDetents([.fraction(0.7)])
                        })
                    }
                }
                .padding()
                .font(.subheadline)
                .navigationTitle("Settings")
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(colorScheme == .light ? .white : .black,for: .navigationBar)
                .navigationBarTitleDisplayMode(.inline)

            }
        }
    }
}

#Preview {
    SettingsView()
}
