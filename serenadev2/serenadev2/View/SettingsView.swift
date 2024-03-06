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
    
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var userViewModel: UserViewModel
    
    
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
                            Text(LocalizedStringKey("EditProfile"))
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
                            Text(LocalizedStringKey("FavoriteStreamingApps"))
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
                            Text(LocalizedStringKey("LogOut"))
                            Spacer()
                        })
                        .sheet(isPresented: $isLogOutSheetDisplayed, content: {
                            
                            ConfirmationSheet(titleStart: LocalizedStringKey("LogOut"), descriptionStart: LocalizedStringKey("LogOutMessage"), buttonLabel: LocalizedStringKey("LogOut")){
//                                isFriend = false
                                authManager.logOut()
                                userViewModel.logOut()
                            }
                            .presentationDetents([.fraction(0.3)])
                        })
                    }
                    .backgroundStyle(.card)
                    .foregroundStyle(.primary)
                    
                    GroupBox {
                        Button(role: .destructive, action: { isDeleteAccountSheetDisplayed = true }, label: {
                            Spacer()
                            Text(LocalizedStringKey("DeleteAccount"))
                            Spacer()
                        })
                        .sheet(isPresented: $isDeleteAccountSheetDisplayed, content: {
                            
                            ConfirmationSheet(titleStart: LocalizedStringKey("DeleteAccount"), descriptionStart: LocalizedStringKey("DeleteAccountDescriptionStart"), boldMessage: LocalizedStringKey("DeleteAccountBoldMessage"), descriptionEnd: LocalizedStringKey("DeleteAccountDescriptionEnd"), buttonLabel: LocalizedStringKey("DeleteAccount"), buttonColor: .red){
                                /*deleteAccount()*/
                            }
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
                .navigationTitle(LocalizedStringKey("Settings"))
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
