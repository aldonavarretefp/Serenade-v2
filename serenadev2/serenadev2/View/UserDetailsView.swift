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
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    @State private var name: String = ""
    @State var tagname: String = ""
    @State var tagNameRepeated: Bool = false
    
    var body: some View {
        NavigationView {
            
            ZStack{
                
                LinearGradient(colors: [Color(hex: 0xBA55D3), Color(hex: 0x101010)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack (){
                    Text("Complete your profile to get started")
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
                            TextField("", text: $name)
                                .placeholder(when: name.isEmpty) {
                                    Text("Full name")
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            
                            TextField("", text: $tagname)
                                .placeholder(when: tagname.isEmpty) {
                                    Text("Username")
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    Spacer()
                    
                    ActionButton(label: "Complete account", symbolName: "arrow.forward.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color(hex: 0xBA55D3), isShareDaily: false, isDisabled: tagname != "" && name != "" ? false : true){
                        
                        saveUserDetails()
                    }
                }
                .padding()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                // Clear UserDefaults here if leaving UserDetailsView
//                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userID)
//                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userName)
//                UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userEmail)
                // Remove other details as necessary
            }
            .onAppear {
                // Pre-fill the user details if available
                if let userName = userViewModel.user?.name {
                    name = userName
                }
            
            }
            .alert(Text("Tagname already exists."), isPresented: $tagNameRepeated) {
                
            }
        }
        .foregroundStyle(.white)
    }
    
    private func saveUserDetails() {
        userViewModel.searchUsers(tagname: tagname) { users in
            guard let users = users else { return }
            if(!users.isEmpty){
                self.tagNameRepeated = true
                return
            } else {
                self.tagNameRepeated = false
                guard var user = userViewModel.user else {
                    print("No user in DB")
                    return
                }
                user.tagName = tagname
                user.name = name
                userViewModel.tagNameExists = true
                userViewModel.updateUser(updatedUser: user)
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
