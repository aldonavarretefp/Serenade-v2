//
//  UserDetailsView.swift
//  serenadev2
//
//  Created by Pablo Navarro Zepeda on 05/03/24.
//
import Foundation
import SwiftUI

struct UserDetailsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var authManager: AuthManager
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State var userId: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userID) ?? "")
    @State var userName: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userName) ?? "")
    @State var userEmail: String = (UserDefaults.standard.string(forKey: UserDefaultsKeys.userEmail) ?? "")
    
    @State var tagname: String = ""
    
    var body: some View {
        NavigationView {
            
            ZStack{
                
                LinearGradient(colors: [Color(hex: 0xBA55D3), Color(hex: 0x101010)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack (){
                    Text("Create your profile to get started")
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.bottom, 20)
                    
                    Text("Please fill in your details to personalize your experience")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                    
                    VStack(alignment: .leading, spacing: 40){
                        VStack(spacing: 20){
                            TextField("Full name", text: $userName)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                
                            
                            TextField("Username", text: $tagname)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    Spacer()
                    
                    ActionButton(label: "Create account", symbolName: "arrow.forward.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color(hex: 0xBA55D3), isShareDaily: false, isDisabled: false){
                        saveUserDetails()
                    }
                }
                .padding()
            }
        }
        .foregroundStyle(.white)
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

