//
//  SettingsView.swift
//  serenadev2
//
//  Created by Gustavo Sebastian Leon Cortez on 23/02/24.
//

import SwiftUI

struct SettingsView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme

    // MARK: - Body
    var body: some View {
        NavigationStack {
            
            // Background of the view
            ZStack(alignment: .top) {
                Color.viewBackground
                    .ignoresSafeArea()
                VStack(spacing: 10) {
                    
                    // Button to navigate to the edit the profile view
                    GroupBox {
                        if let user = userViewModel.user {
                            NavigationLink(destination: EditProfileView(user: user).toolbarRole(.editor), label: {
                                Image(systemName: "square.and.pencil")
                                    .foregroundStyle(.accent)
                                Text(LocalizedStringKey("EditProfile"))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.callout)
                            })
                        }
                    }
                    .backgroundStyle(.card)
                    .foregroundStyle(.primary)
                    
                    // Button to open the sheet of the favorite streaming apps
                    GroupBox {
                        Button(action: { settingsViewModel.toggleStreamingServiceSheet() }, label: {
                            Image(systemName: "star")
                                .foregroundStyle(.accent)
                            Text(LocalizedStringKey("FavoriteStreamingApps"))
                            Spacer()
                        })
                        .sheet(isPresented: $settingsViewModel.isStreamingServiceSheetDisplayed, content: {
                            StreamingAppPickerSheet()
                                .presentationDetents([.fraction(0.85)])
                        })
                    }
                    .backgroundStyle(.card)
                    .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    // Button to open the sheet to log out
                    GroupBox {
                        Button(action: { settingsViewModel.toggleIsLogOutSheet() }, label: {
                            Spacer()
                            Text(LocalizedStringKey("LogOut"))
                            Spacer()
                        })
                        .sheet(isPresented: $settingsViewModel.isLogOutSheetDisplayed, content: {
                            
                            ConfirmationSheet(titleStart: LocalizedStringKey("LogOut"), descriptionStart: LocalizedStringKey("LogOutMessage"), buttonLabel: LocalizedStringKey("LogOut")){
                            
                                userViewModel.logOut()
                            }
                            .presentationDetents([.fraction(0.3)])
                        })
                    }
                    .backgroundStyle(.card)
                    .foregroundStyle(.primary)
                    
                    // Button to open the delete account sheet
                    /* Remove the comment when we have the option to delete users
                     GroupBox {
                        Button(role: .destructive, action: { settingsViewModel.toggleIsDeleteAccountSheet() }, label: {
                            Spacer()
                            Text(LocalizedStringKey("DeleteAccount"))
                            Spacer()
                        })
                        .sheet(isPresented: $settingsViewModel.isDeleteAccountSheetDisplayed, content: {
                            
                            ConfirmationSheet(titleStart: LocalizedStringKey("DeleteAccount"), descriptionStart: LocalizedStringKey("DeleteAccountDescriptionStart"), boldMessage: LocalizedStringKey("DeleteAccountBoldMessage"), descriptionEnd: LocalizedStringKey("DeleteAccountDescriptionEnd"), buttonLabel: LocalizedStringKey("DeleteAccount"), buttonColor: .red){
                                /*deleteAccount()*/
                            }
                            .presentationDetents([.fraction(0.3)])
                        })
                    }
                    .backgroundStyle(.card)
                     */
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        // Button to show the sheet with the info of the app
                        Button(action: { settingsViewModel.toggleIsInfoSheet() }, label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(.accent)
                                .fontWeight(.bold)
                        })
                        .foregroundStyle(.primary)
                        .sheet(isPresented: $settingsViewModel.isInfoSheetDisplayed, content: {
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
