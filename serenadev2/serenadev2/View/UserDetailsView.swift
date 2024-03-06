//
//  UserDetailsView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 05/03/24.
//
import Foundation
import SwiftUI

struct UserDetailsView: View {
    @ObservedObject var authManager: AuthManager
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var userId: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) ?? "")
    @State var userName: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userName) ?? "")
    @State var userEmail: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail) ?? "")
    
    @State var tagname: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("User Details")) {
                    TextField("Full Name", text: $userName)
                    TextField("TagName", text: $tagname)

                }
                Button("Save") {
                    saveUserDetails()
                }
            }
            .navigationBarTitle("Edit Details", displayMode: .inline)
        }
    }

    private func saveUserDetails() {
        guard let newUser = User(accountID: userId, name: userName, tagName: tagname, email: userEmail, posts: nil, streak: 0, profilePicture: "", isActive: true)
        else {
            return
        }

        userViewModel.createUser(user: newUser)
        
        print(userViewModel.isLoggedIn)
        
        // Assuming validation and saving are successful:
        authManager.isAuthenticated = true // Update authentication status if needed
    }
}
