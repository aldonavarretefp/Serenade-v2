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
    
    @State private var isLinkActive = false
    
    @State private var sameUser = false
    
    @State private var error: String = ""
    
    var body: some View {
        NavigationStack {
            
            ZStack{
                
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
                    Text(LocalizedStringKey("CompleteYourProfile"))
                        .font(.largeTitle)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text(LocalizedStringKey("FillInYourDetails"))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 40)
                    
                    VStack(alignment: .leading, spacing: 40){
                        VStack(spacing: 20){
                            TextField("", text: $name)
                                .placeholder(when: name.isEmpty) {
                                    Text(LocalizedStringKey("Name"))
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .disableAutocorrection(true)
                            
                            
                            TextField("", text: $tagname)
                                .placeholder(when: tagname.isEmpty) {
                                    Text(LocalizedStringKey("Username"))
                                        .foregroundColor(.gray)
                                }
                                .foregroundStyle(.black)
                                .padding()
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onChange(of: tagname) { oldValue, newValue in
                                    tagname = newValue.lowercased()
                                }
                            
                            if self.error != ""{
                                HStack{
                                    Spacer()
                                    
                                    Image(systemName: "info.circle")
                                    Text(error)
                                    Spacer()
                                }
                                .font(.footnote)
                                .foregroundStyle(.red)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    ActionButton(label: "Next", symbolName: "arrow.forward.circle.fill", fontColor: Color(hex: 0xffffff), backgroundColor: Color(hex: 0xBA55D3), isShareDaily: false, isDisabled: tagname == "" || name == "" || tagname.containsEmoji) {
                        print("Passed name: \(self.name) & passed username: \(self.tagname)")
                        
                        userViewModel.searchUsers(searchText: tagname) { users in
                            if let users, users.count > 0 && tagname != "" {
                                let userFromDB = users[0]
                                guard let user = userViewModel.user else {return}
                                if isSameUserInSession(fromUser: user, toCompareWith: userFromDB) {
                                    if tagname.containsEmoji {
                                        withAnimation {
                                            self.error = "The username can't include emojis. Try again."
                                        }
                                        return
                                    }
                                    sameUser = true
                                    saveUserDetails()
                                } else {
                                    withAnimation {
                                        self.error = "Sorry! \(tagname) is already in use. Please try another one"
                                    }
                                }
                            } else {
                                if tagname.containsEmoji {
                                    withAnimation {
                                        self.error = "The username can't include emojis. Try again."
                                    }
                                    return
                                }
                                saveUserDetails()
                            }
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                if let userName = userViewModel.user?.name {
                    name = userName
                }
            }
            .navigationDestination(isPresented: $isLinkActive) {
                UserDetailsPPictureView()
            }
        }
    }
    
    private func saveUserDetails() {
        tagname = tagname.formattedForTagName
        userViewModel.searchUsers(searchText: tagname) { users in
            
            guard let users = users else { return }
            
            if !users.isEmpty && !sameUser {
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
                
                userViewModel.updateUser(updatedUser: user)
                isLinkActive = true
            }
        }
    }
    
    func isSameUserInSession(fromUser user1: User, toCompareWith user2: User) -> Bool {
        return user1.accountID == user2.accountID
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
