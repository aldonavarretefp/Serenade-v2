//
//  UserDetailsView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 05/03/24.
//
import Foundation
import SwiftUI

struct UserDetailsView: View {
    
    // MARK: - ViewModel
    @EnvironmentObject private var userViewModel: UserViewModel
    @StateObject private var userDetailsViewModel = UserDetailsViewModel()
    
    // MARK: - Environment properties
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack{
                
                // Background of the view
                LinearGradient(colors: [colorScheme == .light ? .white : Color(hex: 0x101010), Color(hex: 0xBA55D3)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                if colorScheme == .light {
                    Color.white.opacity(0.5)
                        .ignoresSafeArea()
                } else {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                }
                
                VStack (){
                    // Title of the view
                    Text(LocalizedStringKey("CompleteYourProfile"))
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    // Description of the view
                    Text(LocalizedStringKey("FillInYourDetails"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                    
                    // Form
                    VStack(alignment: .leading, spacing: 40){
                        VStack(spacing: 20){
                            // Text field for the user to put his name
                            TextField("", text: $userDetailsViewModel.name)
                                .placeholder(when: userDetailsViewModel.name.isEmpty) {
                                    Text(LocalizedStringKey("Name"))
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .disableAutocorrection(true)
                            
                            // Text field for the user to put his username
                            TextField("", text: $userDetailsViewModel.tagname)
                                .placeholder(when: userDetailsViewModel.tagname.isEmpty) {
                                    Text(LocalizedStringKey("Username"))
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onChange(of: userDetailsViewModel.tagname) { oldValue, newValue in
                                    userDetailsViewModel.tagname = newValue.lowercased()
                                }
                            
                            // If there's an error display it
                            if userDetailsViewModel.error != ""{
                                HStack{
                                    Spacer()
                                    
                                    Image(systemName: "info.circle")
                                    Text(userDetailsViewModel.error)
                                    Spacer()
                                }
                                .font(.footnote)
                                .foregroundStyle(.red)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Button to go to the next part
                    ActionButton(label: "Next", symbolName: "arrow.forward.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color(hex: 0xBA55D3), isShareDaily: false, isDisabled: userDetailsViewModel.tagname == "" || userDetailsViewModel.name == "" || userDetailsViewModel.tagname.containsEmoji) {
                        print("Passed name: \(userDetailsViewModel.name) & passed username: \(userDetailsViewModel.tagname)")
                        
                        // Make a search of the user tagname
                        userViewModel.searchUsers(searchText: userDetailsViewModel.tagname) { users in
                            if let users, users.count > 0 && userDetailsViewModel.tagname != "" {
                                let userFromDB = users[0]
                                guard let user = userViewModel.user else {return}
                                if userViewModel.isSameUserInSession(fromUser: user, toCompareWith: userFromDB) { // If the user is the same user continue
                                    if userDetailsViewModel.tagname.containsEmoji { // If the username has emojis throw error
                                        withAnimation {
                                            userDetailsViewModel.error = "The username can't include emojis. Try again."
                                        }
                                        return
                                    }
                                    userDetailsViewModel.sameUser = true
                                    userDetailsViewModel.saveUserDetails(userViewModel: userViewModel) // Save the user details
                                } else {
                                    withAnimation { // If someone has the unsername throw the error
                                        userDetailsViewModel.error = "Sorry! \(userDetailsViewModel.tagname) is already in use. Please try another one"
                                    }
                                }
                            } else {
                                if userDetailsViewModel.tagname.containsEmoji {  // If the username has emojis throw error
                                    withAnimation {
                                        userDetailsViewModel.error = "The username can't include emojis. Try again."
                                    }
                                    return
                                }
                                userDetailsViewModel.saveUserDetails(userViewModel: userViewModel) // Save the user details
                            }
                        }
                    }
                    
                    // Navigation link to go to the user details profile picture view
                    NavigationLink(destination: UserDetailsPPictureView(), isActive: $userDetailsViewModel.isLinkActive) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .onAppear {
                if let userName = userViewModel.user?.name {
                    userDetailsViewModel.name = userName
                }
            }
        }
    }
}


